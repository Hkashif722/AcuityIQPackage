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
    
    init(router: AnyRouter) {
       _vm = StateObject(
        wrappedValue: DetailResportViewModel(router: router)
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
    }
    
    private var segmentView: some View {
        Group {
            switch vm.selectedSegment {
            case .overview:
                OverView(router: vm.router)
            case .breakdown:
                BreakDownView(router: vm.router)
            case .keywordsCoverage:
                KeywordCoverageView(router: vm.router)
            case .evaluationCriteria:
                EvaluationCriteriaView(router: vm.router) 
            case .behavioralAnalysis:
                BehaviourAnalysisView(router: vm.router)
            case .allAttempts:
                AllAttemptsView(router: vm.router)
            case .leaderboard:
                LeaderboardView(router: vm.router)
            }
        }
    }
}

#Preview {
    RouterView { router in
        DetailReportView(router: router)
    }
  
}
