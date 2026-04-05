//
//  DetailReportDataModel+BehaviourAnalysis.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 02/04/26.
//

import SwiftUI



// MARK: - ScenarioAttemptResponse — Behaviour Analysis

extension DetailReportDataModel.ScenarioAttemptResponse {
    
    var behaviourAnalysisTitle: String {
        "Step function graphs showing how each behavioral metric progressed throughout your audio presentation. Each data point represents the score at that specific time interval."
    }
   
    var getCalculatedbehaviourChartModels: [
        (config: LineChartConfiguration.MetricLineChartConfig,
         points: [LineChartDataModel.LineChartPoint],
         feedback: String
        )
    ] {
        
        guard let behaviourGraphs else { return [] }
        
        return behaviourGraphs.map { graph in
            
            let config = LineChartConfiguration.MetricLineChartConfig(
                title: graph.name,
                accentColor: Color(rgbString: graph.color ?? "rgb(236, 72, 153)"),
                yDomain: 0...10
            )
            
            let points: [LineChartDataModel.LineChartPoint] =
            zip(graph.data ?? [], graph.labels ?? []).enumerated().map { index, element in
                let (score, label) = element
                
                return LineChartDataModel.LineChartPoint(
                    xValue: label.toSeconds(),
                    yValue: score,
                    feedback:graph.feedback
                )
            }
            
            return (config, points, graph.feedback ?? "")
        }
    }

}
