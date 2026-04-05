//
//  File.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 01/04/26.
//

import SwiftUI


// MARK: - Spider Chart Extensions

extension DetailReportDataModel.ScenarioAttemptResponse {
    
    typealias SpiderChartPalette = SpiderChartDataModel.SpiderChartPalette

    // MARK: Section Scores Chart (0–10 scale)
    // axis labels = ["Beginning", "Middle", "End"] from sections[].name

    var sectionSpiderChartLabels: [String] {
        sections?.map(\.name) ?? []
    }

    func sectionSpiderChartCurrentValues(maxScore: Double = 10.0) -> [Double] {
        sections?.map { min($0.score ?? 0, maxScore) } ?? []
    }

    func sectionSpiderChartDataSets(maxScore: Double = 10.0) -> [SpiderChartDataModel.ChartDataSet] {
        [
            .init(
                label: "Sections",
                values: sectionSpiderChartCurrentValues(maxScore: maxScore),
                color: SpiderChartDataModel.SpiderChartPalette.current
            )
        ]
    }

    func sectionSpiderChartViewModel(maxScore: Double = 10.0) -> SpiderChartDataModel.ViewModel {
        .init(
            labels: sectionSpiderChartLabels,   // ["Beginning", "Middle", "End"]
            dataSets: sectionSpiderChartDataSets(maxScore: maxScore),
            maxValue: maxScore
        )
    }
    
    var breakDownModuleTitle: String {
        "Performance broken down by Beginning, Middle, and End sections of your audio presentation."
    }
    
}


//MARK: Utility
extension DetailReportDataModel.ScenarioAttemptResponse {
    
    static func scoreColor(for score: Double, maxValue: Double) -> Color {
        let ratio = maxValue > 0 ? score / maxValue : 0
        switch ratio {
        case 0..<0.3:  return .red
        case 0.3..<0.5: return .orange
        case 0.5..<0.7: return .blue
        case 0.7..<0.9: return .cyan
        default:        return .green
        }
    }
}
