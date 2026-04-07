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
        let courseId: Int?

        init(scenarioModel: AcuityIQReportDataModel.Scenario, isFromModule: Bool = false, projectID: Int? = nil, moduleId: Int? = nil, courseId: Int? = nil) {
            self.scenarioModel = scenarioModel
            self.isFromModule = isFromModule
            self.projectID = projectID
            self.moduleId = moduleId
            self.courseId = courseId
        }
    }
    
}
