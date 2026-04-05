//
//  ScenarioSectionEvaluationCategoryRowView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 01/04/26.
//


import SwiftUI

struct ScenarioSectionEvaluationCategoryRowView: View {
    
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .foregroundStyle(color)
            
            Text(title)
                .font(.subheadline.bold())
                .foregroundStyle(color)
        }
    }
}