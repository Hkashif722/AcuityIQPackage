//
//  SwiftUIView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 01/04/26.
//

import SwiftUI
import SwiftUIUtilities

struct ScenarioEvaluationChartGroupView: View {

    typealias ScenarioAttemptResponse = DetailReportDataModel.ScenarioAttemptResponse

    let chartModel: SpiderChartDataModel.ViewModel
    let legendsDataModel: [(String, Double)]

    var body: some View {
        GroupBox {
            VStack(spacing: 0) {
                ScenarioSectionSpiderChartView(chartModel: chartModel)
                legendView
            }
        } label: {
            Label("Section Scores", systemImage: "chart.bar.xaxis")
                .font(.headline)
                .foregroundStyle(.blue)
        }
    }
}

// MARK: - Legend

extension ScenarioEvaluationChartGroupView {

    private var legendView: some View {
        HStack(spacing: 8) {
            ForEach(legendsDataModel, id: \.0) { label, score in
                legendItem(label: label, score: score)
            }
        }
    }

    private func legendItem(label: String, score: Double) -> some View {
        VStack(spacing: 8) {
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(String(format: "%.1f/%.0f", score, chartModel.maxValue))
                .font(.caption.bold())
                .foregroundStyle(ScenarioAttemptResponse.scoreColor(for: score, maxValue: chartModel.maxValue))
        }
        .frame(width: 60)
        .cardStylePkg(padding: 16)
    }
}

// MARK: - Preview

#Preview {
    let viewModel = DetailReportDataModel.ScenarioAttemptResponse.preview.sectionSpiderChartViewModel()
    ScenarioEvaluationChartGroupView(
        chartModel: viewModel,
        legendsDataModel: Array(zip(viewModel.labels, viewModel.dataSets.first?.values ?? []))
    )
    .padding()
}
