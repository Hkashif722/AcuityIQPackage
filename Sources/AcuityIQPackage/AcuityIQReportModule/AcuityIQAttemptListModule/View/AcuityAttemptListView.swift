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
            SearchTextField(text: $vm.searchText, placeholder: "Search attempts...")
                .padding(10)
            
            attemptListView
        }
    }
    
    private var attemptListView: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(vm.attempts) { attempt in
                    AcuityAttemptItemView(
                        attempt: attempt,
                        onTap: vm.didTapAttempt
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
        AcuityAttemptListView(
            router: router,
            navModel: .init(
                scenarioID: AcuityIQReportDataModel.Scenario.previewData.first?.id ?? 0,
                secnarioAttempts: AcuityIQReportDataModel.Scenario.previewData.first?.attempts ?? []
            )
        )
    }
}
