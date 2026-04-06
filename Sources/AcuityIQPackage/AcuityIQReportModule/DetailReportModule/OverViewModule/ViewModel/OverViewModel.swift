//
//  OverViewModel.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 31/03/26.
//

import Foundation
import SwiftUIUtilities
import SwiftfulRouting

class OverViewModel: RoutableViewModel {

    
    let scenarioAttemptResponseModel: DetailReportDataModel.ScenarioAttemptResponse
    
  
    init(router: AnyRouter, scenarioAttemptResponseModel:  DetailReportDataModel.ScenarioAttemptResponse) {
        self.scenarioAttemptResponseModel = scenarioAttemptResponseModel
        super.init(router: router)
    }
}

//MARK: Handle Action
extension OverViewModel {
    
}

