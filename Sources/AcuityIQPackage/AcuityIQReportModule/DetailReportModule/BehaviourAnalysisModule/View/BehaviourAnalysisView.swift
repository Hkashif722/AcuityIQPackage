//
//  BehaviourAnalysisView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 02/04/26.
//

import SwiftUI
import SwiftfulRouting

struct BehaviourAnalysisView: View {

    @StateObject private var vm: BehaviourAnalysisViewModel

    init(router: AnyRouter, scenarioResponse: DetailReportDataModel.ScenarioAttemptResponse) {
        _vm = StateObject(
            wrappedValue: BehaviourAnalysisViewModel(router: router, scenarioAttemptResponseModel: scenarioResponse)
        )
    }

    var body: some View {
        VStack {
            ScenarioSectionInfoBannerView(text: vm.behaviourAttemptHeaderTitle)
                .padding(.horizontal, 10)
            ScrollView {
                behaviourAnalysisChartView
                whatWentWellInfoView
            }
            .versionedContentMarginsPkg()
        }
    }
    
    @ViewBuilder
    private var behaviourAnalysisChartView: some View {
        if #available(iOS 16.0, *) {
            BehaviourAnalysisLineChartView(
                improvementsRequired: vm.improvementRequiredData,
                getCalculatedLineGraphData: vm.getCalculatedLineGraphData
            )
        }
    }
    
    @ViewBuilder
    private var whatWentWellInfoView: some View {
        if let infoText = vm.whatWentWellInfoText {
            BehaviourWhatWentWellInfoView(whatWentWellInfo: infoText)
        }
    }
}

#Preview {
    RouterView { router in
        BehaviourAnalysisView(router: router, scenarioResponse: .preview)
    }
}
