//
//  MetricLineChartConfig.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 02/04/26.
//


import SwiftUI

public struct LineChartConfiguration {
    
    public enum ChartType {
        case metric
        case sectionWise
    }

    public struct MetricLineChartConfig {
        public var title: String
        public var accentColor: Color
        public var yDomain: ClosedRange<Double>
        public var unit: String
        public var yStep: Double
        public var showRuleMark: Bool
        
        public var chartType: ChartType
        
        public var sectionColors: [String: Color]
        
        public var xLabel: String?
        
        public init(
            title: String,
            accentColor: Color = .blue,
            yDomain: ClosedRange<Double> = 0...10,
            unit: String = "",
            yStep: Double = 1,
            showRuleMark: Bool = true,
            chartType: ChartType = .metric,
            sectionColors: [String: Color] = [:],
            xLabel: String? = nil
        ) {
            self.title = title
            self.accentColor = accentColor
            self.yDomain = yDomain
            self.unit = unit
            self.yStep = yStep
            self.showRuleMark = showRuleMark
            self.chartType = chartType
            self.sectionColors = sectionColors
            self.xLabel = xLabel
        }
    }
}
