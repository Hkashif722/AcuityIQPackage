//
//  SwiftUIView.swift
//  AcuityIQ_Package
//
//  Created by Kashif Hussain on 13/01/26.
//

import Foundation
import SwiftUIUtilities

extension NavigationViewModel {
    
    struct AcuityAttemptNavModel {
        let scenarioID: Int
        let secnarioAttempts: [AcuityIQReportDataModel.Scenario.Attempt]
        let courseID: Int?
        let moduleID: Int?
        
        init(scenarioID: Int, secnarioAttempts: [AcuityIQReportDataModel.Scenario.Attempt], courseID: Int? = nil, moduleID: Int? = nil) {
            self.scenarioID = scenarioID
            self.secnarioAttempts = secnarioAttempts
            self.courseID = courseID
            self.moduleID = moduleID
        }
    }
    
    struct DetailReoportNavModel {
        let scenarioID: Int
        let secnarioAttempt: AcuityIQReportDataModel.Scenario.Attempt
        let courseID: Int?
        let moduleID: Int?
        
        init(scenarioID: Int, secnarioAttempt: AcuityIQReportDataModel.Scenario.Attempt, courseID: Int? = nil , moduleID: Int? = nil) {
            self.scenarioID = scenarioID
            self.secnarioAttempt = secnarioAttempt
            self.courseID = courseID
            self.moduleID = moduleID
        }
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

    struct ManagerEvaluationListNavModel {
        // Reserved for future filters/configuration passed into the list
    }

    struct ManagerEvaluationAttemptListNavModel {
        let scenario: ManagerEvaluationListDataModel.ScenarioAttempt
    }

    struct EvaluateModuleNavModel {
        let attempt: ManagerEvaluationListDataModel.ScenarioAttempt.Attempt
        let scenario: ManagerEvaluationListDataModel.ScenarioAttempt
    }
    
}


//MARK: Role Play related Model

extension NavigationViewModel {
    
    struct RolePlayDashboardNavModel {
        let rolePlayTitle: String
        let projectID: Int?
        let moduleId: Int?
        let moduleStatus: String?
        let courseId: Int?
        let attempt: (total: Int?, left: Int?)?
        let moduleAttempts: [[String: Any]]?
        let evaluationParameters: [[String: Any]]?
        let keywords: [String]?

        init(
            rolePlayTitle: String,
            projectID: Int? = nil,
            moduleId: Int? = nil,
            moduleStatus: String? = nil,
            courseId: Int? = nil,
            attempt: (total: Int?, left: Int?)? = nil,
            moduleAttempts: [[String: Any]]? = nil,
            evaluationParameters: [[String: Any]]? = nil,
            keywords: [String]? = nil
        ) {
            self.rolePlayTitle = rolePlayTitle
            self.projectID = projectID
            self.moduleId = moduleId
            self.moduleStatus = moduleStatus
            self.courseId = courseId
            self.attempt = attempt
            self.moduleAttempts = moduleAttempts
            self.evaluationParameters = evaluationParameters
            self.keywords = keywords
        }
    }
}
