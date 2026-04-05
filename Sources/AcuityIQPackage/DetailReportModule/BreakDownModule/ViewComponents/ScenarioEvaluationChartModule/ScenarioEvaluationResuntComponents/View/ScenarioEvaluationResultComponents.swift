//
//  ScenarioEvaluationResultComponents.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 01/04/26.
//

import SwiftUI

struct ScenarioEvaluationResultComponents: View {
    typealias ScenarioSectionEvaluation = DetailReportDataModel.SectionEvaluation
    let sections: [ScenarioSectionEvaluation]
    
    var body: some View {
        VStack(spacing: 16) {
            ForEach(sections) { section in
                ScenarioSectionEvaluationResultCardView(section: section)
            }
        }
        .padding(10)
        .background(Color(.systemGroupedBackground))
        .cornerRadiusPkg(10, corners: .allCorners)
    }
}


#Preview {
    ScrollView {
        ScenarioEvaluationResultComponents(
            sections: DetailReportDataModel.ScenarioAttemptResponse.preview.sections ?? []
        )
    }
    .versionedContentMarginsPkg()
}
