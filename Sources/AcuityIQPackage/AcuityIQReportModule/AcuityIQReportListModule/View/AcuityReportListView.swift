//
//  AcuityReportView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 05/04/26.
//

import SwiftUI
import SwiftUIUtilities

public struct AcuityReportListView: View {
    
    @StateObject private var vm: AcuityReportViewModel
    
    public init(router: AnyRouter) {
        _vm = StateObject(
            wrappedValue: AcuityReportViewModel(router: router)
        )
    }
    
    public var body: some View {
        VStack {
            SearchTextField(text: $vm.searchText, placeholder: "Search scenarios...")
                .padding(10)
            reportListView
        }
        .loadingOverlayViewPkg(state: vm.loadingState)
        .task {
            await vm.getScenarioForUsers()
        }
    }
    
    private var reportListView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(vm.scenarioModel) { senario in
                    AcuityReportItemView(
                        scenario: senario,
                        onTapCard: vm.didTapScenarioCard(_:),
                        onTapEvaluationCriteria: vm.didTapEvaluationCriteria,
                        onTapKeywords: vm.didTapKeywords(_:),
                        onTapUploadAttempt: vm.didTapUploadAttempt(_:)
                    )
                }
            }
        }
        .versionedContentMarginsPkg()
        .applyScrollBounceBehaviorPkg()
    }
}

#Preview {
    RouterView { router in
        AcuityReportListView(router: router)
    }
   
}
