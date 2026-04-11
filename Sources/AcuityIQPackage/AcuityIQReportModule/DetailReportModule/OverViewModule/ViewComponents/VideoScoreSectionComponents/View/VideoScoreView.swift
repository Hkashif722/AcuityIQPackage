//
//  VideoScoreView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 31/03/26.
//

import SwiftUI

struct VideoScoreView: View {
    
    typealias OverallScoreModel = DetailReportDataModel.ScenarioAttemptResponse.OverallScoreModel
    
    let videoPathURL: URL?
    let overAllScoreModel: OverallScoreModel
    
    var body: some View {
        HStack(spacing: 8) {
            if let videoPathURL {
                StatVideoView(videoPathURL: videoPathURL)
            }
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
        videoPathURL: URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/master.m3u8"),
        overAllScoreModel:
            DetailReportDataModel.ScenarioAttemptResponse.preview.overallScoreModel
    )
    .padding(.horizontal, 10)
        
}
