//
//  ManagerEvaluationScenarioListView.swift
//  AcuityIQPackage
//

import SwiftUI
import SwiftUIUtilities

struct ManagerEvaluationScenarioListView: View {

    let items: [ManagerEvaluationListDataModel.ScenarioAttempt]
    var onTapScenario: ((ManagerEvaluationListDataModel.ScenarioAttempt) -> Void)?
    var onLoadMore: (() async -> Void)?

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(items) { item in
                    ManagerEvaluationListItemView(scenario: item, onTap: { onTapScenario?(item) })
                        .task(id: item.id) {
                            if item.id == items.last?.id {
                                await onLoadMore?()
                            }
                        }
                }
            }
        }
        .versionedContentMarginsPkg()
        .applyScrollBounceBehaviorPkg()
    }
}

#Preview {
    ManagerEvaluationScenarioListView(
        items: [
            .preview(status: "Submitted", newAttempts: true),
            .preview(scenarioId: 10, scenarioName: "telimikind", courseTitle: "telimikind", status: "Pending", newAttempts: true),
            .preview(scenarioId: 11, scenarioName: "Clarinova 100", courseTitle: "Clarinova 100", status: "Pending", newAttempts: false)
        ]
    )
}
