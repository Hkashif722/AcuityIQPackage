//
//  AcuityAttemptListViewModel.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 05/04/26.
//

import Foundation
import SwiftUIUtilities
import SwiftfulRouting

class AcuityAttemptListViewModel: RoutableViewModel {
    
   
    
    @Published var searchText: String = ""
    
    let navModel: NavigationViewModel.AcuityAttemptNavModel
    
    private var allAttempts: [AcuityIQReportDataModel.Scenario.Attempt] { navModel.secnarioAttempts }
    
    var attempts: [AcuityIQReportDataModel.Scenario.Attempt] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return allAttempts }
        
        return allAttempts.filter { attempt in
            if let userName = attempt.userName,
               userName.localizedCaseInsensitiveContains(query) {
                return true
            }
            if let attemptNumber = attempt.attemptNumber,
               "Attempt#\(attemptNumber)".localizedCaseInsensitiveContains(query) {
                return true
            }
            return false
        }
    }
    
    init(router: AnyRouter, navModel: NavigationViewModel.AcuityAttemptNavModel) {
        self.navModel = navModel
        super.init(router: router)
    }
}

// MARK: - Handle Actions
extension AcuityAttemptListViewModel {
    
    func didTapAttempt(_ attempt: AcuityIQReportDataModel.Scenario.Attempt) {
        // Navigate to detailed report view
        let navModel = NavigationViewModel.DetailReoportNavModel(
            scenarioID: navModel.scenarioID,
            secnarioAttempt: attempt,
            courseID: navModel.courseID,
            moduleID: navModel.moduleID
        )
        NavigationService.shared.navigate(using: router, to: AppNavigationDestination.detailReportView(navModel: navModel))
    }
    
    func onManagerEvalautionTap(_ attempt: AcuityIQReportDataModel.Scenario.Attempt) {
        
        guard let managerEvalauttion = attempt.managerEvaluation else {
            toast = .init(style: .warning, message: "Manager Evaluation not found")
            return
        }
        
        let navModel = NavigationViewModel.ManagerEvaluationNavModel(managerEvaluation: managerEvalauttion)
        NavigationService.shared.navigate(using: router, to: AppNavigationDestination.managerEvaluationView(navModel: navModel))
    }
}
