//
//  ManagerEvaluationListView.swift
//  AcuityIQPackage
//

import SwiftUI
import SwiftUIUtilities

public struct ManagerEvaluationListView: View {

    @StateObject private var vm: ManagerEvaluationListViewModel

    public init(router: AnyRouter, userID: Int? = nil) {
        _vm = StateObject(wrappedValue: ManagerEvaluationListViewModel(router: router, userID: userID))
    }

    public var body: some View {
        VStack {
            scenarioListView
                .stateDrivenViewPkg(
                    loadingState: vm.loadingState,
                    emptyState: vm.emptyState,
                    loadingContent: { ProgressView() }
                ) { emptyState in
                    EmptyStateView(emptyState: emptyState)
                }
                .loadingOverlayViewPkg(state: vm.loadingState)
                .toastViewPkg(toast: $vm.toast)
        }
        .task {
            await vm.loadInitial()
        }
    }
}

// MARK: - Sub-Views
private extension ManagerEvaluationListView {

    var scenarioListView: some View {
        ManagerEvaluationScenarioListView(
            items: vm.displayItems,
            onTapScenario: vm.didTapScenario,
            onLoadMore: vm.loadMore
        )
    }
}

#Preview {
    RouterView { router in
        ManagerEvaluationListView(router: router)
    }
}
