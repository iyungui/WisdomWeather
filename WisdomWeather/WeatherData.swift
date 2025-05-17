//
//  WeatherModels.swift
//  WisdomWeather
//
//  Created by Yungui Lee on 6/26/24.
//

import Foundation
import SwiftUI

// 날씨 데이터 모델
struct WeatherData: Identifiable, Equatable {
    let id = UUID()
    let condition: String
    let temperature: Double
    let humidity: Double
    let precipitationIntensity: Double
    let windSpeed: Double
    let uvIndex: Int
    let symbolName: String
}

// 의류 추천 아이템
struct ClothingItem: Identifiable {
    let id = UUID()
    let clothingName: String
    let clothingImage: Image?
}

// 날씨 가이드 모델
struct WeatherGuide: Identifiable {
    let id = UUID()
    let message: String
    let guideSymbolName: String
}

// 의류 추천 결과 모델
struct WeatherClothingRecommendation {
    let clothingItems: [ClothingItem]
    let weatherGuides: [WeatherGuide]
}

// 유틸리티 함수들
// 온도에 따른 배경색 반환
func getBackgroundColor(for temperature: Double) -> Color {
    switch temperature {
    case 28...:
        return Color("ExtremeHot")
    case 23..<28:
        return Color("VeryHot")
    case 20..<23:
        return Color("Warm")
    case 17..<20:
        return Color("Mild")
    case 12..<17:
        return Color("Cool")
    case 9..<12:
        return Color("Cold")
    case 5..<9:
        return Color("VeryCold")
    case ..<5:
        return Color("ExtremeCold")
    default:
        return Color.white
    }
}

// 온도에 따른 텍스트 색상 반환
func getTextColor(for temperature: Double) -> Color {
    switch temperature {
    case 28...:
        return Color.white
    case 23..<28:
        return Color.white
    case 20..<23:
        return Color.black
    case 17..<20:
        return Color.black
    case 12..<17:
        return Color.black
    case 9..<12:
        return Color.white
    case 5..<9:
        return Color.white
    case ..<5:
        return Color.white
    default:
        return Color.black
    }
}
