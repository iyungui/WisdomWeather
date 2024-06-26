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
                    
                    Spacer()
                    
                    
                    HStack {
                        if let temperature = viewModel.weatherData?.temperature, let condition = viewModel.weatherData?.condition {
                            Text("\(temperature)")
                                .fontWeight(.bold)
                            Spacer()
                            Text(condition)
                                .fontWeight(.black)
                        }
                    }
                    .font(.system(size: 64))
                    .padding(20)
                    

                    
                    Divider()
                        .frame(height: 1)
                        .background(.white)
                        .padding(.leading, 20)
                    
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
                        .background(.white)
                        .padding(.leading, 20)
                    
                    // TODO: update Layout 
                    VStack(alignment: .leading, spacing: 20) {
                        Text("옷차림 추천")
                            .font(.system(size: 40, weight: .black))
                        
                        Text("민소매, 반팔, 반바지, 치마")
                            .font(.system(size: 24, weight: .medium))
                            .multilineTextAlignment(.leading)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(20)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(0..<5) { index in
                                Image("shorts")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                            }
                        }
                        .padding(20)
                    }
                    Spacer()
                }
                .foregroundStyle(getTextColor(for: viewModel.weatherData?.temperature ?? 0))    // TODO:
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
