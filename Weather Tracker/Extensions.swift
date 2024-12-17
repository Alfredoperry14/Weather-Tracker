//
//  Extensions.swift
//  Weather Tracker
//
//  Created by Alfredo Perry on 12/15/24.
//

import Foundation
import SwiftUI

extension Color {
    static let customGray = Color(hex: "#9A9A9A")
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

extension Font {
    enum PoppinsWeight {
        case regular
        case medium
        case semibold
    }
    
    static func poppins(_ weight: PoppinsWeight = .regular, size: CGFloat = 16) -> Font {
        switch weight {
        case .regular:
            return .custom("Poppins-Regular", size: size)
        case .medium:
            return .custom("Poppins-Medium", size: size)
        case .semibold:
            return .custom("Poppins-SemiBold", size: size)
        }
    }
}

