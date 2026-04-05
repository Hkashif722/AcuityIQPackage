//
//  EvaluationCrateriaView.swift
//  AcuityIQPackage
//

import SwiftUI
import SwiftfulRouting

struct EvaluationCrateriaView: View {
    
    let title: String
    
    let evaluationData: [AllAttemptDataModel.Evaluation]
    
    var body: some View {
        VStack(spacing: 8) {
            ScenarioSectionInfoBannerView(text: title)
            evaluationSectionGroup
        }
        
    }
    
    private var evaluationSectionGroup: some View {
        LazyVStack {
            ForEach(evaluationData) { data in
                SectionDisclosureGroup(sectionTitle: data.title, sectionStatus: data.status, tagColor: data.getStatusColor) {
                    SectionContentView(evaluationData: data)
                }
                .cardStylePkg(shadowRadius: 3, padding: 8)
                
            }
        }
    }
    
}


#Preview {
    ScrollView {
        EvaluationCrateriaView(
            title: "Monitor behavioral metric trends across attempts. Click to expand and see average scores and feedback for each attempt.",
            evaluationData: AllAttemptDataModel.AllAttemptResponse.preview.evaluations
        )
    }
    .versionedContentMarginsPkg()
    
}
