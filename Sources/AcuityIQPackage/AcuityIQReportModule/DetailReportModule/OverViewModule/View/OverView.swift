//
//  OverView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 31/03/26.
//

import SwiftUI
import SwiftfulRouting

struct OverView: View {

    @StateObject private var vm: OverViewModel

    init(router: AnyRouter, scenarioResponse: DetailReportDataModel.ScenarioAttemptResponse) {
        _vm = StateObject(wrappedValue: OverViewModel(router: router, scenarioAttemptResponseModel: scenarioResponse))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                OverViewStatItemGridView(statModels: vm.scenarioAttemptResponseModel.statCards)

                VideoScoreView(
                    videoPathURL: vm.scenarioAttemptResponseModel.fullVideoPathURL,
                    overAllScoreModel: vm.scenarioAttemptResponseModel.overallScoreModel
                )

                ReportInfoView(
                    summary: vm.scenarioAttemptResponseModel.summary ?? "",
                    strength: vm.scenarioAttemptResponseModel.strengths ?? [],
                    areaOfImprovement: vm.scenarioAttemptResponseModel.improvements ?? [],
                    criticalErrors: vm.scenarioAttemptResponseModel.criticals ?? [],
                    detailedAnalysis: vm.scenarioAttemptResponseModel.contentRelevance ?? "",
                    level: vm.scenarioAttemptResponseModel.scoreLevel
                )
            }
        }
        .versionedContentMarginsPkg()
    }
}

#Preview {
    RouterView { router in
        OverView(router: router, scenarioResponse: .preview)
    }
}
