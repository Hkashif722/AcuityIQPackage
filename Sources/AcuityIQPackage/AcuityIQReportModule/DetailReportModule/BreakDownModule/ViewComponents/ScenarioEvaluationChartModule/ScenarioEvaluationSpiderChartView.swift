//
//  ScenarioEvaluationSpiderChartView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 01/04/26.
//

import SwiftUI

// MARK: - Section Scores Spider Chart (0–10 scale)

struct ScenarioSectionSpiderChartView: View {

    let chartModel: SpiderChartDataModel.ViewModel
   

    var body: some View {
        VStack {
            SpiderChartViewRepresentable(
                dataSets: chartModel.dataSets,
                config: SpiderChartDataModel.ChartConfig(
                    labels: chartModel.labels,  // ["Beginning", "Middle", "End"]
                    minValue: 0.0,
                    maxValue: 10.0,
                    showValues: false,
                    showYAxisLabels: true,
                    yAxisLabelCount: 6,
                    showLegend: false
                )
            )
        }
        .frame(height: 380)
        .padding(.bottom, -40)
       
    }
}

#Preview("Section Scores Chart") {
    ScenarioSectionSpiderChartView(
        chartModel: DetailReportDataModel.ScenarioAttemptResponse.preview.sectionSpiderChartViewModel()
    )
}
