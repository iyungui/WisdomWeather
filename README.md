
# Weather Wisdom

## Overview

[![Build Status](https://img.shields.io/badge/build-passing-brightgreen.svg)](https://github.com/iyungui/WisdomWeather)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

An app that recommends clothing based on the current weather.

- 현재 날씨에 따라 배경컬러가 바뀌는 직관적인 디자인 - (정확한 온도를 보지 않아도, 색깔만으로 파악가능 및 추운지 더운지 심리 전달 효과?)
- 기온별 옷차림, 날씨별 옷차림을 직관적인 아이콘과 이름으로 전달
- 자외선, 비.눈 예보를 통한 정보 전달

## Screenshots

<div style="display: grid; grid-template-columns: 1fr 1fr; gap: 10px;">
  <div>
    <img src="/Screenshot/Simulator Screenshot - iPhone 15 Pro - 2024-06-26 at 22.41.35.png" alt="Screenshot 1" style="width: 100%;">
  </div>
  <div>
    <img src="/Screenshot/Simulator Screenshot - iPhone 15 Pro - 2024-06-26 at 22.41.54.png" alt="Screenshot 2" style="width: 100%;">
  </div>
  <div>
    <img src="/Screenshot/Simulator Screenshot - iPhone 15 Pro - 2024-06-26 at 22.40.34.png" alt="Screenshot 3" style="width: 100%;">
  </div>
  <div>
    <img src="/Screenshot/Simulator Screenshot - iPhone 15 Pro - 2024-06-26 at 22.43.08.png" alt="Screenshot 4" style="width: 100%;">
  </div>
</div>




## Design
https://www.figma.com/design/qVAX105pzowRtA0sRngAiM/Untitled?node-id=0-1&t=qFp0CK43vTooFQcG-1

## Reference
- Clothes icon
    - https://www.figma.com/community/file/1269887446772963016

## Future Development

This section outlines the planned features and enhancements for Weather Wisdom

- VoiceOver - 약시나 시각장애인을 위해
- 시간별 기온에 따른 다양하고 유동적인 옷차림 추천 시스템
- Development of widgets
- Expansion to watchOS and macOS platforms
- Localization (support for English and Korean) including permission requests

    - https://velog.io/@stealmh/SwiftUI-Localization현지화
    - https://coledennis.medium.com/tutorial-connecting-core-location-to-a-swiftui-app-dc62563bd1de
    - https://medium.com/@hyleedevelop/ios-localization-tutorial-in-swiftui-using-string-catalog-9307953d8082


- Improve Clothing Image View <auto scroll view>
    - https://apoorv487.medium.com/swiftui-scrollview-auto-scrolling-manual-scrolling-to-a-particular-position-7c1c6eadbaf7


# How To Test Localization

![alt text](</Screenshot/Screenshot 2024-06-26 at 3.23.17 PM.png>)

You can change the simulator’s language settings like above.
(Edit Scheme → Run → Options → App Language)