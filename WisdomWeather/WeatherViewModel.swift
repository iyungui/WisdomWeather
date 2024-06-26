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
    private let locationManger = LocationManager()
    private let weatherService = WeatherService.shared
    
    @Published var weatherData: WeatherData?
    @Published var cityName: String?
    @Published var error: Error?

    private var locationCancellable: AnyCancellable?
    private var errorCancellable: AnyCancellable?
    private var cityNameCancellable: AnyCancellable?
    
    init() {
        locationCancellable = locationManger.$location.sink { [weak self] location in
            guard let self = self, let location = location else {
                return
            }
            Task {
                await self.fetchWeather(for: location)
            }
        }
    }
    
    func fetchWeather(for location: CLLocation) async {
        do {
            let forecast = try await weatherService.weather(for: location)
            let currentWeather = forecast.currentWeather
            self.weatherData = self.convertToWeatherData(currentWeather: currentWeather)
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
    
    func recommendOutfit(for weatherData: WeatherData) -> WeatherClothingRecommendation {
        return OutfitRecommender.recommendOutfit(for: weatherData)
    }
}

