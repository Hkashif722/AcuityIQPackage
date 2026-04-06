//
//  SpiderChartDataModel.swift
//  Ujjivan
//
//  Created by Kashif Hussain on 22/01/26.
//  Copyright © 2026 EnthrallTech. All rights reserved.
//

import UIKit

//SPIDER CHART DATA MODL <<<>>>>>>>>

struct SpiderChartDataModel {
    
    // MARK: - Chart Data Set
    struct ChartDataSet: Identifiable, Equatable {
        let id = UUID()
        let label: String
        let values: [Double]
        let color: UIColor
        var isVisible: Bool = true
        
        init(label: String, values: [Double], color: UIColor, isVisible: Bool = true) {
            self.label = label
            self.values = values
            self.color = color
            self.isVisible = isVisible
        }
    }

    // MARK: - Chart Config

    struct ChartConfig {
        let labels: [String]
        let minValue: Double
        let maxValue: Double
        let showValues: Bool
        let showXAxisLabels: Bool
        let showYAxisLabels: Bool
        let yAxisLabelCount: Int
        let showLegend: Bool
        let enableLegendTap: Bool
        let enableRotation: Bool
        
        init(
            labels: [String],
            minValue: Double = 0,
            maxValue: Double = 6,
            showValues: Bool = false,
            showXAxisLabels: Bool = true,
            showYAxisLabels: Bool = true,
            yAxisLabelCount: Int = 5,
            showLegend: Bool = true,
            enableLegendTap: Bool = true,
            enableRotation: Bool = false
        ) {
            self.labels = labels
            self.minValue = minValue
            self.maxValue = maxValue
            self.showValues = showValues
            self.showXAxisLabels = showXAxisLabels
            self.showYAxisLabels = showYAxisLabels
            self.yAxisLabelCount = yAxisLabelCount
            self.showLegend = showLegend
            self.enableLegendTap = enableLegendTap
            self.enableRotation = enableRotation
        }
    }
}


extension SpiderChartDataModel {
    struct ViewModel {
        let labels: [String]
        let dataSets: [ChartDataSet]
        let maxValue: Double
    }
    
    // MARK: - Spider Chart Palette

    enum SpiderChartPalette {
        static let expected = UIColor(red: 239/255, green:  83/255, blue:  80/255, alpha: 1)
        static let current  = UIColor(red:  66/255, green: 165/255, blue: 245/255, alpha: 1)
    }

}
