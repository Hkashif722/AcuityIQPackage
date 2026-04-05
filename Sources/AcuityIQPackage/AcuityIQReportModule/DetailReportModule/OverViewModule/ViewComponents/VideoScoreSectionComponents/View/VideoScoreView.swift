//
//  VideoScoreView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 31/03/26.
//

import SwiftUI

struct VideoScoreView: View {
    
    typealias OverallScoreModel = DetailReportDataModel.ScenarioAttemptResponse.OverallScoreModel
    
    let overAllScoreModel: OverallScoreModel
    
    var body: some View {
        HStack(spacing: 8) {
            StatVideoView()
            scoreView
        }
        .frame(height: 220)
    }
    
    @ViewBuilder
    private var scoreView: some View {
        if #available(iOS 16.0, *) {
            OverallScoreView(overAllScoreModel: overAllScoreModel)
        }
    }
}

#Preview {
    VideoScoreView(
        overAllScoreModel: DetailReportDataModel.ScenarioAttemptResponse.preview.overallScoreModel
    )
    .padding(.horizontal, 10)
        
}
