//
//  Widget.swift
//  Widget
//
//  Created by Yungui Lee on 6/27/24.
//

import WidgetKit
import SwiftUI

// MARK: - PROVIDER

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> WeatherDataEntry {
        WeatherDataEntry(date: Date(), condition: "Rainy", temperature: 19.9, humidity: 20, precipitationIntensity: 1, windSpeed: 21, uvIndex: 5, symbolName: "cloud.rain.fill")
    }

    func getSnapshot(in context: Context, completion: @escaping (WeatherDataEntry) -> ()) {
        let entry = WeatherDataEntry(date: Date(), condition: "Rainy", temperature: 19.9, humidity: 20, precipitationIntensity: 1, windSpeed: 21, uvIndex: 5, symbolName: "cloud.rain.fill")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [WeatherDataEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = WeatherDataEntry(date: entryDate, condition: "Rainy", temperature: 19.9, humidity: 20, precipitationIntensity: 1, windSpeed: 21, uvIndex: 5, symbolName: "cloud.rain.fill")
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
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
}

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

struct DressRecommendationEntryView : View {

    var entry: Provider.Entry

    var body: some View {
        VStack {
            

            Text("Emoji:")
            Text(entry.condition)
        }
    }
}

struct DressRecommendationWidget: Widget {
    let kind: String = "com.WeatherWisdom.Widget-dress-recommend"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                DressRecommendationEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                DressRecommendationEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Dress recommendation")
        .description("This recommends dressing according to your current weather.")
    }
}

// MARK: - 현재 날씨 위젯

struct CurrentWeatherEntryView : View {

    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Time:")
            Text(entry.date, style: .time)

            Text("Emoji:")
            Text(entry.condition)
        }
    }
}

struct CurrentWeatherWidget: Widget {
    let kind: String = "com.WeatherWisdom.Widget-current-weather"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                CurrentWeatherEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                CurrentWeatherEntryView(entry: entry)
                    .padding()
                    .background(Color(UIColor.systemBackground))
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
    WeatherDataEntry(date: Date(), condition: "Rainy", temperature: 19.9, humidity: 20, precipitationIntensity: 1, windSpeed: 21, uvIndex: 5, symbolName: "cloud.rain.fill")
    WeatherDataEntry(date: Date(), condition: "Rainy", temperature: 19.9, humidity: 20, precipitationIntensity: 1, windSpeed: 21, uvIndex: 5, symbolName: "cloud.rain.fill")
}

#Preview(as: .systemSmall) {
    CurrentWeatherWidget()
} timeline: {
    WeatherDataEntry(date: Date(), condition: "frf", temperature: 19.9, humidity: 20, precipitationIntensity: 1, windSpeed: 21, uvIndex: 5, symbolName: "cloud.rain.fill")
}
