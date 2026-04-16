//
//  AcuityAttemptListView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 05/04/26.
//

import SwiftUI
import SwiftUIUtilities

struct AcuityAttemptListView: View {
    
    @StateObject private var vm: AcuityAttemptListViewModel
    
    init(router: AnyRouter, navModel: NavigationViewModel.AcuityAttemptNavModel) {
        _vm = StateObject(
            wrappedValue: AcuityAttemptListViewModel(router: router, navModel: navModel)
        )
    }
    
    var body: some View {
        
        VStack(spacing: 0) {
            searchView
            attemptListContentView
        }
        .customBackButtonPkg(navTitle: "Attempts", action: vm.goBack)
    }
    
    private var searchView: some View {
        SearchTextField(
            text: $vm.searchText,
            placeholder: "Search attempts...",
            font: .system(size: 14, weight: .medium),
            height: 45
        )
        .padding(10)
    }
    
    
    private var attemptListContentView: some View {
        ScrollView {
            switch vm.attempts.isEmpty {
            case false:
                attemptListView
            default:
                EmptyStateView(emptyState: .noData)
            }
        }
        .versionedContentMarginsPkg()
        .applyScrollBounceBehaviorPkg()
    }
    
    private var attemptListView: some View {
        LazyVStack(spacing: 10) {
            ForEach(vm.attempts) { attempt in
                AcuityAttemptItemView(
                    attempt: attempt,
                    onManagerEvaluationTap: vm.onManagerEvalautionTap,
                    onTap: vm.didTapAttempt
                )
            }
        }
    }
}

#Preview {
    RouterView { router in
        AcuityAttemptListView(
            router: router,
            navModel: .init(
                scenarioID: AcuityIQReportDataModel.Scenario.previewData.first?.id ?? 0,
                secnarioAttempts: AcuityIQReportDataModel.Scenario.previewData.first?.attempts ?? []
            )
        )
    }
}
