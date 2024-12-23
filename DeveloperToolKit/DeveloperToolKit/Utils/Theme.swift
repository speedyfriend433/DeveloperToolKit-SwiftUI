//
//  Theme.swift
//  DeveloperToolKit
//
//  Created by speedy on 2024/12/22.
//

import SwiftUI

struct Theme {

    private static let lightPrimary = Color(hex: "FF7F50")
    private static let lightSecondary = Color(hex: "FFA07A")
    private static let lightBackground = Color(hex: "FFF8F0")
    private static let lightText = Color(hex: "2D3436")
    private static let lightBorder = Color(hex: "FFE4E1")
    private static let darkPrimary = Color(hex: "FF9F7D")
    private static let darkSecondary = Color(hex: "FFB59E")
    private static let darkBackground = Color(hex: "1C1C1E")
    private static let darkText = Color(hex: "FFFFFF")
    private static let darkBorder = Color(hex: "3A3A3C")
    
    @Environment(\.colorScheme) static var colorScheme
    
    static var primary: Color {
        colorScheme == .dark ? darkPrimary : lightPrimary
    }
    
    static var secondary: Color {
        colorScheme == .dark ? darkSecondary : lightSecondary
    }
    
    static var background: Color {
        colorScheme == .dark ? darkBackground : lightBackground
    }
    
    static var text: Color {
        colorScheme == .dark ? darkText : lightText
    }
    
    static var border: Color {
        colorScheme == .dark ? darkBorder : lightBorder
    }
    
    static var error: Color {
        .red
    }
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
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
