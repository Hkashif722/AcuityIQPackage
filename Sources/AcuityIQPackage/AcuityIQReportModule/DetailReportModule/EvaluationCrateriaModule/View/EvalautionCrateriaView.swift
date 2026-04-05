//
//  EvaluationCriteriaView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 01/04/26.
//

import SwiftUI
import SwiftfulRouting

struct EvaluationCriteriaView: View {

    @StateObject private var vm: EvaluationCretriaViewModel

    init(router: AnyRouter) {
        _vm = StateObject(
            wrappedValue: EvaluationCretriaViewModel(router: router)
        )
    }

    var body: some View {
        VStack(spacing: 16) {
            EvaluationCrateriaFilterView(
                dropDownOptions: vm.filterDropDownOptions,
                onSearchTextChange: vm.handleSearchChange,
                onDropDownSelect: vm.handleFilterSelection
            )
            .padding(.horizontal, 10)
            EvaluationCrateriaTableView(
                evaluationCriteriaModel: vm.evaluationCriteriaDataModel
            )
        }
    }
}

#Preview {
    RouterView { router in
        EvaluationCriteriaView(router: router)
    }
}
