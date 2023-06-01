//
//  LocationManager.swift
//  TakeUmbrella
//
//  Created by 표건욱 on 2023/04/25.
//

import Foundation
import CoreLocation
import RxSwift
import RxCocoa


class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationManager()
    
    private let locationManager = CLLocationManager()
    
    let bindAuth = PublishRelay<LocationAuth>()
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func request() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            
            bindAuth.accept(.auth)
        case .notDetermined, .restricted:
            
            bindAuth.accept(.notDetermined)
        case .denied:
            
            bindAuth.accept(.denied)
        default:
            return
        }
    }
    
    func loadLocation() -> (lat: CLLocationDegrees, lon: CLLocationDegrees) {
        let coor = locationManager.location?.coordinate
        let lat = coor?.latitude ?? CLLocationDegrees()
        let lon = coor?.longitude ?? CLLocationDegrees()
        
        return (lat, lon)
    }
    
    func loadAddress(coor: (lat: CLLocationDegrees, lon: CLLocationDegrees)) -> Observable<(local: String, subLocal: String)> {
        return Observable.create { observer -> Disposable in
            let geocoder = CLGeocoder()
            let location = CLLocation(latitude: coor.lat, longitude: coor.lon)
            let locale = Locale(identifier: "Ko-kr") // [나라 코드 설정]
                    
            geocoder.reverseGeocodeLocation(location, preferredLocale: locale) { mark, error in
                if let error = error {
                    
                    observer.onError(error)
                } else if let address = mark?.last {
                    
                    let locality = address.locality ?? ""
                    let subLocality = address.subLocality ?? ""
                    
                    observer.onNext((locality, subLocality))
                    observer.onCompleted()
                }
            }
            
            return Disposables.create()
        }
        
//        (lldb)  po address.last?.administrativeArea
//        ▿ Optional<String>
//          - some : "경기도"
//
//        (lldb)  po address.last?.locality
//        ▿ Optional<String>
//          - some : "용인시"
//
//        (lldb)  po address.last?.subLocality
//        ▿ Optional<String>
//          - some : "상하동"
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:

            bindAuth.accept(.auth)
        case .restricted, .notDetermined:

            bindAuth.accept(.notDetermined)
        case .denied:

            bindAuth.accept(.denied)
        default:
            return
        }
    }
}
