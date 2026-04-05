//
//  EvaluationCretriaViewModel.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 02/04/26.
//


//
//  KeywordCoverageViewModel.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 01/04/26.
//

import Foundation
import SwiftUIUtilities
import SwiftfulRouting

class EvaluationCretriaViewModel: RoutableViewModel {

    let scenarioAttemptResponseModel: DetailReportDataModel.ScenarioAttemptResponse = .preview

    // MARK: - Filter State

    @Published private(set) var selectedSortOption: DetailReportDataModel.ScenarioAttemptResponse.EvaluationCriteriaSortOption = .scoreHighToLow
    @Published private(set) var searchText: String = ""

    // MARK: - Dropdown Options

    var filterDropDownOptions: [DetailReportDataModel.ScenarioAttemptResponse.EvaluationCriteriaFilterModel] {
        DetailReportDataModel.ScenarioAttemptResponse.EvaluationCriteriaFilterModel.allOptions
    }

    // MARK: - Computed Properties

    var evaluationCriteriaDataModel: [DetailReportDataModel.EvaluationCriteria] {
        let base = scenarioAttemptResponseModel.evaluationCriteria ?? []
        let filtered = searchText.isEmpty
            ? base
            : base.filter { $0.parameter.localizedCaseInsensitiveContains(searchText) }
        return selectedSortOption.sort(filtered)
    }

    var keywordCoverageDataModel: String {
        scenarioAttemptResponseModel.keywordCoverageModuleTitle
    }

    // MARK: - Init

    init(router: AnyRouter) {
        super.init(router: router)
    }
}

// MARK: - Handle Action

extension EvaluationCretriaViewModel {

    func handleSearchChange(_ text: String) {
        searchText = text
    }

    func handleFilterSelection(_ item: DetailReportDataModel.ScenarioAttemptResponse.EvaluationCriteriaFilterModel) {
        selectedSortOption = item.sortOption
    }
}
