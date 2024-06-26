//
//  OutfitRecommender.swift
//  WisdomWeather
//
//  Created by Yungui Lee on 6/26/24.
//

import Foundation
import SwiftUI

struct OutfitRecommender {
    static func recommendOutfit(for weatherData: WeatherData) -> WeatherClothingRecommendation {
        
        var clothingItems = [ClothingItem]()
        var weatherGuides = [WeatherGuide]()
        
        // Temperature + Humidity - based recommendations
        switch (weatherData.temperature, weatherData.humidity) {
        case (28..., _):
            clothingItems.append(contentsOf: [
                ClothingItem(clothingName: "민소매", clothingImage: Image("tankTop")),
                ClothingItem(clothingName: "반팔 티셔츠", clothingImage: Image("shortSleeveTShirt")),
                ClothingItem(clothingName: "반바지", clothingImage: Image("shorts")),
                ClothingItem(clothingName: "짧은 치마", clothingImage: Image("shortSkirt")),
                ClothingItem(clothingName: "린넨 재질 옷", clothingImage: nil)
            ])
        case (23...27, let humidity) where humidity > 60:
            clothingItems.append(contentsOf: [
                ClothingItem(clothingName: "반팔 티셔츠", clothingImage: Image("shortSleeveTShirt")),
                ClothingItem(clothingName: "얇은 셔츠", clothingImage: nil),
                ClothingItem(clothingName: "반바지", clothingImage: Image("shorts"))
            ])
        case (23...27, _):
            clothingItems.append(contentsOf: [
                ClothingItem(clothingName: "얇은 긴팔 티셔츠", clothingImage: nil),
                ClothingItem(clothingName: "면바지", clothingImage: nil)
            ])
        case (20...22, let humidity) where humidity > 60:
            clothingItems.append(contentsOf: [
                ClothingItem(clothingName: "얇은 가디건", clothingImage: nil),
                ClothingItem(clothingName: "셔츠", clothingImage: nil),
                ClothingItem(clothingName: "블라우스", clothingImage: nil)
            ])
        case (20...22, _):
            clothingItems.append(contentsOf: [
                ClothingItem(clothingName: "긴팔 티셔츠", clothingImage: nil),
                ClothingItem(clothingName: "후드티", clothingImage: nil),
                ClothingItem(clothingName: "청바지", clothingImage: Image("jeans"))
            ])
        case (17...19, let humidity) where humidity > 60:
            clothingItems.append(contentsOf: [
                ClothingItem(clothingName: "얇은 재킷", clothingImage: nil),
                ClothingItem(clothingName: "후드티", clothingImage: nil),
                ClothingItem(clothingName: "청바지", clothingImage: Image("jeans"))
            ])
        case (17...19, _):
            clothingItems.append(contentsOf: [
                ClothingItem(clothingName: "얇은 니트", clothingImage: nil),
                ClothingItem(clothingName: "얇은 가디건", clothingImage: nil),
                ClothingItem(clothingName: "긴바지", clothingImage: nil)
            ])
        case (12...16, let humidity) where humidity > 60:
            clothingItems.append(contentsOf: [
                ClothingItem(clothingName: "가디건", clothingImage: nil),
                ClothingItem(clothingName: "기모 후드티", clothingImage: nil),
                ClothingItem(clothingName: "청바지", clothingImage: Image("jeans"))
            ])
        case (12...16, _):
            clothingItems.append(contentsOf: [
                ClothingItem(clothingName: "재킷", clothingImage: nil),
                ClothingItem(clothingName: "야상", clothingImage: nil),
                ClothingItem(clothingName: "면바지", clothingImage: nil),
                ClothingItem(clothingName: "스타킹", clothingImage: nil),
                ClothingItem(clothingName: "니트", clothingImage: nil)
            ])
        case (9...11, let humidity) where humidity > 60:
            clothingItems.append(contentsOf: [
                ClothingItem(clothingName: "야상", clothingImage: nil),
                ClothingItem(clothingName: "점퍼", clothingImage: nil),
                ClothingItem(clothingName: "청바지", clothingImage: Image("jeans"))
            ])
        case (9...11, _):
            clothingItems.append(contentsOf: [
                ClothingItem(clothingName: "재킷", clothingImage: nil),
                ClothingItem(clothingName: "트렌치 코트", clothingImage: nil),
                ClothingItem(clothingName: "기모 바지", clothingImage: nil),
                ClothingItem(clothingName: "니트", clothingImage: nil)
            ])
        case (5...8, let humidity) where humidity > 60:
            clothingItems.append(contentsOf: [
                ClothingItem(clothingName: "가죽 재킷", clothingImage: nil),
                ClothingItem(clothingName: "청바지", clothingImage: Image("jeans")),
                ClothingItem(clothingName: "플리스", clothingImage: nil)
            ])
        case (5...8, _):
            clothingItems.append(contentsOf: [
                ClothingItem(clothingName: "울 코트", clothingImage: nil),
                ClothingItem(clothingName: "레깅스", clothingImage: nil),
                ClothingItem(clothingName: "두꺼운 바지", clothingImage: nil),
                ClothingItem(clothingName: "스카프", clothingImage: nil),
                ClothingItem(clothingName: "내복", clothingImage: nil),
                ClothingItem(clothingName: "니트", clothingImage: nil)
            ])
        case (..<5, _):
            clothingItems.append(contentsOf: [
                ClothingItem(clothingName: "패딩", clothingImage: nil),
                ClothingItem(clothingName: "두꺼운 코트", clothingImage: nil),
                ClothingItem(clothingName: "누빔", clothingImage: nil),
                ClothingItem(clothingName: "내복", clothingImage: nil),
                ClothingItem(clothingName: "목도리", clothingImage: nil),
                ClothingItem(clothingName: "장갑", clothingImage: nil),
                ClothingItem(clothingName: "기모", clothingImage: nil),
                ClothingItem(clothingName: "방한용품", clothingImage: nil)
            ])
        default:
            break
        }
        
        // Precipitation-based recommendations
        if weatherData.precipitationIntensity > 0 {
            if weatherData.temperature < 0 {
                weatherGuides.append(WeatherGuide(message: "눈이 내릴 수 있으니 우산을 꼭 챙기세요!", guideSymbolName: "snowflake"))
            } else {
                weatherGuides.append(WeatherGuide(message: "비가 내릴 수 있으니 우산을 꼭 챙기세요!", guideSymbolName: "cloud.rain.fill"))
            }
        }
        
        // Wind-based recommendations
        if weatherData.windSpeed > 20 {
            if weatherData.temperature < 0 {
                weatherGuides.append(WeatherGuide(message: "바람이 많이 불어요! 패딩을 챙기세요.", guideSymbolName: "wind.snow"))
            } else {
                weatherGuides.append(WeatherGuide(message: "바람이 많이 불어요! 재킷을 챙기세요.", guideSymbolName: "wind"))
            }
        }
        
        // UV index-based recommendations
        if weatherData.uvIndex > 5 {
            weatherGuides.append(WeatherGuide(message: "자외선 지수가 높아요. 선크림을 바르세요.", guideSymbolName: "sun.max.trianglebadge.exclamationmark.fill"))
        }
        
        return WeatherClothingRecommendation(clothingItems: clothingItems, weatherGuides: weatherGuides)
    }
}
