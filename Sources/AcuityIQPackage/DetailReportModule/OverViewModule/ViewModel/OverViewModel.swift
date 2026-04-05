//
//  OverallViewModel.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 31/03/26.
//

import Foundation
import SwiftUIUtilities
import SwiftfulRouting

class OverallViewModel: RoutableViewModel {

    
    let scenarioAttemptResponseModel: OverViewDataModel.ScenarioAttemptResponse = .preview
    
  
    init(router: AnyRouter) {
        super.init(router: router)
    }
}

//MARK: Handle Action
extension OverallViewModel {
    
}

