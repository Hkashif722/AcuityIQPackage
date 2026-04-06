//
//  SwiftUIView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 03/04/26.
//

import SwiftUI

struct SectionContentView: View {
    
    let evaluationData: AllAttemptDataModel.Evaluation
    
    var body: some View {
        VStack(spacing: 12) {
            if #available(iOS 16.0, *) {
                graphView
            }
            imporvementView
        }
    }
    
    
    @available(iOS 16.0, *)
    private var graphView: some View {
        MetricLineChartView(
            config: evaluationData.graph.graphData.config,
            dataPoints: evaluationData.graph.graphData.model
        )

    }
   
    
    private var imporvementView: some View {
        VStack {
            ForEach(evaluationData.attempts) { attempt in
                attempDescriptionView(attempt: attempt.attempt, feedback: attempt.feedback)
                ImprovementRequiredView(improvements: attempt.improvementsRequired ?? [])
            }
        }
    }
    
    private func attempDescriptionView(attempt: Int, feedback: String) -> some View {
        VStack(spacing: 2) {
            Text("Attempt \(attempt)")
                .foregroundStyle(.primary)
                .font(.caption.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(feedback)
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
        }
      
    }

}

#Preview {
    ScrollView {
        SectionContentView(evaluationData: AllAttemptDataModel.AllAttemptResponse.preview.behavioural[1])
            .padding(.horizontal, 10)
    }
    .versionedContentMarginsPkg()
}
