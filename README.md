# Weather Wisdom

## Overview

[![Build Status](https://img.shields.io/badge/build-passing-brightgreen.svg)](https://github.com/iyungui/WisdomWeather)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

An app that recommends clothing based on the current weather.

## Screenshots

| ![Screenshot 1](</Screenshot/Simulator Screenshot - iPhone 15 Pro - 2024-06-26 at 22.41.54.png>) | ![Screenshot 2](</Screenshot/Simulator Screenshot - iPhone 15 Pro - 2024-06-26 at 22.41.35.png>) |
|---|---|
| ![Screenshot 3](</Screenshot/Simulator Screenshot - iPhone 15 Pro - 2024-06-26 at 22.40.34.png>) | ![Screenshot 4](</Screenshot/Simulator Screenshot - iPhone 15 Pro - 2024-06-26 at 22.43.08.png>) |

### Demo Video
[![Screen Recording](</Screenshot/Screen Recording 2024-06-26 at 10.45.42 PM.mov>)](path/to/video)

## Features

- Intuitive design with background colors that change based on current weather (enables users to easily grasp the temperature and sense whether it's hot or cold without needing precise temperature readings)
- Provides clothing recommendations using intuitive icons and names based on temperature and weather conditions
- Delivers information on UV levels, rain, and snow forecasts


## Requirements

- iOS version (e.g., iOS 16.0+)
- Xcode version (e.g., Xcode 15.0+)
- Swift version (e.g., Swift 5.3)

## Design (Figma)

[Weather Wisdom Design on Figma](https://www.figma.com/design/qVAX105pzowRtA0sRngAiM/Untitled?node-id=0-1&t=qFp0CK43vTooFQcG-1)

## Reference

- Clothes icon
    - [Figma Community File](https://www.figma.com/community/file/1269887446772963016)

## Future Development

This section outlines the planned features and enhancements for Weather Wisdom

- VoiceOver support for visually impaired users
- Diverse and dynamic clothing recommendation system based on hourly temperature changes
- Development of widgets
- Expansion to watchOS and macOS platforms
- Localization (support for English and Korean) including permission requests

    - [SwiftUI Localization Guide](https://velog.io/@stealmh/SwiftUI-Localization현지화)
    - [Connecting Core Location to a SwiftUI App](https://coledennis.medium.com/tutorial-connecting-core-location-to-a-swiftui-app-dc62563bd1de)
    - [iOS Localization Tutorial in SwiftUI Using String Catalog](https://medium.com/@hyleedevelop/ios-localization-tutorial-in-swiftui-using-string-catalog-9307953d8082)

- Improve Clothing Image View <auto scroll view>
    - [Auto Scrolling in SwiftUI ScrollView](https://apoorv487.medium.com/swiftui-scrollview-auto-scrolling-manual-scrolling-to-a-particular-position-7c1c6eadbaf7)

## Usage

### Running the App

1. Select the desired scheme.
2. Choose a target device (simulator or physical).
3. Press `Cmd + R` or click the Run button.

### How To Test Localization

![Localization Test](</Screenshot/Screenshot 2024-06-26 at 3.23.17 PM.png>)

You can change the simulator’s language settings as shown above.
(Edit Scheme → Run → Options → App Language)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

- Twitter: [@iyungui](https://x.com/iyungui)
- Email: rsdbddml@gmail.com
- Blog: [iyungui.com](https://heroic-horse-c3d1d3.netlify.app)
