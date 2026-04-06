//
//  File.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 31/03/26.
//

import Foundation
import SwiftUIUtilities
import SwiftfulRouting
import NetworkService

class DetailResportViewModel: RoutableViewModel {

    @Published private(set) var selectedSegment: DetailReportDataModel.AnalyticsTab = .overview
    @Published var scenarioAnalysisResponse: DetailReportDataModel.ScenarioAttemptResponse?
    @Published var allAttemptResponse: AllAttemptDataModel.AllAttemptResponse?
    @Published var leaderboardResponse: [LeaderboardDataModel.LeaderboardAttempt]?

    let segmentItems: [DetailReportDataModel.AnalyticsTab] = DetailReportDataModel.AnalyticsTab.allCases
    let navModel: NavigationViewModel.DetailReoportNavModel

    init(router: AnyRouter, navModel: NavigationViewModel.DetailReoportNavModel) {
        self.navModel = navModel
        super.init(router: router)
        self.fetchAllData()
    }
}

//MARK: Handle Action
extension DetailResportViewModel {
    
    func onSegmentSelect(_ segment: DetailReportDataModel.AnalyticsTab) {
        self.selectedSegment = segment
    }
}

//MARK: Handle API Call
extension DetailResportViewModel {

    private func fetchAllData() {
        let task = Task { [weak self] in
            guard let self else { return }

            self.loadingState = .loading(title: "Fetching data.", message: "Please wait.")

            async let analysisResult = self.fetchScenarioAnalysis()
            async let allAttemptResult = self.fetchAllAttemptReport()
            async let leaderboardResult = self.fetchLeaderboard()

            let (analysis, allAttempt, leaderboard) = await (analysisResult, allAttemptResult, leaderboardResult)

            self.scenarioAnalysisResponse = analysis
            self.allAttemptResponse = allAttempt
            self.leaderboardResponse = leaderboard

            self.loadingState = .loaded
            self.emptyState = (analysis == nil && allAttempt == nil && leaderboard == nil) ? .noData : .none
        }

        self.tasks.insert(TaskUtility.AnyCancellableTask(task))
    }

    private func fetchScenarioAnalysis() async -> DetailReportDataModel.ScenarioAttemptResponse? {
        let model = DetailReportDataModel.GetScenarioAnalysisRequestModel(
            attemptID: navModel.secnarioAttempt.attemptId
        )

        do {
            return try await ApiService.shared.requestGetHeader(
                type: DetailReportDataModel.ScenarioAttemptResponse.self,
                model: model
            )
        } catch {
            Logger.shared.log(.error, message: "Error fetching scenario analysis: \(model.path), ref: \(self)")
            return nil
        }
    }

    private func fetchAllAttemptReport() async -> AllAttemptDataModel.AllAttemptResponse? {
        let model = AllAttemptDataModel.GetSecnaioOverallReportRequestModel(
            secnarioID: navModel.scenarioID,
            userID: navModel.secnarioAttempt.userId
        )

        do {
            return try await ApiService.shared.requestGetHeader(
                type: AllAttemptDataModel.AllAttemptResponse.self,
                model: model
            )
        } catch {
            Logger.shared.log(.error, message: "Error fetching all attempt report: \(model.path), ref: \(self)")
            return nil
        }
    }

    private func fetchLeaderboard() async -> [LeaderboardDataModel.LeaderboardAttempt]? {
        let model = LeaderboardDataModel.GetScenarioLeaderboardRequestModel(
            secnarioID: navModel.scenarioID
        )

        do {
            return try await ApiService.shared.requestGetHeader(
                type: [LeaderboardDataModel.LeaderboardAttempt].self,
                model: model
            )
        } catch {
            Logger.shared.log(.error, message: "Error fetching leaderboard: \(model.path), ref: \(self)")
            return nil
        }
    }
}
