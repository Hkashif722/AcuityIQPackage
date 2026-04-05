//
//  ScenarioSectionEvaluationHeaderView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 01/04/26.
//


import SwiftUI

struct ScenarioSectionEvaluationHeaderView: View {
    
    let title: String
    let scoreText: String
    let scoreColor: Color
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
            
            Spacer()
            
            Text(scoreText)
                .font(.subheadline.bold())
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(scoreColor, lineWidth: 1)
                )
                .foregroundStyle(scoreColor)
        }
    }
}