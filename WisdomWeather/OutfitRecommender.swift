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
                ClothingItem(clothingName: NSLocalizedString("Camisole", comment: ""), clothingImage: Image("camisole")),
                ClothingItem(clothingName: NSLocalizedString("T-Shirt", comment: ""), clothingImage: Image("t-shirt")),
                ClothingItem(clothingName: NSLocalizedString("Shorts", comment: ""), clothingImage: Image("shorts")),
                ClothingItem(clothingName: NSLocalizedString("Skirt", comment: ""), clothingImage: Image("skirt"))
            ])
        case (23..<28, let humidity) where humidity > 60:
            clothingItems.append(contentsOf: [
                ClothingItem(clothingName: NSLocalizedString("T-Shirt", comment: ""), clothingImage: Image("t-shirt")),
                ClothingItem(clothingName: NSLocalizedString("Long-Sleeved Shirt", comment: ""), clothingImage: Image("long-sleeved-shirt")),
                ClothingItem(clothingName: NSLocalizedString("Shorts", comment: ""), clothingImage: Image("shorts"))
            ])
        case (23..<28, _):
            clothingItems.append(contentsOf: [
                ClothingItem(clothingName: NSLocalizedString("Pullover", comment: ""), clothingImage: Image("pullover")),
                ClothingItem(clothingName: NSLocalizedString("Pants-Mans", comment: ""), clothingImage: Image("pants-mans"))
            ])
        case (20..<23, let humidity) where humidity > 60:
            clothingItems.append(contentsOf: [
                ClothingItem(clothingName: NSLocalizedString("Cardigan", comment: ""), clothingImage: Image("cardigan")),
                ClothingItem(clothingName: NSLocalizedString("Pullover", comment: ""), clothingImage: Image("pullover")),
                ClothingItem(clothingName: NSLocalizedString("Blouse", comment: ""), clothingImage: Image("blouse"))
            ])
        case (20..<23, _):
            clothingItems.append(contentsOf: [
                ClothingItem(clothingName: NSLocalizedString("Longsleeve", comment: ""), clothingImage: Image("longsleeve")),
                ClothingItem(clothingName: NSLocalizedString("Sweatshirt", comment: ""), clothingImage: Image("sweatshirt")),
                ClothingItem(clothingName: NSLocalizedString("Pants-Mans2", comment: ""), clothingImage: Image("pants-mans2"))
            ])
        case (17..<20, let humidity) where humidity > 60:
            clothingItems.append(contentsOf: [
                ClothingItem(clothingName: NSLocalizedString("Windbreaker", comment: ""), clothingImage: Image("windbreaker")),
                ClothingItem(clothingName: NSLocalizedString("Sweatshirt", comment: ""), clothingImage: Image("sweatshirt")),
                ClothingItem(clothingName: NSLocalizedString("Pants-Mans2", comment: ""), clothingImage: Image("pants-mans2"))
            ])
        case (17..<20, _):
            clothingItems.append(contentsOf: [
                ClothingItem(clothingName: NSLocalizedString("Knit", comment: ""), clothingImage: Image("knit")),
                ClothingItem(clothingName: NSLocalizedString("Cardigan", comment: ""), clothingImage: Image("cardigan")),
                ClothingItem(clothingName: NSLocalizedString("Pants-Mans2", comment: ""), clothingImage: Image("pants-mans2"))
            ])
        case (12..<17, let humidity) where humidity > 60:
            clothingItems.append(contentsOf: [
                ClothingItem(clothingName: NSLocalizedString("Cardigan", comment: ""), clothingImage: Image("cardigan")),
                ClothingItem(clothingName: NSLocalizedString("Sweatshirt", comment: ""), clothingImage: Image("sweatshirt")),
                ClothingItem(clothingName: NSLocalizedString("Pants-Mans2", comment: ""), clothingImage: Image("pants-mans2"))
            ])
        case (12..<17, _):
            clothingItems.append(contentsOf: [
                ClothingItem(clothingName: NSLocalizedString("Anorak", comment: ""), clothingImage: Image("anorak")),
                ClothingItem(clothingName: NSLocalizedString("A-Down-Jacket", comment: ""), clothingImage: Image("a-down-jacket")),
                ClothingItem(clothingName: NSLocalizedString("Pants", comment: ""), clothingImage: Image("pants")),
                ClothingItem(clothingName: NSLocalizedString("Knit", comment: ""), clothingImage: Image("knit"))
            ])
        case (9..<12, let humidity) where humidity > 60:
            clothingItems.append(contentsOf: [
                ClothingItem(clothingName: NSLocalizedString("A-Down-Jacket", comment: ""), clothingImage: Image("a-down-jacket")),
                ClothingItem(clothingName: NSLocalizedString("Jacket", comment: ""), clothingImage: Image("jacket")),
                ClothingItem(clothingName: NSLocalizedString("Pants", comment: ""), clothingImage: Image("pants"))
            ])
        case (9..<12, _):
            clothingItems.append(contentsOf: [
                ClothingItem(clothingName: NSLocalizedString("Jacket", comment: ""), clothingImage: Image("jacket")),
                ClothingItem(clothingName: NSLocalizedString("Duffle-Coat", comment: ""), clothingImage: Image("duffle-coat")),
                ClothingItem(clothingName: NSLocalizedString("Pants", comment: ""), clothingImage: Image("pants")),
                ClothingItem(clothingName: NSLocalizedString("Knit", comment: ""), clothingImage: Image("knit"))
            ])
        case (5..<9, let humidity) where humidity > 60:
            clothingItems.append(contentsOf: [
                ClothingItem(clothingName: NSLocalizedString("Jacket", comment: ""), clothingImage: Image("jacket")),
                ClothingItem(clothingName: NSLocalizedString("Pants", comment: ""), clothingImage: Image("pants")),
                ClothingItem(clothingName: NSLocalizedString("A-Down-Jacket2", comment: ""), clothingImage: Image("a-down-jacket2"))
            ])
        case (5..<9, _):
            clothingItems.append(contentsOf: [
                ClothingItem(clothingName: NSLocalizedString("Duffle-Coat", comment: ""), clothingImage: Image("duffle-coat")),
                ClothingItem(clothingName: NSLocalizedString("Leggings-Womans", comment: ""), clothingImage: Image("leggings-womans")),
                ClothingItem(clothingName: NSLocalizedString("Pants", comment: ""), clothingImage: Image("pants")),
                ClothingItem(clothingName: NSLocalizedString("Scarf", comment: ""), clothingImage: Image("scarf")),
                ClothingItem(clothingName: NSLocalizedString("Pants-Mans3", comment: ""), clothingImage: Image("pants-mans3")),
                ClothingItem(clothingName: NSLocalizedString("Knit", comment: ""), clothingImage: Image("knit"))
            ])
        case (..<5, _):
            clothingItems.append(contentsOf: [
                ClothingItem(clothingName: NSLocalizedString("A-Down-Jacket3", comment: ""), clothingImage: Image("a-down-jacket3")),
                ClothingItem(clothingName: NSLocalizedString("Duffle-Coat", comment: ""), clothingImage: Image("duffle-coat")),
                ClothingItem(clothingName: NSLocalizedString("Pants-Mans3", comment: ""), clothingImage: Image("pants-mans3")),
                ClothingItem(clothingName: NSLocalizedString("Scarf", comment: ""), clothingImage: Image("scarf")),
                ClothingItem(clothingName: NSLocalizedString("Mittens", comment: ""), clothingImage: Image("mittens")),
                ClothingItem(clothingName: NSLocalizedString("Beanie", comment: ""), clothingImage: Image("beanie")),
                ClothingItem(clothingName: NSLocalizedString("Socks", comment: ""), clothingImage: Image("socks"))
            ])
        default:
            break
        }
        
        // Precipitation-based recommendations
        if weatherData.precipitationIntensity > 0 {
            if weatherData.temperature < 0 {
                weatherGuides.append(WeatherGuide(message: NSLocalizedString("Snowy", comment: ""), guideSymbolName: "snowflake"))
            } else {
                weatherGuides.append(WeatherGuide(message: NSLocalizedString("Rainy", comment: ""), guideSymbolName: "cloud.rain.fill"))
            }
        }
        
        // Wind-based recommendations
        if weatherData.windSpeed > 20 {
            if weatherData.temperature < 0 {
                weatherGuides.append(WeatherGuide(message: NSLocalizedString("Windy with Padding", comment: ""), guideSymbolName: "wind.snow"))
            } else {
                weatherGuides.append(WeatherGuide(message: NSLocalizedString("Windy with Jacket", comment: ""), guideSymbolName: "wind"))
            }
        }
        
        // UV index-based recommendations
        if weatherData.uvIndex > 2 {
            weatherGuides.append(WeatherGuide(message: NSLocalizedString("High UV", comment: ""), guideSymbolName: "sun.max.trianglebadge.exclamationmark.fill"))
        }
        
        return WeatherClothingRecommendation(clothingItems: clothingItems, weatherGuides: weatherGuides)
    }
}


