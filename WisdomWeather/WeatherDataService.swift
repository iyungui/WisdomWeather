//
//  WeatherDataService.swift
//  WisdomWeather
//
//  Created by Yungui Lee on 6/26/24.
//
import Foundation
import WeatherKit
import CoreLocation

// 날씨 서비스 오류 타입
enum WeatherServiceError: Error {
    case failedToFetchWeather
    case locationPermissionDenied
    case networkError
    case unknown
    
    var description: String {
        switch self {
        case .failedToFetchWeather:
            return "날씨 정보를 가져오지 못했습니다."
        case .locationPermissionDenied:
            return "위치 권한이 필요합니다. 설정에서 위치 접근을 허용해주세요."
        case .networkError:
            return "네트워크 연결을 확인해주세요."
        case .unknown:
            return "알 수 없는 오류가 발생했습니다."
        }
    }
}

class WeatherDataService: ObservableObject {
    // WeatherKit 서비스 - 이름 변경하여 혼동 방지
    private let weatherKitService = WeatherService.shared
    
    // 현재 날씨 데이터
    @Published var currentWeather: WeatherData?
    @Published var isLoading = false
    @Published var error: Error?
    
    // 위치에 따른 날씨 정보 가져오기
    func fetchWeather(for location: CLLocation) async throws -> WeatherData {
        do {
            // WeatherKit의 서비스 사용
            let forecast = try await weatherKitService.weather(for: location)
            let currentWeather = forecast.currentWeather
            
            // 날씨 데이터 변환
            let weatherData = WeatherData(
                condition: currentWeather.condition.accessibilityDescription,
                temperature: currentWeather.temperature.value,
                humidity: currentWeather.humidity * 100, // 0-1 값을 퍼센트로 변환
                precipitationIntensity: currentWeather.precipitationIntensity.value,
                windSpeed: currentWeather.wind.speed.value,
                uvIndex: currentWeather.uvIndex.value,
                symbolName: currentWeather.symbolName
            )
            
            // 메인 스레드에서 게시된 프로퍼티 업데이트
            await MainActor.run {
                self.currentWeather = weatherData
                self.error = nil
                self.isLoading = false
            }
            
            return weatherData
        } catch {
            print("Weather fetch error: \(error.localizedDescription)")
            
            await MainActor.run {
                self.error = error
                self.isLoading = false
            }
            
            throw WeatherServiceError.failedToFetchWeather
        }
    }
    
    // 날씨 정보 새로고침
    func refreshWeather(for location: CLLocation) {
        Task {
            await MainActor.run {
                self.isLoading = true
                self.error = nil
            }
            
            do {
                _ = try await fetchWeather(for: location)
            } catch {
                print("Weather refresh failed: \(error)")
            }
        }
    }
}
