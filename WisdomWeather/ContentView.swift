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
                
                currentWeatherView
                

            }
            .onAppear {
                viewModel.requestLocation()
            }
        }
    }
    
    @ViewBuilder
    private var currentWeatherView: some View {
        if let weatherData = viewModel.weatherData {
            VStack {
                if let cityName = viewModel.cityName {
                    Text(cityName)
                        .font(.title3)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                
                HStack {
                    Text(String(format: "%.1f", weatherData.temperature))
                        .font(.system(size: 64))
                        .fontWeight(.bold)
                    Spacer()
                    Text(weatherData.condition)
                        .font(.system(size: 30))
                        .italic()
                        .fontWeight(.black)
                }
                .padding(20)
                
                
                // TODO: Localization (English, Korean)
                if !viewModel.weatherGuides.isEmpty {
                    Divider()
                        .frame(height: 1)
                        .background(getTextColor(for: weatherData.temperature))
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
                    .background(getTextColor(for: weatherData.temperature))
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
                
                // TODO: AUTO SCROLL VIEW
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
            .foregroundStyle(getTextColor(for: weatherData.temperature))
        } else if let error = viewModel.error {
            // TODO: 권한 재시도 요청 로직 추가
            Text("날씨 정보를 불러오지 못했습니다. 설정에서 위치 권한을 허용해주세요.")
                .foregroundStyle(.red)
                .onAppear {
                    // error handling
                    print(error.localizedDescription)
                }
        } else {
            // MARK: - LOADING VIEW
            ProgressView("날씨 정보를 불러오는 중...")
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