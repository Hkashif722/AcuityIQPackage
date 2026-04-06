//
//  BehaviourAnalysisViewModel.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 02/04/26.
//

import Foundation
import SwiftUIUtilities
import SwiftfulRouting

class BehaviourAnalysisViewModel: RoutableViewModel {

    let scenarioAttemptResponseModel: DetailReportDataModel.ScenarioAttemptResponse

    //Computed Properties

    var behaviourAttemptHeaderTitle: String {
        scenarioAttemptResponseModel.behaviourAnalysisTitle
    }

    var getCalculatedLineGraphData: [
        (
            config: LineChartConfiguration.MetricLineChartConfig,
            points: [LineChartDataModel.LineChartPoint],
            feedback: String
        )
    ] {
        scenarioAttemptResponseModel.getCalculatedbehaviourChartModels
    }

    var improvementRequiredData: [String: [String]] {
        scenarioAttemptResponseModel.improvementsRequired ?? [:]
    }

    var whatWentWellInfoText: String? {
        scenarioAttemptResponseModel.whatWentWell
    }

    // MARK: - Init

    init(router: AnyRouter, scenarioAttemptResponseModel: DetailReportDataModel.ScenarioAttemptResponse) {
        self.scenarioAttemptResponseModel = scenarioAttemptResponseModel
        super.init(router: router)
    }
}

// MARK: - Handle Action

extension BehaviourAnalysisViewModel {

}
