//
//  ContentView.swift
//  WisdomWeather
//
//  Created by Yungui Lee on 6/25/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color("ExtremeHot")
                    .ignoresSafeArea()
                
                VStack {
                    Text("서울특별시")
                        .font(.title3)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Spacer()
                    
                    HStack {
                        Text("40°C")
                            .fontWeight(.bold)
                        Spacer()
                        Text("비")
                            .fontWeight(.black)
                    }
                    .font(.system(size: 64))
                    .padding(20)

                    
                    Divider()
                        .frame(height: 1)
                        .background(.white)
                        .padding(.leading, 20)
                    
                    ForEach(0..<2) { index in
                        HStack {
                            Text("지금 비가오고 있어요! 우산을 챙기세요.")
                                .font(.system(size: 24, weight: .medium))
                            
                            Spacer()
                            Image(systemName: "cloud.rain.fill")
                                .font(.system(size: 60))
                        }
                    }
                    .padding(20)

                    
                    Divider()
                        .frame(height: 1)
                        .background(.white)
                        .padding(.leading, 20)
                    
                    
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
                .foregroundStyle(.white)
            }
//            .navigationTitle("서울특별시")
//            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    NavigationStack {
        ContentView()
    }
}
