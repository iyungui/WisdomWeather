//
//  LocationManager.swift
//  WisdomWeather
//
//  Created by Yungui Lee on 6/26/24.
//

import CoreLocation
import SwiftUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    private let geocoder = CLGeocoder()

    @Published var location: CLLocation? {
        didSet {
            saveLocationToAppGroup()
        }
    }
    @Published var cityName: String?
    @Published var error: Error?
    @Published var authorizationStatus: CLAuthorizationStatus?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
    }
    
    func requestLocation() {
        manager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.location = location
            fetchCityName(from: location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.error = error
    }
    
    private func fetchCityName(from location: CLLocation) {
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                self.error = error
                return
            }
            
            if let placemark = placemarks?.first {
                self.cityName = placemark.locality
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.authorizationStatus = status
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        case .denied, .restricted:
            self.error = NSError(domain: "LocationManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Location access denied"])
        default:
            break
        }
    }
    
    private func saveLocationToAppGroup() {
        guard let location = location else { return }
        let userDefaults = UserDefaults(suiteName: "group.com.iyungui.WisdomWeather")
        userDefaults?.set(location.coordinate.latitude, forKey: "latitude")
        userDefaults?.set(location.coordinate.longitude, forKey: "longitude")
    }
}

