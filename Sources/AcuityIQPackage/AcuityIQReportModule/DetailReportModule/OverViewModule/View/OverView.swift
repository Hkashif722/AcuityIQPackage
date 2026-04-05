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

    init(router: AnyRouter) {
        _vm = StateObject(wrappedValue: OverViewModel(router: router))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                OverViewStatItemGridView(statModels: vm.scenarioAttemptResponseModel.statCards)

                VideoScoreView(
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
        OverView(router: router)
    }
}
