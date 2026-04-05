//
//  OverViewStatItemGridView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 31/03/26.
//

import SwiftUI

struct OverViewStatItemGridView: View {
    
    typealias StatCardModel = DetailReportDataModel.ScenarioAttemptResponse.StatCardModel
    
    let statModels: [StatCardModel]
    
    var body: some View {
        
        SwiftUIUtility
            .FlexibleRowColumnGridView(
                columns: 3,
                columnSpacing: 8,
                rowSpacing: 10
            ) {
            ForEach(statModels) { statsModel in
                OverViewStatItem(statModel: statsModel)
            }
            
        }
    }
}

#Preview {
    OverViewStatItemGridView(
        statModels: DetailReportDataModel.ScenarioAttemptResponse.preview.statCards
    )
    .padding(.horizontal, 10)
}
