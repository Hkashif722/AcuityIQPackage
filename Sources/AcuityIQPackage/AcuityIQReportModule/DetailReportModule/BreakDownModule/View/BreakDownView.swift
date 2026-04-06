//
//  SwiftUIView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 01/04/26.
//

import SwiftUI
import SwiftfulRouting

struct BreakDownView: View {

    @StateObject private var vm: BreakDownViewModel

    init(router: AnyRouter, scenarioResponse: DetailReportDataModel.ScenarioAttemptResponse) {
        _vm = StateObject(wrappedValue: BreakDownViewModel(router: router, scenarioAttemptResponseModel: scenarioResponse))
    }
    
    var body: some View {
        VStack {
            ScenarioSectionInfoBannerView(
                text: vm.getHeaderTitle
            )
            .padding(.horizontal, 10)
            
            ScrollView {
                VStack(spacing: 16) {
                    ScenarioEvaluationChartGroupView(
                        chartModel: vm.chartModel,
                        legendsDataModel: vm.legendsSpiderChartValue
                    )
                    
                    ScenarioEvaluationResultComponents(
                        sections: vm.getEvaluationSectionModel
                    )
                }
            }
            .versionedContentMarginsPkg()
        }
    }
}

#Preview {
    RouterView { router in
        BreakDownView(router: router, scenarioResponse: .preview)
    }
}
