//
// BehaviourAnalysisLineChartView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 02/04/26.
//

import SwiftUI

@available(iOS 16.0, *)
struct BehaviourAnalysisLineChartView: View {
    
    typealias ChartData = (
        config: LineChartConfiguration.MetricLineChartConfig,
        points: [LineChartDataModel.LineChartPoint],
        feedback: String
    )
    
    let improvementsRequired: [String: [String]]
    
    let getCalculatedLineGraphData: [ChartData]
    
    var body: some View {
        LazyVStack {
            ForEach(Array(getCalculatedLineGraphData.enumerated()), id: \.offset) { _, item in
                behaviourAnalysisChartCardView(item)
            }
        }
    }
    
    
    private func behaviourAnalysisChartCardView(_ item: ChartData) -> some View {
        VStack(spacing: 16) {
            MetricLineChartView(
                config: item.config,
                dataPoints: item.points
            )
            
            BehaviourAnalysisInfoView(
                feedback: item.points.first?.feedback ?? "",
                improvements: improvementsRequired[item.config.title] ?? []
            )
        }
        .cardStylePkg()
    }
    
    
}

@available(iOS 16.0, *)
#Preview {
    ScrollView {
        BehaviourAnalysisLineChartView(
            improvementsRequired: ["Clarity": [
                "0:05 - Clearly articulate the product names and their components to avoid confusion. For example, instead of 'gravitas mankind present tellmekind ct 40 and 80', say 'I would like to introduce our products, Tellmekind CT 40 and 80.'",
                "0:10 - Break down complex terms into simpler language. Instead of 'stage 2 hypertension with high cb risk', say 'for patients with stage 2 hypertension and high cardiovascular risk.'"
            ]], getCalculatedLineGraphData: DetailReportDataModel.ScenarioAttemptResponse.preview.getCalculatedbehaviourChartModels
        )
    }
    .versionedContentMarginsPkg()
}
