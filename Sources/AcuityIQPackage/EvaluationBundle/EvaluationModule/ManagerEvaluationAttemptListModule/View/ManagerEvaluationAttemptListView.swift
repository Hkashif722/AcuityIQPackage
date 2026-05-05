//
//  ManagerEvaluationAttemptListView.swift
//  AcuityIQPackage
//

import SwiftUI
import SwiftUIUtilities

struct ManagerEvaluationAttemptListView: View {

    @StateObject private var vm: ManagerEvaluationAttemptListViewModel

    init(router: AnyRouter, navModel: NavigationViewModel.ManagerEvaluationAttemptListNavModel) {
        _vm = StateObject(
            wrappedValue: ManagerEvaluationAttemptListViewModel(router: router, navModel: navModel)
        )
    }

    var body: some View {
        VStack(spacing: 0) {
            searchView
            attemptListContentView
        }
        .customBackButtonPkg(navTitle: "Attempts", action: vm.goBack)
    }
}

// MARK: - Sub-Views
private extension ManagerEvaluationAttemptListView {

    var searchView: some View {
        SearchTextField(
            text: $vm.searchText,
            placeholder: "Search attempts...",
            font: .system(size: 14, weight: .medium),
            height: 45
        )
        .padding(10)
    }

    var attemptListContentView: some View {
        ScrollView {
            switch vm.displayAttempts.isEmpty {
            case false:
                attemptListView
            default:
                EmptyStateView(emptyState: .noData)
            }
        }
        .versionedContentMarginsPkg()
        .applyScrollBounceBehaviorPkg()
    }

    var attemptListView: some View {
        LazyVStack(spacing: 10) {
            ForEach(vm.displayAttempts) { attempt in
                ManagerEvaluationAttemptItemView(
                    attempt: attempt,
                    userName: vm.scenario.userName,
                    onTap: { vm.didTapAttempt(attempt) },
                    onEvaluate: { vm.didTapEvaluate(attempt) }
                )
            }
        }
        .padding(.horizontal, 10)
    }
}

#Preview {
    RouterView { router in
        ManagerEvaluationAttemptListView(
            router: router,
            navModel: .init(
                scenario: .preview()
            )
        )
    }
}
