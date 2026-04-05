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

    
    let scenarioAttemptResponseModel: DetailReportDataModel.ScenarioAttemptResponse = .preview
    
    //MARK: Computed Properties
    var keywordCovergeDataModel: [DetailReportDataModel.KeywordCoverage] {
        scenarioAttemptResponseModel.keywordCoverage ?? []
    }
    
    var keywordCoverageDataModel: String {
        scenarioAttemptResponseModel.keywordCoverageModuleTitle
    }
    
    //MARK: Computed Properties
    init(router: AnyRouter) {
        super.init(router: router)
    }
    
}

//MARK: Handle Action
extension KeywordCoverageViewModel {
    
}

