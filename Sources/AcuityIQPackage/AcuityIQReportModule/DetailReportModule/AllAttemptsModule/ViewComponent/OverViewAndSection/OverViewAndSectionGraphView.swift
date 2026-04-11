//
//  OverViewAndSectionGraphView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 03/04/26.
//

import SwiftUI

@available(iOS 16.0, *)
struct OverViewAndSectionGraphView: View {
    
    let getOverAllChatDataModel: (
        config: LineChartConfiguration.MetricLineChartConfig,
        model: [LineChartDataModel.LineChartPoint]
    )
    
    let getSectionWiseProgressDataModel: (
        config: LineChartConfiguration.MetricLineChartConfig,
        model: [LineChartDataModel.SectionPoint]
    )
    
    let getCriticalErrorgGrapghDataModel: (
        config: LineChartConfiguration.MetricLineChartConfig,
        model: [LineChartDataModel.LineChartPoint]
    )
    
    
    var body: some View {
        LazyVStack(spacing: 16) {
            overAllGraphView
            sectionWiseGraphView
            criticalErrorGraphView
        }
    }
    
    
    var overAllGraphView: some View {
        MetricLineChartView(
            config: getOverAllChatDataModel.config,
            dataPoints: getOverAllChatDataModel.model
        )
        .cardStylePkg()
    }
    
    var sectionWiseGraphView: some View {
        MetricLineChartView(
            config: getSectionWiseProgressDataModel.config,
            dataPoints: getSectionWiseProgressDataModel.model
        )
        .cardStylePkg()
    }
    
    var criticalErrorGraphView: some View {
        MetricLineChartView(
            config: getCriticalErrorgGrapghDataModel.config,
            dataPoints: getCriticalErrorgGrapghDataModel.model
        )
        .cardStylePkg()
    }
}

#if Debug
@available(iOS 16.0, *)
#Preview {
    let model =  AllAttemptDataModel.AllAttemptResponse.preview
    ScrollView {
        OverViewAndSectionGraphView(
            getOverAllChatDataModel: model.overallRatingGrapghDataModel,
            getSectionWiseProgressDataModel: model.sectionWiseProgressGraphDataModel,
            getCriticalErrorgGrapghDataModel: model.criticalErrorgGrapghDataModel
        )
    }
    .versionedContentMarginsPkg()
}
#endif
