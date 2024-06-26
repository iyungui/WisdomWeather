//
//  WeatherClothingRecommendation.swift
//  WisdomWeather
//
//  Created by Yungui Lee on 6/26/24.
//

import Foundation
import SwiftUI

struct ClothingItem: Identifiable {
    let id = UUID()
    let clothingName: String
    let clothingImage: Image?
}

struct WeatherGuide: Identifiable {
    let id = UUID()
    let message: String
    let guideSymbolName: String
}

struct WeatherClothingRecommendation {
    let clothingItems: [ClothingItem]
    let weatherGuides: [WeatherGuide]
}
