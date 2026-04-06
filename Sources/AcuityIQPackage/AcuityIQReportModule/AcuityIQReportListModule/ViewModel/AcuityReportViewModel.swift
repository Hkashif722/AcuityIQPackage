//
//  AcuityReportViewModel.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 05/04/26.
//

import Foundation
import SwiftUIUtilities
import SwiftfulRouting
import NetworkService

class AcuityReportViewModel: RoutableViewModel {


    @Published var scenarioResponseModel: [AcuityIQReportDataModel.Scenario] = []
    
    var scenarioModel: [AcuityIQReportDataModel.Scenario] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return scenarioResponseModel }
        
        return scenarioResponseModel.filter { scenario in
            // Safely unwrap scenarioName and perform case-insensitive search
            guard let name = scenario.scenarioName else { return false }
            return name.localizedCaseInsensitiveContains(query)
        }
    }
    
    @Published var searchText: String = String()
    
    init(router: AnyRouter) {
        super.init(router: router)
        self.getScenarioForUsers()
    }
}

//MARK: Handle Action
extension AcuityReportViewModel {
    
    func didTapScenarioCard(_ scenario: AcuityIQReportDataModel.Scenario) {
        let navModel = NavigationViewModel.AcuityAttemptNavModel(
            scenarioID: scenario.scenarioId,
            secnarioAttempts: scenario.attempts ?? []
        )
        NavigationService.shared.navigate(using: router, to: AppNavigationDestination.attemptList(navModel: navModel))
    }
    
    func didTapEvaluationCriteria(_ scenario: AcuityIQReportDataModel.Scenario) {
        let evaluationParameters = scenario.evaluationParameters ?? []
        NavigationService.shared.navigate(using: router, to: AppNavigationDestination.evaluationCriteria(evaluationParameters: evaluationParameters))
    }
    
    func didTapKeywords(_ scenario: AcuityIQReportDataModel.Scenario) {
        let keywords = scenario.keywords ?? []
        NavigationService.shared.navigate(using: router, to: AppNavigationDestination.keywordsView(keywords: keywords))
    }
    
    func didTapUploadAttempt(_ scenario: AcuityIQReportDataModel.Scenario) {
        NavigationService.shared.navigate(
            using: router,
            to: AppNavigationDestination.reportUploadView(scenarioId: scenario.scenarioId)
        )
    }
}


//MARK: Handle API Call
extension AcuityReportViewModel {
    
    private func getScenarioForUsers() {
        
        let scenarioTask = Task { [weak self] in
            
            guard let self else { return }
            
            self.loadingState = .loading(title: "Fetching scenario.", message: "Please wait.")
            
            let model = AcuityIQReportDataModel.GetUserScenarioRequestModel()
            
            do {
                self.scenarioResponseModel = try await ApiService.shared.requestGetHeader(type: [AcuityIQReportDataModel.Scenario].self, model: model)
                
                self.loadingState = .loaded
                self.emptyState = self.scenarioResponseModel.isEmpty ? .noData : .none
            } catch {
                Logger.shared.log(.error, message: "Error occure while calling api: \(model.path), ref: \(self)")
                self.loadingState = .none
                self.emptyState = .error
            }
            
            
        }
        
        self.tasks.insert(TaskUtility.AnyCancellableTask(scenarioTask))
    }
}
