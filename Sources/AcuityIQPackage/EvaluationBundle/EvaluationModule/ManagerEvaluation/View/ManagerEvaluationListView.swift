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
        VStack(spacing: 0) {
            searchView
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

    var searchView: some View {
        SearchTextField(
            text: $vm.searchText,
            placeholder: "Search scenarios...",
            font: .system(size: 14, weight: .medium),
            height: 45
        )
        .padding(10)
    }

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
