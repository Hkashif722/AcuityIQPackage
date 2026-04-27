//
//  ManagerEvaluationView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 13/04/26.
//

import SwiftUI
import SwiftUIUtilities

struct ManagerEvaluationView: View {

    @StateObject private var vm: ManagerEvaluationViewModel

    init(router: AnyRouter, navModel: NavigationViewModel.ManagerEvaluationNavModel) {
        _vm = StateObject(
            wrappedValue: ManagerEvaluationViewModel(router: router, navModel: navModel)
        )
    }

    var body: some View {
        VStack(spacing: 0) {
            scoreCardSection

            parameterBreakdownSection
        }
        .customBackButtonPkg(navTitle: "Manager Evaluation", action: vm.goBack)
    }

    private var scoreCardSection: some View {
        ManagerEvaluationScoreCardView(evaluation: vm.navModel.managerEvaluation)
            .padding(16)
    }

    private var parameterBreakdownSection: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ManagerEvaluationBreakdownHeaderView()

                ForEach(
                    Array((vm.navModel.managerEvaluation.parameters ?? []).enumerated()),
                    id: \.offset
                ) { index, parameter in
                    ManagerEvaluationParameterItemView(
                        index: index + 1,
                        parameter: parameter
                    )
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .versionedContentMarginsPkg()
        .applyScrollBounceBehaviorPkg()
    }
}

#Preview {
    RouterView { router in
        ManagerEvaluationView(
            router: router,
            navModel: .init(managerEvaluation: AcuityIQReportDataModel.Scenario.ManagerEvaluation(
                id: 1,
                date: "2026-04-13",
                time: "10:00 AM",
                overallScore: 7.5,
                parameters: [
                    .init(parameter: "Clarity", score: 1, remarks: "Ggfgj", totalWeightage: "20"),
                    .init(parameter: "Content Relevance", score: 2, remarks: "Gufdf hdgjjg", totalWeightage: "20"),
                    .init(parameter: "Structure & Organization", score: 3, remarks: "Hgfgjk", totalWeightage: "20"),
                    .init(parameter: "Intent Clarity", score: 4, remarks: "Guihf", totalWeightage: "20"),
                    .init(parameter: "Delivery", score: 5, remarks: "Good overall delivery", totalWeightage: "20")
                ]
            ))
        )
    }
}
