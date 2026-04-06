//
//  AllAttemptsView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 02/04/26.
//

import SwiftUI
import SwiftfulRouting

struct AllAttemptsView: View {

    @StateObject private var vm: AllAttemptViewModel

    init(router: AnyRouter, allAttemptResponse: AllAttemptDataModel.AllAttemptResponse) {
        _vm = StateObject(
            wrappedValue: AllAttemptViewModel(router: router, allAttemptResponse: allAttemptResponse)
        )
    }
    
    var body: some View {
        VStack(spacing: 0) {
            SharedSegmentView(
                items: vm.segmentItems,
                onSegmentSelect: vm.onSegmentSelect(_:)
            )
            .frame(height: 50)
            
            ScrollView {
                segmentView
            }
            .versionedContentMarginsPkg()
        }
    }
    
    private var segmentView: some View {
        Group {
            
            switch  vm.selectedSegment {
                
            case .overviewAndSections:
                if #available(iOS 16.0, *) {
                    OverViewAndSectionGraphView(
                        getOverAllChatDataModel: vm.getOverAllChatDataModel,
                        getSectionWiseProgressDataModel: vm.getSectionWiseProgressDataModel,
                        getCriticalErrorgGrapghDataModel: vm.getCriticalErrorgGrapghDataModel
                    )
                }
            case .evaluationCriteria:
                EvaluationCrateriaView(
                    title: vm.getEvaluationInfoTitle,
                    evaluationData: vm.getEvaluationData
                )
            case .behavioralAnalysis:
                EvaluationCrateriaView(
                    title: vm.getBehaviouralInfoTitle,
                    evaluationData: vm.getBehaviouralData
                )
            }
        }
    }
    
    @ViewBuilder
    private var allAttemptGraphCartView: some View {
        if #available(iOS 16.0, *) {
            OverViewAndSectionGraphView(
                getOverAllChatDataModel: vm.getOverAllChatDataModel,
                getSectionWiseProgressDataModel: vm.getSectionWiseProgressDataModel,
                getCriticalErrorgGrapghDataModel: vm.getCriticalErrorgGrapghDataModel
            )
        }
    }
}

#Preview {
    RouterView { router in
        AllAttemptsView(router: router, allAttemptResponse: .preview)
    }
}
