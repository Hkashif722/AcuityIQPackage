//
//  OverallScoreView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 31/03/26.
//

import SwiftUI

import SwiftUI

@available(iOS 16.0, *)
struct OverallScoreView: View {
    
    typealias OverallScoreModel = OverViewDataModel.ScenarioAttemptResponse.OverallScoreModel
    
    let overAllScoreModel: OverallScoreModel
    
    var body: some View {
        ReusableGaugeView(
            value: overAllScoreModel.value,
            range: 0...5,
            title: "Overall Score",
            systemImage: "chart.bar.fill",
            segments: overAllScoreModel.segments
        ) { value in
            String(format: "%.1f", Double(value))
        }
        .frame(width: 200)
        .cardStylePkg(padding: 10)
        .scaleEffect(0.75)
    }
}

@available(iOS 16.0, *)
#Preview {
    OverallScoreView(overAllScoreModel: OverViewDataModel.ScenarioAttemptResponse.preview.overallScoreModel)
}
