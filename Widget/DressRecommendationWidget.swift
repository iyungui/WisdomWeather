//
//  Widget.swift
//  Widget
//
//  Created by Yungui Lee on 6/27/24.
//

import WidgetKit
import SwiftUI
import CoreLocation
import WeatherKit

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> WeatherDataEntry {
        WeatherDataEntry(
            date: Date(),
            condition: "Rainy",
            temperature: 19.9,
            humidity: 20,
            precipitationIntensity: 1,
            windSpeed: 21,
            uvIndex: 5,
            symbolName: "cloud.rain.fill",
            clothingItems: ClothingItem.sample,
            cityName: "NONE"
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (WeatherDataEntry) -> ()) {
        fetchWeatherData { weatherEntry in
            let entry = weatherEntry ?? WeatherDataEntry(
                date: Date(),
                condition: "Rainy",
                temperature: 19.9,
                humidity: 20,
                precipitationIntensity: 1,
                windSpeed: 21,
                uvIndex: 5,
                symbolName: "cloud.rain.fill",
                clothingItems: ClothingItem.sample,
                cityName: "NONE"
            )
            completion(entry)
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<WeatherDataEntry>) -> ()) {
        fetchWeatherData { weatherEntry in
            let currentDate = Date()
            var entries: [WeatherDataEntry] = []

            for hourOffset in 0 ..< 5 {
                let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
                let entry = weatherEntry ?? WeatherDataEntry(
                    date: entryDate,
                    condition: "Rainy",
                    temperature: 19.9,
                    humidity: 20,
                    precipitationIntensity: 1,
                    windSpeed: 21,
                    uvIndex: 5,
                    symbolName: "cloud.rain.fill",
                    clothingItems: ClothingItem.sample,
                    cityName: "NONE"
                )
                entries.append(entry)
            }

            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }

    private func fetchWeatherData(completion: @escaping (WeatherDataEntry?) -> Void) {
        guard let location = getLocationFromAppGroup() else {
            completion(nil)
            return
        }

        Task {
            do {
                let weather = try await WeatherKit.WeatherService().weather(for: location)
                let currentWeather = weather.currentWeather

                let recommendationClothing = OutfitRecommender.recommendOutfit(currentWeather: currentWeather)

                let weatherEntry = WeatherDataEntry(
                    date: Date(),
                    condition: currentWeather.condition.rawValue,
                    temperature: currentWeather.temperature.value,
                    humidity: currentWeather.humidity,
                    precipitationIntensity: currentWeather.precipitationIntensity.value,
                    windSpeed: currentWeather.wind.speed.value,
                    uvIndex: currentWeather.uvIndex.value,
                    symbolName: currentWeather.symbolName,
                    clothingItems: recommendationClothing,
                    cityName: "City Name"   // TODO: FETCH CITY NAME
                )
                completion(weatherEntry)
            } catch {
                print("Failed to fetch weather data: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }

    private func getLocationFromAppGroup() -> CLLocation? {
        let userDefaults = UserDefaults(suiteName: "group.com.iyungui.WisdomWeather")
        let latitude = userDefaults?.double(forKey: "latitude")
        let longitude = userDefaults?.double(forKey: "longitude")
        
        if let latitude = latitude, let longitude = longitude, latitude != 0, longitude != 0 {
            return CLLocation(latitude: latitude, longitude: longitude)
        }
        return nil
    }
}


// MARK: - ENTRY

struct WeatherDataEntry: TimelineEntry {
    let date: Date
    
    let condition: String
    let temperature: Double
    let humidity: Double
    let precipitationIntensity: Double
    let windSpeed: Double
    let uvIndex: Int
    let symbolName: String
    
    var backgroundColor: Color {
        getBackgroundColor(for: temperature)
    }
    
    var textColor: Color {
        getTextColor(for: temperature)
    }
    
    let clothingItems: [ClothingItem]
    
    let cityName: String
}

struct ClothingItem: Identifiable {
    let id = UUID()
    let clothingName: String
    let clothingImage: Image?
}

extension ClothingItem {
    static var sample: [ClothingItem] = [
        ClothingItem(clothingName: "A-Down-Jacket3", clothingImage: Image("a-down-jacket3")),
        ClothingItem(clothingName: "Duffle-Coat", clothingImage: Image("duffle-coat")),
        ClothingItem(clothingName: "Pants-Mans3", clothingImage: Image("pants-mans3")),
        ClothingItem(clothingName: "Scarf", clothingImage: Image("scarf")),
    ]
}

// TODO: GUIDE WIDGET
//    struct WeatherGuide: Identifiable {
//        let id = UUID()
//        let message: String
//        let guideSymbolName: String
//    }
//
//    struct WeatherClothingRecommendation {
//        let clothingItems: [ClothingItem]
//        let weatherGuides: [WeatherGuide]
//    }

extension WeatherDataEntry {
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
}


// MARK: - 기온별 옷차림 추천 위젯

struct DressRecommendationEntryView: View {
    var entry: WeatherDataEntry

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text(String(format: "%.1f", entry.temperature))
                Image(systemName: entry.symbolName)
            }
            .font(.subheadline)
            .fontWeight(.medium)
            
            HStack {
                entry.clothingItems.last?.clothingImage?
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30)
                Text(entry.clothingItems.last?.clothingName ?? "Unknown")
                    .font(.system(size: 20))
            }
                
            Text(entry.cityName)
                .font(.subheadline)
        }
        .foregroundStyle(entry.textColor)
    }
}


struct DressRecommendationWidget: Widget {
    let kind: String = "com.WeatherWisdom.Widget-dress-recommend"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                DressRecommendationEntryView(entry: entry)
                    .containerBackground(entry.backgroundColor, for: .widget)
            } else {
                DressRecommendationEntryView(entry: entry)
                    .padding()
                    .background(entry.backgroundColor)
            }
        }
        .configurationDisplayName("Dress Recommendation")
        .description("This recommends dressing according to your current weather.")
    }
}

// MARK: - 현재 날씨 위젯

struct CurrentWeatherEntryView: View {
    var entry: WeatherDataEntry

    var body: some View {
        VStack(spacing: 10) {
            Text(String(format: "%.1f", entry.temperature))
                .font(.title)
                .fontWeight(.semibold)
            
            Label(entry.condition, systemImage: entry.symbolName)
                .font(.title3)
                .fontWeight(.medium)
            
            Text(entry.cityName)
                .font(.subheadline)
        }
        .foregroundStyle(entry.textColor)
    }
}


struct CurrentWeatherWidget: Widget {
    let kind: String = "com.WeatherWisdom.Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                CurrentWeatherEntryView(entry: entry)
                    .containerBackground(entry.backgroundColor, for: .widget)
            } else {
                CurrentWeatherEntryView(entry: entry)
                    .padding()
                    .background(entry.backgroundColor)
            }
        }
        .configurationDisplayName("Current Weather")
        .description("This widget shows the current weather information.")
    }
}



// MARK: - PREVIEWS

#Preview(as: .systemSmall) {
    DressRecommendationWidget()
} timeline: {
    WeatherDataEntry(date: Date(), condition: "Rainy", temperature: 14.9, humidity: 20, precipitationIntensity: 1, windSpeed: 21, uvIndex: 5, symbolName: "cloud.rain.fill", clothingItems: ClothingItem.sample, cityName: "Seoul")
    WeatherDataEntry(date: Date(), condition: "Rainy", temperature: 19.9, humidity: 20, precipitationIntensity: 1, windSpeed: 21, uvIndex: 5, symbolName: "cloud.rain.fill", clothingItems: ClothingItem.sample, cityName: "Seoul")
}

#Preview(as: .systemSmall) {
    CurrentWeatherWidget()
} timeline: {
    WeatherDataEntry(date: Date(), condition: "Snow", temperature: 9.9, humidity: 20, precipitationIntensity: 1, windSpeed: 21, uvIndex: 5, symbolName: "snowflake", clothingItems: ClothingItem.sample, cityName: "Seoul")
}






// MARK: - OUTFIT RECOMMENDER

struct OutfitRecommender {
    static func recommendOutfit(currentWeather: CurrentWeather) -> [ClothingItem] {
        
        var clothingItems = [ClothingItem]()
        
        // Temperature + Humidity - based recommendations
        switch (currentWeather.temperature.value, currentWeather.humidity) {
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
        return clothingItems
    }
}
