//
//  AcuityReportUploadViewModel.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 06/04/26.
//

import Foundation
import SwiftUI
import SwiftUIUtilities
import SwiftfulRouting
import NetworkService

class RolePlayDashboardViewModel: RoutableViewModel {

    // MARK: - Published Properties
    
    @Published var totalAttempts: Int
    
    @Published var attemptRemaining: Int

    let navModel: NavigationViewModel.RolePlayDashboardNavModel

    // MARK: - Computed Properties

    var isAttemptExausted: Bool {
        attemptRemaining == 0
    }
  
    
    // MARK: - Initialization

    init(router: AnyRouter, navModel: NavigationViewModel.RolePlayDashboardNavModel) {
        self.navModel = navModel
        _totalAttempts = .init(initialValue: navModel.attempt?.total ?? 0)
        _attemptRemaining = .init(initialValue: navModel.attempt?.left ?? 0)
        super.init(router: router)
    }
}

// MARK: - Actions

extension RolePlayDashboardViewModel {

   

    func didTapEvaluationCriteria() {
        guard let raw = navModel.evaluationParameters,
              let data = try? JSONSerialization.data(withJSONObject: raw),
              let params = try? JSONDecoder().decode([AcuityIQReportDataModel.Scenario.EvaluationParameter].self, from: data) else {
            toast = .init(style: .error, message: "Something went wrong!")
            return
        }
        NavigationService.shared.navigate(using: router, to: AppNavigationDestination.evaluationCriteria(evaluationParameters: params))
    }

    func didTapKeywords() {
        let keywords = navModel.keywords ?? []
        NavigationService.shared.navigate(
            using: router,
            to: AppNavigationDestination.keywordsView(keywords: keywords)
        )
    }
    
    func didTapViewAttempts() {
        guard let moduleAttempts = navModel.moduleAttempts,
              let data = try? JSONSerialization.data(withJSONObject: moduleAttempts),
              let attempts = try? JSONDecoder().decode([AcuityIQReportDataModel.Scenario.Attempt].self, from: data) else {
            toast = .init(style: .error, message: "Something went wrong!")
            return
        }
        let attemptsNavModel = NavigationViewModel.AcuityAttemptNavModel(
            scenarioID: navModel.projectID ?? 0,
            secnarioAttempts: attempts,
            courseID: navModel.courseId,
            moduleID: navModel.moduleId
        )
        NavigationService.shared.navigate(using: router, to: AppNavigationDestination.attemptList(navModel: attemptsNavModel))
    }
    
    
    func didSelectStartRolePlay() {
        guard let projectID = navModel.projectID, let courseID = navModel.courseId, let moduleID = navModel.moduleId else {
            toast = .init(style: .error, message: "Something went wrong!")
            return
        }
        RolePlayKitService.shared.startRolePlay(
            router: router,
            projectID: projectID,
            courseID: courseID,
            moduleID: moduleID,
            moduleStatus: navModel.moduleStatus,
            onSubmit: { [weak self] in self?.attemptRemaining -= 1 }
        )
    }

}


