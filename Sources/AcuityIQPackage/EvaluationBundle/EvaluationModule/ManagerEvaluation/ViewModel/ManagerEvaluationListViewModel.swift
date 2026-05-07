//
//  ManagerEvaluationListViewModel.swift
//  AcuityIQPackage
//

import Foundation
import SwiftUIUtilities
import SwiftfulRouting
import NetworkService
import Combine

class ManagerEvaluationListViewModel: RoutableViewModel, PaginatableViewModel {

    // MARK: - PaginatableViewModel requirement
    @Published var items: [ManagerEvaluationListDataModel.ScenarioAttempt] = []

    var displayItems: [ManagerEvaluationListDataModel.ScenarioAttempt] { items }

    // MARK: - Properties
    let userID: Int?
    @Published var searchText: String = ""

    private let searchDebouncer = Debouncer<String>(interval: 0.5)

    // MARK: - Init
    init(router: AnyRouter, userID: Int? = nil) {
        self.userID = userID
        super.init(router: router)
        observeSearchText()
        observeListNeedsRefresh()
    }

    // MARK: - PaginatableViewModel requirement
    func fetchItems(
        pageIndex: Int,
        isLoadingMore: Bool
    ) async throws -> [ManagerEvaluationListDataModel.ScenarioAttempt] {
        let model = ManagerEvaluationListDataModel.GetScenarioAttemptsRequest(
            payload: .init(page: pageIndex, pageSize: itemsPerPage, users: userID.map { [$0] }, search: searchText)
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

// MARK: - Observation
private extension ManagerEvaluationListViewModel {

    func observeSearchText() {
        $searchText
            .dropFirst()
            .sink { [weak self] newValue in
                guard let self else { return }
                searchDebouncer.debounce(newValue) { [weak self] _ in
                    Task { [weak self] in await self?.loadInitial() }
                }
            }
            .store(in: &cancellables)
    }

    func observeListNeedsRefresh() {
        NotificationCenter.default
            .publisher(for: .managerEvaluationListNeedsRefresh)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                Task { [weak self] in await self?.silentRefresh() }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Silent Refresh
private extension ManagerEvaluationListViewModel {

    @MainActor
    func silentRefresh() async {
        guard !items.isEmpty else { return }
        do {
            let totalLoaded = items.count
            let model = ManagerEvaluationListDataModel.GetScenarioAttemptsRequest(
                payload: .init(page: 1, pageSize: totalLoaded, users: userID.map { [$0] }, search: searchText)
            )
            let response = try await ApiService.shared.requestPostHeader(
                type: ManagerEvaluationListDataModel.ScenarioAttemptsResponse.self,
                model: model,
                payload: model.payload
            )
            let fresh = response.data ?? []
            guard !fresh.isEmpty else { return }
            items = fresh
        } catch {
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
