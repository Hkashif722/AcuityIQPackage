//
//  ManagerEvaluationListViewModel.swift
//  AcuityIQPackage
//

import Foundation
import SwiftUIUtilities
import SwiftfulRouting
import NetworkService

class ManagerEvaluationListViewModel: RoutableViewModel, PaginatableViewModel {

    // MARK: - PaginatableViewModel requirement
    @Published var items: [ManagerEvaluationListDataModel.ScenarioAttempt] = []

    var displayItems: [ManagerEvaluationListDataModel.ScenarioAttempt] { items }

    // MARK: - Properties
    let userID: Int?

    // MARK: - Init
    init(router: AnyRouter, userID: Int? = nil) {
        self.userID = userID
        super.init(router: router)
//        tasks.insert(
//            TaskUtility.AnyCancellableTask(
//                Task { [weak self] in await self?.loadInitial() }
//            )
//        )
    }

    // MARK: - PaginatableViewModel requirement
    func fetchItems(
        pageIndex: Int,
        isLoadingMore: Bool
    ) async throws -> [ManagerEvaluationListDataModel.ScenarioAttempt] {
        let model = ManagerEvaluationListDataModel.GetScenarioAttemptsRequest(
            payload: .init(page: pageIndex, pageSize: itemsPerPage, users: userID.map { [$0] })
        )
        let response = try await ApiService.shared.requestPostHeader(
            type: ManagerEvaluationListDataModel.ScenarioAttemptsResponse.self,
            model: model,
            payload: model.payload
        )
        return response.data ?? []
    }

    // MARK: - Custom loading message
    func setLoadingState(isLoadingMore: Bool) {
        if !isLoadingMore {
            loadingState = .loading(message: "Please wait...")
            emptyState = .none
        }
    }
}

// MARK: - Actions
extension ManagerEvaluationListViewModel {

    func didTapScenario(_ scenario: ManagerEvaluationListDataModel.ScenarioAttempt) {
        let navModel = NavigationViewModel.ManagerEvaluationAttemptListNavModel(scenario: scenario)
        NavigationService.shared.navigate(
            using: router,
            to: AppNavigationDestination.managerEvaluationAttemptList(navModel: navModel)
        )
    }
}
