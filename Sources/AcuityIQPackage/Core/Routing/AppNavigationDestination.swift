//
//  File.swift
//  OJT_Package
//
//  Created by Kashif Hussain on 13/01/26.
//

import SwiftUI
import SwiftfulRouting
import SwiftUIUtilities

// MARK: - Navigation Destination
@MainActor
enum AppNavigationDestination {
    // Package destinations
    case packageDestination(NavigationDestination)

    // App-specific destinations
    case attemptList(navModel: NavigationViewModel.AcuityAttemptNavModel)
    case detailReportView(navModel: NavigationViewModel.DetailReoportNavModel)
    case evaluationCriteria(evaluationParameters: [AcuityIQReportDataModel.Scenario.EvaluationParameter])
    case keywordsView(keywords: [String])
    case herculeanEffortView(strengths: [String])
    case attemptBadgeView(attemptNumber: Int, totalAttempts: Int, attemptsUsed: Int)
    case reportUploadView(navModel: NavigationViewModel.AcuityReportUploadNavModel)

}

// MARK: - Navigation Protocol Conformance
extension AppNavigationDestination: NavigationProtocol {
    
    public func navigate(using router: AnyRouter) {
        
        switch self {
            
        case .packageDestination(let destination):
            destination.navigate(using: router)
            
        case .attemptList(let navModel):
            self.pushScreen(router) { router in
                AcuityAttemptListView(router: router, navModel: navModel)
            }
            
        case .detailReportView(let navModel):
            self.pushScreen(router) { router in
                DetailReportView(router: router, navModel: navModel)
            }

        case .evaluationCriteria(let evaluationParameters):
            self.showResizableSheet(router) { router in
                EvaluationCretrialView(router: router, evaluationCriteriaList: evaluationParameters)
            }

        case .keywordsView(let keywords):
            self.showResizableSheet(router) { router in
                KeywordsView(router: router, keywords: keywords)
            }

        case .herculeanEffortView(let strengths):
            self.showResizableSheet(router) { router in
                HerculeanEffortView(router: router, strengths: strengths)
            }

        case .attemptBadgeView(let attemptNumber, let totalAttempts, let attemptsUsed):
            self.showMediumSheet(router) { router in
                AttemptBadgeView(router: router, attemptNumber: attemptNumber, totalAttempts: totalAttempts, attemptsUsed: attemptsUsed)
            }

        case .reportUploadView(let navModel):
            self.pushScreen(router) { router in
                AcuityReportUploadView(router: router, navModel: navModel)
            }

        }

    }
    
    
}

