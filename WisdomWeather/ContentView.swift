//
//  ContentView.swift
//  WisdomWeather
//
//  Created by Yungui Lee on 6/25/24.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    // 서비스 객체들
    @StateObject private var locationService = LocationService()
    @StateObject private var weatherService = WeatherDataService()
    
    // 로컬 UI 상태
    @State private var isLoading = true
    @State private var showRetryAlert = false
    @State private var recommendation: WeatherClothingRecommendation?
    
    // 의류 추천 서비스 (상태가 필요 없으므로 일반 프로퍼티)
    private let outfitService = OutfitService()
    
    // 환경 변수
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 배경 색상
                backgroundView
                
                // 메인 콘텐츠
                ScrollView {
                    VStack(spacing: 20) {
                        // 위치 및 날씨 정보
                        headerView
                        
                        if weatherService.error == nil && weatherService.currentWeather != nil {
                            // 날씨 경고 및 가이드
                            weatherGuidesView
                            
                            // 의류 추천 섹션
                            clothingRecommendationView
                        }
                    }
                    .padding(.bottom, 30)
                }
                
                // 로딩 또는 에러 오버레이
                overlayView
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("WisdomWeather")
                        .font(.headline)
                        .foregroundColor(getToolbarTextColor())
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        refreshWeather()
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .foregroundColor(getToolbarTextColor())
                    }
                }
            }
            .alert("위치 권한 필요", isPresented: $showRetryAlert) {
                Button("설정") {
                    openSettings()
                }
                Button("다시 시도") {
                    requestLocation()
                }
                Button("취소", role: .cancel) {}
            } message: {
                Text("날씨 정보를 제공하기 위해 위치 권한이 필요합니다. 설정에서 위치 권한을 허용해주세요.")
            }
            // 위치 변경 감지하여 날씨 업데이트
            .onChange(of: locationService.location) { _, newLocation in
                if let location = newLocation {
                    fetchWeatherForLocation(location)
                }
            }
            // 날씨 데이터 변경 시 의류 추천 업데이트
            .onChange(of: weatherService.currentWeather) { _, newWeatherData in
                if let weatherData = newWeatherData {
                    updateOutfitRecommendation(for: weatherData)
                }
            }
            .onAppear {
                // 초기 위치 요청
                requestLocation()
                
                // 로딩 시간을 위한 딜레이
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    isLoading = false
                }
            }
        }
    }
    
    // MARK: - 배경 뷰
    private var backgroundView: some View {
        Group {
            if let temperature = weatherService.currentWeather?.temperature {
                getBackgroundColor(for: temperature)
                    .ignoresSafeArea()
            } else {
                Color(colorScheme == .dark ? .black : .white)
                    .ignoresSafeArea()
            }
        }
    }
    
    // MARK: - 헤더 뷰 (도시 및 온도 정보)
    private var headerView: some View {
        Group {
            if let weatherData = weatherService.currentWeather {
                VStack(spacing: 10) {
                    // 도시 이름
                    if let cityName = locationService.cityName {
                        Text(cityName)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.top, 20)
                    }
                    
                    // 기본 날씨 정보
                    HStack(alignment: .center) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(String(format: "%.1f°", weatherData.temperature))
                                .font(.system(size: 60))
                                .fontWeight(.bold)
                            
                            // 날씨 아이콘 및 상태
                            HStack {
                                Image(systemName: weatherData.symbolName)
                                    .font(.title)
                                Text(weatherData.condition)
                                    .font(.title3)
                            }
                        }
                        
                        Spacer()
                        
                        // 추가 정보 (습도, 풍속, UV)
                        VStack(alignment: .trailing, spacing: 8) {
                            HStack {
                                Image(systemName: "humidity")
                                Text("\(Int(weatherData.humidity))%")
                            }
                            HStack {
                                Image(systemName: "wind")
                                Text("\(Int(weatherData.windSpeed)) m/s")
                            }
                            HStack {
                                Image(systemName: "sun.max")
                                Text("UV \(weatherData.uvIndex)")
                            }
                        }
                        .font(.subheadline)
                    }
                    .padding(20)
                }
                .foregroundStyle(getTextColor(for: weatherData.temperature))
            }
        }
    }
    
    // MARK: - 날씨 가이드 뷰
    private var weatherGuidesView: some View {
        Group {
            if let weatherData = weatherService.currentWeather,
               let recommendation = recommendation,
               !recommendation.weatherGuides.isEmpty {
                VStack(alignment: .leading, spacing: 15) {
                    Divider()
                        .frame(height: 1)
                        .background(getTextColor(for: weatherData.temperature))
                    
                    Text("오늘의 날씨 안내")
                        .font(.headline)
                        .padding(.horizontal, 20)
                    
                    ForEach(recommendation.weatherGuides.prefix(2)) { guide in
                        HStack {
                            Text(guide.message)
                                .font(.system(size: 18, weight: .medium))
                            
                            Spacer()
                            Image(systemName: guide.guideSymbolName)
                                .font(.system(size: 30))
                        }
                        .padding(.horizontal, 20)
                    }
                }
                .foregroundStyle(getTextColor(for: weatherData.temperature))
            }
        }
    }
    
    // MARK: - 의류 추천 뷰
    private var clothingRecommendationView: some View {
        Group {
            if let weatherData = weatherService.currentWeather,
               let recommendation = recommendation,
               !recommendation.clothingItems.isEmpty {
                VStack(alignment: .leading, spacing: 15) {
                    Divider()
                        .frame(height: 1)
                        .background(getTextColor(for: weatherData.temperature))
                        .padding(.top, 10)
                    
                    // 타이틀
                    VStack(alignment: .leading, spacing: 8) {
                        Text("오늘의 옷차림 추천")
                            .font(.title3)
                            .fontWeight(.bold)
                        
                        Text("현재 온도 \(String(format: "%.1f°C", weatherData.temperature))와 습도 \(Int(weatherData.humidity))%에 맞는 옷차림입니다.")
                            .font(.subheadline)
                            .fontWeight(.light)
                    }
                    .padding(.horizontal, 20)
                    
                    // 의류 아이템 스크롤 뷰
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(recommendation.clothingItems) { item in
                                VStack(spacing: 10) {
                                    if let image = item.clothingImage {
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 70, height: 70)
                                    }
                                    
                                    Text(item.clothingName)
                                        .font(.system(size: 14, weight: .medium))
                                        .multilineTextAlignment(.center)
                                }
                                .frame(width: 100, height: 130)
                                .padding(10)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(colorScheme == .dark ? Color.black.opacity(0.3) : Color.white.opacity(0.3))
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.vertical, 10)
                }
                .foregroundStyle(getTextColor(for: weatherData.temperature))
            }
        }
    }
    
    // MARK: - 오버레이 뷰 (로딩 또는 에러)
    private var overlayView: some View {
        Group {
            if isLoading || weatherService.isLoading {
                // 로딩 화면
                ZStack {
                    Color(colorScheme == .dark ? .black : .white)
                        .opacity(0.7)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 20) {
                        ProgressView()
                            .scaleEffect(1.5)
                        
                        Text("날씨 정보를 불러오는 중...")
                            .font(.headline)
                    }
                }
            } else if let error = weatherService.error ?? locationService.error {
                // 에러 화면
                ZStack {
                    Color(colorScheme == .dark ? .black : .white)
                        .opacity(0.9)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 20) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 40))
                            .foregroundColor(.red)
                        
                        Text("날씨 정보를 불러오지 못했습니다")
                            .font(.headline)
                            .multilineTextAlignment(.center)
                        
                        Text(error.localizedDescription)
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                        
                        Button(action: {
                            showRetryAlert = true
                        }) {
                            Text("위치 권한 요청")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: 200)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.top, 10)
                    }
                    .padding()
                }
            }
        }
    }
    
    // MARK: - 비즈니스 로직
    
    // 위치 요청
    private func requestLocation() {
        locationService.requestLocation()
    }
    
    // 특정 위치에 대한 날씨 요청
    private func fetchWeatherForLocation(_ location: CLLocation) {
        Task {
            await MainActor.run {
                isLoading = true
            }
            
            try? await weatherService.fetchWeather(for: location)
            
            await MainActor.run {
                isLoading = false
            }
        }
    }
    
    // 날씨 정보 기반 의류 추천 업데이트
    private func updateOutfitRecommendation(for weatherData: WeatherData) {
        recommendation = outfitService.recommendOutfit(for: weatherData)
    }
    
    // 날씨 새로고침
    private func refreshWeather() {
        if let location = locationService.location {
            weatherService.refreshWeather(for: location)
        } else {
            locationService.requestLocation()
        }
    }
    
    // MARK: - 헬퍼 메서드
    
    // 툴바 텍스트 색상 얻기
    private func getToolbarTextColor() -> Color {
        if let temperature = weatherService.currentWeather?.temperature {
            return getTextColor(for: temperature)
        }
        return colorScheme == .dark ? .white : .black
    }
    
    // 설정 앱 열기
    private func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    NavigationStack {
        ContentView()
    }
}
