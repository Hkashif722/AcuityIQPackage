//
//  File.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 02/04/26.
//

import SwiftUI

extension Color {
    init(rgbString: String) {
        // Extract numbers using regex
        let numbers = rgbString
            .replacingOccurrences(of: "rgb(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .split(separator: ",")
            .compactMap { Double($0.trimmingCharacters(in: .whitespaces)) }

        if numbers.count == 3 {
            self.init(
                .sRGB,
                red: numbers[0] / 255,
                green: numbers[1] / 255,
                blue: numbers[2] / 255,
                opacity: 1
            )
        } else {
            self = .gray // fallback
        }
    }
}


// MARK: - Color Extension for Luminance

extension Color {
    
    /// Returns white or black depending on background luminance
    static func dynamicTextColor(for gradientStops: [Gradient.Stop]) -> Color {
        let avgLuminance = averageLuminance(of: gradientStops)
        return avgLuminance > 0.5 ? .black : .white
    }
    
    /// Weighted average luminance across gradient stops
    private static func averageLuminance(of stops: [Gradient.Stop]) -> Double {
        guard !stops.isEmpty else { return 0 }
        
        let totalLuminance = stops.reduce(0.0) { result, stop in
            result + stop.color.relativeLuminance
        }
        return totalLuminance / Double(stops.count)
    }
    
    /// Relative luminance (W3C formula)
    var relativeLuminance: Double {
        let components = UIColor(self).rgbComponents
        let r = adjustChannel(components.red)
        let g = adjustChannel(components.green)
        let b = adjustChannel(components.blue)
        return 0.2126 * r + 0.7152 * g + 0.0722 * b
    }
    
    private func adjustChannel(_ value: CGFloat) -> Double {
        let v = Double(value)
        return v <= 0.03928 ? v / 12.92 : pow((v + 0.055) / 1.055, 2.4)
    }
}

// MARK: - UIColor RGB Helper

extension UIColor {
    var rgbComponents: (red: CGFloat, green: CGFloat, blue: CGFloat) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: nil)
        return (r, g, b)
    }
}
