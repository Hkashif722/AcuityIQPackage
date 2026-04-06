//
//  AllAttemptViewModel.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 02/04/26.
//


import Foundation
import SwiftUIUtilities
import SwiftfulRouting

class AllAttemptViewModel: RoutableViewModel {

    let allAttemptDataModel: AllAttemptDataModel.AllAttemptResponse

    let segmentItems: [AllAttemptDataModel.AllDataTab] = AllAttemptDataModel.AllDataTab.allCases

    @Published private(set) var selectedSegment: AllAttemptDataModel.AllDataTab = .overviewAndSections

    //Computed Properties

    var getOverAllChatDataModel: (config: LineChartConfiguration.MetricLineChartConfig, model: [LineChartDataModel.LineChartPoint]) {
        allAttemptDataModel.overallRatingGrapghDataModel
    }

    var getSectionWiseProgressDataModel: (
        config: LineChartConfiguration.MetricLineChartConfig,
        model: [LineChartDataModel.SectionPoint]
    ) {
        allAttemptDataModel.sectionWiseProgressGraphDataModel
    }

    var getCriticalErrorgGrapghDataModel: (config: LineChartConfiguration.MetricLineChartConfig, model: [LineChartDataModel.LineChartPoint]) {
        allAttemptDataModel.criticalErrorgGrapghDataModel
    }

    var getEvaluationData: [AllAttemptDataModel.Evaluation] {
        allAttemptDataModel.evaluations
    }

    var getEvaluationInfoTitle: String {
        allAttemptDataModel.evaluationInfoTitle
    }

    var getBehaviouralData: [AllAttemptDataModel.Evaluation] {
        allAttemptDataModel.behavioural
    }

    var getBehaviouralInfoTitle: String {
        allAttemptDataModel.behaviourInfoTitle
    }

    // MARK: - Init
    init(router: AnyRouter, allAttemptResponse: AllAttemptDataModel.AllAttemptResponse) {
        self.allAttemptDataModel = allAttemptResponse
        super.init(router: router)
    }
}

// MARK: - Handle Action
extension AllAttemptViewModel {

    func onSegmentSelect(_ segment: AllAttemptDataModel.AllDataTab) {
        print(segment.self)
        self.selectedSegment = segment
    }
}



