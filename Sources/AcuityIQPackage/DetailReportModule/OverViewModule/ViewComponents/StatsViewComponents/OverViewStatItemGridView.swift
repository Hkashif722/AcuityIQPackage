//
//  OverViewStatItemGridView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 31/03/26.
//

import SwiftUI

struct OverViewStatItemGridView: View {
    
    typealias StatCardModel = OverViewDataModel.ScenarioAttemptResponse.StatCardModel
    
    let statModels: [StatCardModel]
    
    var body: some View {
        HStack {
            SwiftUIUtility.FlexibleGridView(columns: 3, spacing: 10) {
                ForEach(statModels) { statsModel in
                    OverViewStatItem(statModel: statsModel)
                }
            }
        }
    }
}

#Preview {
    OverViewStatItemGridView(
        statModels: OverViewDataModel.ScenarioAttemptResponse.preview.statCards
    )
}
