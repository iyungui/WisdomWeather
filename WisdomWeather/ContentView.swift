//
//  ContentView.swift
//  WisdomWeather
//
//  Created by Yungui Lee on 6/25/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = WeatherViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                if let temperature = viewModel.weatherData?.temperature {
                    getBackgroundColor(for: temperature)
                        .ignoresSafeArea()
                } else {
                    Color.white
                        .ignoresSafeArea()
                }
                
                VStack {
                    if let cityName = viewModel.cityName {
                        Text(cityName)
                            .font(.title3)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    
                    
                    
                    HStack {
                        if let temperature = viewModel.weatherData?.temperature, let condition = viewModel.weatherData?.condition {
                            Text(String(format: "%.1f", temperature))
                                .fontWeight(.bold)
                            Spacer()
                            Text(condition)
                                .fontWeight(.black)
                        }
                    }
                    .font(.system(size: 64))
                    .padding(20)
                    
                    

                    if !viewModel.weatherGuides.isEmpty {
                        Divider()
                            .frame(height: 1)
                            .background(getTextColor(for: viewModel.weatherData?.temperature ?? 0))
                            .padding(.leading, 20)
                    }
                    
                    ForEach(viewModel.weatherGuides) { guide in
                        HStack {
                            Text("\(guide.message)")
                                .font(.system(size: 24, weight: .medium))
                            
                            Spacer()
                            Image(systemName: guide.guideSymbolName)
                                .font(.system(size: 60))
                        }
                    }
                    .padding(20)

                    
                    Divider()
                        .frame(height: 1)
                        .background(getTextColor(for: viewModel.weatherData?.temperature ?? 0))
                        .padding(.leading, 20)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("옷차림 추천")
                            .font(.system(size: 40, weight: .black))
                        
                        Text("현재 온도와 습도에 따라 옷차림을 자동으로 추천합니다.")
                            .font(.callout)
                            .fontWeight(.light)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 20)
                    

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(viewModel.clothingItems) { item in
                                VStack(spacing: 15) {
                                    if let image = item.clothingImage {
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 80, height: 80)
                                    }
                                    
                                    Text(item.clothingName)
                                        .font(.system(size: 24, weight: .medium))
                                }
                                .padding(20)
                            }
                        }
                    }
                    Spacer()
                }
                .foregroundStyle(getTextColor(for: viewModel.weatherData?.temperature ?? 21))    // TODO:
            }
            .onAppear {
                viewModel.requestLocation()
            }
        }
    }
    
    private func getBackgroundColor(for temperature: Double) -> Color {
        switch temperature {
        case 28...:
            return Color("ExtremeHot")
        case 23...27:
            return Color("VeryHot")
        case 20...22:
            return Color("Warm")
        case 17...19:
            return Color("Mild")
        case 12...16:
            return Color("Cool")
        case 9...11:
            return Color("Cold")
        case 5...8:
            return Color("VeryCold")
        case ..<5:
            return Color("ExtremeCold")
        default:
            return Color.white
        }
    }

    private func getTextColor(for temperature: Double) -> Color {
        switch temperature {
        case 28...:
            return Color.white
        case 23...27:
            return Color.white
        case 20...22:
            return Color.black
        case 17...19:
            return Color.black
        case 12...16:
            return Color.black
        case 9...11:
            return Color.white
        case 5...8:
            return Color.white
        case ..<5:
            return Color.white
        default:
            return Color.black
        }
    }
}

#Preview {
    NavigationStack {
        ContentView()
    }
}
