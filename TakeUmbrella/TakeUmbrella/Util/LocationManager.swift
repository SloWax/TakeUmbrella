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
    
    func loadLocation() -> (lat: String, lon: String) {
        let coor = locationManager.location?.coordinate
        let lat = String(coor?.latitude ?? CLLocationDegrees())
        let lon = String(coor?.longitude ?? CLLocationDegrees())
        
        return (lat, lon)
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
