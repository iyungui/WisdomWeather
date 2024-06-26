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
