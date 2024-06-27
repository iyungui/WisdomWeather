//
//  WidgetBundle.swift
//  Widget
//
//  Created by Yungui Lee on 6/27/24.
//

import WidgetKit
import SwiftUI

@main
struct WidgetBundle: SwiftUI.WidgetBundle {
    var body: some SwiftUI.Widget {
        DressRecommendationWidget()
        CurrentWeatherWidget()
    }
}
