//
//  SwiftUIView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 31/03/26.
//

import SwiftUI
import SwiftUIUtilities


struct DetailReportView: View {
    
    @StateObject private var vm: DetailResportViewModel
    
    init(router: AnyRouter, navModel: NavigationViewModel.DetailReoportNavModel) {
       _vm = StateObject(
        wrappedValue: DetailResportViewModel(router: router, navModel: navModel)
       )
    }
    
    var body: some View {
        VStack(spacing: 0) {
            SharedSegmentView(
                items: vm.segmentItems,
                onSegmentSelect: vm.onSegmentSelect(_:)
            )
            .frame(height: 50)
            
            segmentView
            
            Spacer()
        }
        .loadingOverlayViewPkg(state: vm.loadingState)
    }
    
    @ViewBuilder
    private var segmentView: some View {
        if vm.selectedSegment.requiresScenarioData {
            scenarioDataDependentView
        } else {
            standaloneSegmentView
        }
    }

    @ViewBuilder
    private var scenarioDataDependentView: some View {
        if let scenarioResponse = vm.scenarioAnalysisResponse {
            switch vm.selectedSegment {
            case .overview:
                OverView(router: vm.router, scenarioResponse: scenarioResponse)
            case .breakdown:
                BreakDownView(router: vm.router, scenarioResponse: scenarioResponse)
            case .keywordsCoverage:
                KeywordCoverageView(router: vm.router, scenarioResponse: scenarioResponse)
            case .evaluationCriteria:
                EvaluationCriteriaView(router: vm.router, scenarioResponse: scenarioResponse)
            case .behavioralAnalysis:
                BehaviourAnalysisView(router: vm.router, scenarioResponse: scenarioResponse)
            default:
                EmptyView()
            }
        } else {
            EmptyStateView(emptyState: vm.emptyState)
        }
    }

    @ViewBuilder
    private var standaloneSegmentView: some View {
        switch vm.selectedSegment {
        case .allAttempts:
            if let allAttemptResponse = vm.allAttemptResponse {
                AllAttemptsView(router: vm.router, allAttemptResponse: allAttemptResponse)
            } else {
                EmptyStateView(emptyState: vm.emptyState)
            }
        case .leaderboard:
            if let leaderboardResponse = vm.leaderboardResponse {
                LeaderboardView(router: vm.router, leaderboardResponse: leaderboardResponse)
            } else {
                EmptyStateView(emptyState: vm.emptyState)
            }
        default:
            EmptyView()
        }
    }
}

#Preview {
    RouterView { router in
        DetailReportView(
            router: router,
            navModel: .init(
                scenarioID: 1,
                secnarioAttempt: .init(
                    attemptId: 1,
                    attemptNumber: 1,
                    userId: 1,
                    userName: "Preview User",
                    score: 85.0,
                    attemptDate: "2026-04-06"
                )
            )
        )
    }
}
