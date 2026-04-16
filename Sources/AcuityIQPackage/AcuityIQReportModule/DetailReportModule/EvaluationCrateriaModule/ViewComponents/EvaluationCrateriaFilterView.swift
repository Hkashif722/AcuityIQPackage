//
//  EvaluationCrateriaFilterView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 02/04/26.
//

import SwiftUI
import SwiftUIUtilities

struct EvaluationCrateriaFilterView: View {

    // MARK: - Input

    let dropDownOptions: [DetailReportDataModel.ScenarioAttemptResponse.EvaluationCriteriaFilterModel]

    var onSearchTextChange: (String) -> Void
    var onDropDownSelect: (DetailReportDataModel.ScenarioAttemptResponse.EvaluationCriteriaFilterModel) -> Void

    // MARK: - State

    @State private var parameter: String = ""

    // MARK: - Body

    var body: some View {
        VStack(spacing: 8) {
            searchField
            filterDropDown
        }
        .zIndex(2)
    }

    // MARK: - Search Field

    private var searchField: some View {
        SearchTextField(
            text: $parameter,
            placeholder: "Search Parameters...",
            onChange: onSearchTextChange,
            font: .system(size: 14, weight: .medium),
            height: 45
        )
    }

    // MARK: - Filter Dropdown

    private var filterDropDown: some View {
        DropDownMenuListViewPkg(
            dropDownOptions,
            placeholder: "Sort by",
            isSearchable: false,
            controlHeight: 45,
            font: .system(size: 14, weight: .medium),
            onSelection: { onDropDownSelect($0) }
        )
    }
}

#Preview {
    EvaluationCrateriaFilterView(
        dropDownOptions: DetailReportDataModel.ScenarioAttemptResponse.EvaluationCriteriaFilterModel.allOptions,
        onSearchTextChange: { _ in },
        onDropDownSelect: { _ in }
    )
}
