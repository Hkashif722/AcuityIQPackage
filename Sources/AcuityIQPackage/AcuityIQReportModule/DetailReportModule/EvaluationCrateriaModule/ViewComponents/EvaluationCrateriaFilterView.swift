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
        HStack {
            searchField
            Spacer()
            filterDropDown
        }
        .zIndex(2)
    }

    // MARK: - Search Field

    private var searchField: some View {
        SearchTextField(
            text: $parameter,
            placeholder: "Search Parameters...",
            onChange: onSearchTextChange
        )
    }

    // MARK: - Filter Dropdown

    private var filterDropDown: some View {
        DropDownMenuListViewPkg(
            dropDownOptions,
            placeholder: "Sort by",
            isSearchable: false,
            controlHeight: 38,
            font: .caption,
            onSelection: { onDropDownSelect($0) }
        )
        .frame(width: 155)
        .minimumScaleFactor(0.7)
    }
}

#Preview {
    EvaluationCrateriaFilterView(
        dropDownOptions: DetailReportDataModel.ScenarioAttemptResponse.EvaluationCriteriaFilterModel.allOptions,
        onSearchTextChange: { _ in },
        onDropDownSelect: { _ in }
    )
}
