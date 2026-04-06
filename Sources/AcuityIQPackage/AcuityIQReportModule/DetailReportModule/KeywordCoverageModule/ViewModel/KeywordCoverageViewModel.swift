//
//  KeywordCoverageViewModel.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 01/04/26.
//

import Foundation
import SwiftUIUtilities
import SwiftfulRouting

class KeywordCoverageViewModel: RoutableViewModel {

    let scenarioAttemptResponseModel: DetailReportDataModel.ScenarioAttemptResponse

    //MARK: Computed Properties
    var keywordCovergeDataModel: [DetailReportDataModel.KeywordCoverage] {
        scenarioAttemptResponseModel.keywordCoverage ?? []
    }

    var keywordCoverageDataModel: String {
        scenarioAttemptResponseModel.keywordCoverageModuleTitle
    }

    init(router: AnyRouter, scenarioAttemptResponseModel: DetailReportDataModel.ScenarioAttemptResponse) {
        self.scenarioAttemptResponseModel = scenarioAttemptResponseModel
        super.init(router: router)
    }
}

//MARK: Handle Action
extension KeywordCoverageViewModel {
    
}

