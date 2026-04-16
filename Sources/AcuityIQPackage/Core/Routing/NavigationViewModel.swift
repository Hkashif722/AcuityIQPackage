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
    
    struct AcuityReportUploadNavModel {
        let scenarioModel: AcuityIQReportDataModel.Scenario
        let isFromModule: Bool
        let projectID: Int? // Correspond to scenarioId
        let moduleId: Int?
        let moduleStatus: String?
        let courseId: Int?
        let attempt: (total: Int?, left: Int?)?
        let moduleAttempts: [[String: Any]]?

        init(scenarioModel: AcuityIQReportDataModel.Scenario, isFromModule: Bool = false, projectID: Int? = nil, moduleId: Int? = nil, moduleStatus: String? = nil, courseId: Int? = nil, attempt: (total: Int?, left: Int?)? = nil, moduleAttempts: [[String: Any]]? = nil ) {
            self.scenarioModel = scenarioModel
            self.isFromModule = isFromModule
            self.projectID = projectID
            self.moduleId = moduleId
            self.moduleStatus = moduleStatus
            self.courseId = courseId
            self.attempt = attempt
            self.moduleAttempts = moduleAttempts
        }
    }
    
    struct ManagerEvaluationNavModel {
        let managerEvaluation: AcuityIQReportDataModel.Scenario.ManagerEvaluation
    }
    
}
