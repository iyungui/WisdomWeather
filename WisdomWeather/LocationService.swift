//
//  LocationService.swift
//  WisdomWeather
//

import CoreLocation
import SwiftUI

class LocationService: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    private let geocoder = CLGeocoder()

    @Published var location: CLLocation?
    @Published var cityName: String?
    @Published var error: Error?
    @Published var authorizationStatus: CLAuthorizationStatus?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        // 현재 권한 상태 확인 및 게시
        authorizationStatus = manager.authorizationStatus
        
        // 권한이 없는 경우에만 요청
        if manager.authorizationStatus == .notDetermined {
            manager.requestWhenInUseAuthorization()
        }
    }
    
    func requestLocation() {
        // 현재 권한 상태에 따라 처리
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            print("Location permission granted, requesting location...")
            manager.requestLocation()
        case .denied, .restricted:
            let error = NSError(
                domain: "LocationService",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "위치 액세스가 거부되었습니다. 설정에서 위치 권한을 허용해주세요."]
            )
            self.error = error
            print("Location permission denied")
        case .notDetermined:
            print("Location permission not determined, requesting permission...")
            manager.requestWhenInUseAuthorization()
        @unknown default:
            print("Unknown authorization status")
        }
    }
    
    // 위치 업데이트 시 호출
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("Location updated: \(location.coordinate.latitude), \(location.coordinate.longitude)")
            self.location = location
            saveLocationToAppGroup()
            fetchCityName(from: location)
        }
    }
    
    // 위치 오류 발생 시 호출
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager error: \(error.localizedDescription)")
        
        // CLError 타입 체크 및 처리
        if let clError = error as? CLError {
            switch clError.code {
            case .denied:
                // 위치 서비스가 거부된 경우
                self.error = NSError(
                    domain: "LocationService",
                    code: 1,
                    userInfo: [NSLocalizedDescriptionKey: "위치 액세스가 거부되었습니다. 설정에서 위치 권한을 허용해주세요."]
                )
            case .network:
                // 네트워크 문제
                self.error = NSError(
                    domain: "LocationService",
                    code: 2,
                    userInfo: [NSLocalizedDescriptionKey: "네트워크 연결을 확인해주세요."]
                )
            default:
                self.error = error
            }
        } else {
            self.error = error
        }
    }
    
    // 도시 이름 가져오기
    private func fetchCityName(from location: CLLocation) {
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                self.error = error
                return
            }
            
            if let placemark = placemarks?.first {
                // locality가 nil인 경우 대체 값 사용
                if let locality = placemark.locality {
                    self.cityName = locality
                    print("City name found: \(locality)")
                } else if let name = placemark.name {
                    self.cityName = name
                    print("Location name found: \(name)")
                } else if let administrativeArea = placemark.administrativeArea {
                    self.cityName = administrativeArea
                    print("Administrative area found: \(administrativeArea)")
                }
            } else {
                print("No placemark found")
            }
        }
    }
    
    // 권한 상태 변경 시 호출
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.authorizationStatus = status
        print("Location authorization changed to: \(status.rawValue)")
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            // 권한이 부여되면 위치 요청
            print("Location permission granted, requesting location...")
            requestLocation()
        case .denied, .restricted:
            self.error = NSError(
                domain: "LocationService",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "위치 액세스가 거부되었습니다. 설정에서 위치 권한을 허용해주세요."]
            )
            print("Location permission denied or restricted")
        case .notDetermined:
            print("Location permission not determined")
        @unknown default:
            print("Unknown authorization status: \(status.rawValue)")
        }
    }
    
    // App Group에 위치 저장
    private func saveLocationToAppGroup() {
        guard let location = location else { return }
        
        if let userDefaults = UserDefaults(suiteName: "group.me.iyungui.WisdomWeather") {
            userDefaults.set(location.coordinate.latitude, forKey: "latitude")
            userDefaults.set(location.coordinate.longitude, forKey: "longitude")
            userDefaults.synchronize()
            print("Location saved to app group: \(location.coordinate.latitude), \(location.coordinate.longitude)")
        } else {
            print("Failed to access app group user defaults")
        }
    }
}
