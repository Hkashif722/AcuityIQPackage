//
//  SwiftUIView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 01/04/26.
//

import SwiftUI
import SwiftfulRouting

struct KeywordCoverageView: View {

    @StateObject private var vm: KeywordCoverageViewModel

    init(router: AnyRouter, scenarioResponse: DetailReportDataModel.ScenarioAttemptResponse) {
        _vm = StateObject(
            wrappedValue: KeywordCoverageViewModel(router: router, scenarioAttemptResponseModel: scenarioResponse)
        )
    }
    
    var body: some View {
        VStack(spacing: 16) {
            ScenarioSectionInfoBannerView(text: vm.keywordCoverageDataModel)
                .padding(.horizontal, 10)
            KeywordCoverageTableView(keywordCoverageDataModel: vm.keywordCovergeDataModel)
        }
    }
}

#Preview {
    RouterView { router in
        KeywordCoverageView(router: router, scenarioResponse: .preview)
    }
}
