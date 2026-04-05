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
    
    typealias OverallScoreModel = DetailReportDataModel.ScenarioAttemptResponse.OverallScoreModel
    
    let overAllScoreModel: OverallScoreModel
    
    var body: some View {
        ReusableGaugeView(
            value: overAllScoreModel.value,
            range: overAllScoreModel.range,
            title: "Overall Score",
            systemImage: "chart.bar.fill",
            segments: overAllScoreModel.segments,
            showLegend: true
        ) { value in
            String(format: "%.1f", Double(value))
        }
        .fixedSize(horizontal: true, vertical: false)
        .cardStylePkg(padding: 10)
//        .scaleEffect(0.75)
    }
}

@available(iOS 16.0, *)
#Preview {
    OverallScoreView(overAllScoreModel: DetailReportDataModel.ScenarioAttemptResponse.preview.overallScoreModel)
}
