//
//  SwiftUIView.swift
//  OJT_Package
//
//  Created by Kashif Hussain on 13/01/26.
//

import Foundation
import SwiftUIUtilities

extension NavigationViewModel {
    
    struct AcuityAttemptNavModel {
        let scenarioID: Int
        let secnarioAttempts: [AcuityIQReportDataModel.Scenario.Attempt]
    }
    
    struct DetailReoportNavModel {
        let scenarioID: Int
        let secnarioAttempt: AcuityIQReportDataModel.Scenario.Attempt
    }
    
    public struct AcuityReportUploadNavModel {
        let scenarioModel: AcuityIQReportDataModel.Scenario
    }
    
}
