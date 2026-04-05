//
//  ScenarioSectionEvaluationCategoryListView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 01/04/26.
//


import SwiftUI

struct ScenarioSectionEvaluationCategoryListView: View {
    
    let title: String
    let items: [String]?
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            
            ScenarioSectionEvaluationCategoryRowView(
                icon: icon,
                title: title,
                color: color
            )
            
            if let items, !items.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(items, id: \.self) { item in
                        HStack(alignment: .top, spacing: 6) {
                            Text("•")
                            Text(item)
                        }
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    }
                }
            } else {
                Text("No \(title.lowercased()) observed")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .italic()
            }
        }
    }
}