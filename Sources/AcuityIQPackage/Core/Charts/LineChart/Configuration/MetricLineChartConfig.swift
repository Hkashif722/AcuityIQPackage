//
//  MetricLineChartConfig.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 02/04/26.
//


import SwiftUI

public struct LineChartConfiguration {
    // MARK: - Chart Configuration
    public struct MetricLineChartConfig {
        public var title: String
        public var accentColor: Color
        public var yDomain: ClosedRange<Double>
        public var unit: String
        public var yStep: Double
        
        public init(
            title: String,
            accentColor: Color = .blue,
            yDomain: ClosedRange<Double> = 0...10,
            unit: String = "",
            yStep: Double = 1
        ) {
            self.title = title
            self.accentColor = accentColor
            self.yDomain = yDomain
            self.unit = unit
            self.yStep = yStep
        }
    }
}
