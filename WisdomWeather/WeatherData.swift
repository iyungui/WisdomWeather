//
//  WeatherData.swift
//  WisdomWeather
//
//  Created by Yungui Lee on 6/26/24.
//

import Foundation

struct WeatherData: Identifiable {
    let id = UUID()
    let condition: String
    let temperature: Double
    let humidity: Double    //
    let precipitationIntensity: Double  //
    let windSpeed: Double
//    let windDirection: String
//    let isDaylight: Bool
    let uvIndex: Int
    let symbolName: String
}
