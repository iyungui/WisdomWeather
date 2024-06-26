//
//  LocationManager.swift
//  WisdomWeather
//
//  Created by Yungui Lee on 6/26/24.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    private let geocoder = CLGeocoder()

    @Published var location: CLLocation?
    @Published var cityName: String?
    @Published var error: Error?

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
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
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
}
