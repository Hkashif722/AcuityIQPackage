//
//  ManagerEvaluationAttemptListViewModel.swift
//  AcuityIQPackage
//

import Foundation
import SwiftUIUtilities
import SwiftfulRouting
import Combine

class ManagerEvaluationAttemptListViewModel: RoutableViewModel {

    // MARK: - Navigation Model
    let navModel: NavigationViewModel.ManagerEvaluationAttemptListNavModel

    // MARK: - Published State
    @Published var searchText: String = ""
    @Published var allAttempts: [ManagerEvaluationListDataModel.ScenarioAttempt.Attempt] = []
    var shouldRefreshScenario = false

    var scenario: ManagerEvaluationListDataModel.ScenarioAttempt { navModel.scenario }

    var displayAttempts: [ManagerEvaluationListDataModel.ScenarioAttempt.Attempt] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return allAttempts }
        return allAttempts.filter { attempt in
            "Attempt#\(attempt.attemptNumber ?? 0)".localizedCaseInsensitiveContains(query)
        }
    }

    // MARK: - Init
    init(router: AnyRouter, navModel: NavigationViewModel.ManagerEvaluationAttemptListNavModel) {
        self.navModel = navModel
        super.init(router: router)
        allAttempts = navModel.scenario.allAttempts ?? []
        observeEvaluationSubmitted()
    }
}

// MARK: - Actions
extension ManagerEvaluationAttemptListViewModel {

    func didTapAttempt(_ attempt: ManagerEvaluationListDataModel.ScenarioAttempt.Attempt) {
        let mappedAttempt = AcuityIQReportDataModel.Scenario.Attempt(
            attemptId: attempt.attemptId,
            attemptNumber: attempt.attemptNumber,
            userId: scenario.userId,
            userName: scenario.userName,
            score: attempt.score,
            attemptDate: [attempt.attemptDate, attempt.attemptTime]
                .compactMap { $0 }
                .joined(separator: " "),
            managerEvaluation: nil
        )
        let detailNavModel = NavigationViewModel.DetailReoportNavModel(
            scenarioID: scenario.scenarioId,
            secnarioAttempt: mappedAttempt,
            courseID: scenario.courseId,
            moduleID: scenario.moduleId
        )
        NavigationService.shared.navigate(
            using: router,
            to: AppNavigationDestination.detailReportView(navModel: detailNavModel)
        )
    }

    func didTapEvaluate(_ attempt: ManagerEvaluationListDataModel.ScenarioAttempt.Attempt) {
        shouldRefreshScenario = true
        let navModel = NavigationViewModel.EvaluateModuleNavModel(
            attempt: attempt,
            scenario: scenario
        )
        NavigationService.shared.navigate(
            using: router,
            to: AppNavigationDestination.evaluateModule(navModel: navModel)
        )
    }
}

// MARK: - Observation
private extension ManagerEvaluationAttemptListViewModel {

    func observeEvaluationSubmitted() {
        NotificationCenter.default
            .publisher(for: .managerEvaluationSubmitted)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] notification in
                guard let self,
                      let attemptId = notification.userInfo?["attemptId"] as? Int,
                      let overallScore = notification.userInfo?["overallScore"] as? Double,
                      let index = allAttempts.firstIndex(where: { $0.attemptId == attemptId })
                else { return }
                let old = allAttempts[index]
                allAttempts[index] = ManagerEvaluationListDataModel.ScenarioAttempt.Attempt(
                    attemptId: old.attemptId,
                    attemptNumber: old.attemptNumber,
                    score: old.score,
                    attemptDate: old.attemptDate,
                    attemptTime: old.attemptTime,
                    evaluationSubmitted: true,
                    overallScore: overallScore
                )
            }
            .store(in: &cancellables)
    }
}
