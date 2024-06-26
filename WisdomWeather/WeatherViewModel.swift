//
//  WeatherViewModel.swift
//  WisdomWeather
//
//  Created by Yungui Lee on 6/26/24.
//

import Foundation
import WeatherKit
import Combine
import CoreLocation

class WeatherViewModel: ObservableObject {
    private let locationManager = LocationManager()
    private let weatherService = WeatherService.shared
    
    @Published var weatherData: WeatherData?
    @Published var weatherGuides: [WeatherGuide] = []
    @Published var clothingItems: [ClothingItem] = []
    @Published var cityName: String?
    @Published var error: Error?
    
    private var locationCancellable: AnyCancellable?
    private var errorCancellable: AnyCancellable?
    private var cityNameCancellable: AnyCancellable?
    private var authorizationStatusCancellable: AnyCancellable?

    init() {
        locationCancellable = locationManager.$location.sink { [weak self] location in
            guard let self = self, let location = location else {
                return
            }
            Task {
                await self.fetchWeather(for: location)
                await self.recommendOutfit()
            }
        }
        errorCancellable = locationManager.$error.sink { [weak self] error in
            self?.error = error
        }
        
        cityNameCancellable = locationManager.$cityName.sink { [weak self] cityName in
            self?.cityName = cityName
        }
        
        authorizationStatusCancellable = locationManager.$authorizationStatus.sink { [weak self] status in
            guard let self = self, status == .authorizedWhenInUse || status == .authorizedAlways else {
                return
            }
            self.requestLocation()
        }
    }
    
    func requestLocation() {
        locationManager.requestLocation()
    }
    
    @MainActor
    func fetchWeather(for location: CLLocation) async {
        do {
            let forecast = try await weatherService.weather(for: location)
            let currentWeather = forecast.currentWeather
            self.weatherData = self.convertToWeatherData(currentWeather: currentWeather)
            print(weatherData ?? "Cannot found Weather Data!!")
        } catch {
            self.error = error
        }
    }
    
    private func convertToWeatherData(currentWeather: CurrentWeather) -> WeatherData {
        return WeatherData(
            condition: currentWeather.condition.rawValue,
            temperature: currentWeather.temperature.value,
            humidity: currentWeather.humidity,
            precipitationIntensity: currentWeather.precipitationIntensity.value,
            windSpeed: currentWeather.wind.speed.value,
            uvIndex: currentWeather.uvIndex.value,
            symbolName: currentWeather.symbolName
        )
    }
    
    @MainActor
    func recommendOutfit() async {
        guard let weatherData = weatherData else { return }
        let recommendation = OutfitRecommender.recommendOutfit(for: weatherData)
        self.clothingItems = recommendation.clothingItems
        self.weatherGuides = recommendation.weatherGuides
    }
}

