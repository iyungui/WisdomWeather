//
//  getTextAndBackgroundColor.swift
//  WisdomWeather
//
//  Created by Yungui Lee on 6/26/24.
//

import Foundation
import SwiftUI

func getBackgroundColor(for temperature: Double) -> Color {
    switch temperature {
    case 28...:
        return Color.red
    case 23...27:
        return Color.orange
    case 20...22:
        return Color.yellow
    case 17...19:
        return Color.green
    case 12...16:
        return Color.blue
    case 9...11:
        return Color.indigo
    case 5...8:
        return Color.purple
    case ..<5:
        return Color.black
    default:
        return Color.gray
    }
}

func getTextColor(for temperature: Double) -> Color {
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
        return Color.white
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
