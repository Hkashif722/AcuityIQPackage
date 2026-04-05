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

        SpiderChartViewRepresentable(
            dataSets: chartModel.dataSets,
            config: SpiderChartDataModel.ChartConfig(
                labels: chartModel.labels,  // ["Beginning", "Middle", "End"]
                showValues: false,
                showYAxisLabels: true,
                yAxisLabelCount: 6,
                showLegend: false
            )
        )
        .frame(height: 380)
        .padding()
    }
}

#Preview("Section Scores Chart") {
    ScenarioSectionSpiderChartView(
        chartModel: DetailReportDataModel.ScenarioAttemptResponse.preview.sectionSpiderChartViewModel()
    )
}
