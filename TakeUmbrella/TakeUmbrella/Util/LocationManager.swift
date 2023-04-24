//
//  LocationManager.swift
//  TakeUmbrella
//
//  Created by 표건욱 on 2023/04/25.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationManager()
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
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
            break
            // 권한 획득, 위치 반환
//            if let coordinate = self.myLocation() {
//                passAuth(coordinate)
//            }
        case .restricted, .notDetermined:
            // 아직 결정하지 않은 상태: 시스템 팝업 호출
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            break
            // 거부: 설정 창으로 가서 권한을 변경하도록 유도
//            currentVC.openSettingAlert(title: "확인",
//                                       message: "설정에서 위치권한을 확인해 주세요.")
        default:
            return
        }
    }
    // 내 위치 권한
    func startGetLocation(
//        currentVC: UIViewController,
//                          passAuth: @escaping(CLLocationCoordinate2D) -> Void
    ) {
//        self.locationManager = CLLocationManager()
//        self.currentVC = currentVC
        
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            break
            // 권한 획득, 위치 반환
//            if let coordinate = self.myLocation() {
//                passAuth(coordinate)
//            }
        case .restricted, .notDetermined:
            // 아직 결정하지 않은 상태: 시스템 팝업 호출
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            break
            // 거부: 설정 창으로 가서 권한을 변경하도록 유도
//            currentVC.openSettingAlert(title: "확인",
//                                       message: "설정에서 위치권한을 확인해 주세요.")
        default:
            return
        }
    }
    
    // 내 위치 가져오기
    private func myLocation() -> CLLocationCoordinate2D? {
        // currentVC는 꼭 CLLocationManagerDelegate를 상속받아야 작동함
//        guard let currentVC = self.currentVC as? CLLocationManagerDelegate else { return nil }
//        locationManager.delegate = currentVC
        
        locationManager.startUpdatingLocation()
        
        //위도 경도 가져오기
        let coordinate = locationManager.location?.coordinate
        
        return coordinate
    }
}
