//
//  ScenarioSectionEvaluationCardView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 01/04/26.
//


import SwiftUI

struct ScenarioSectionEvaluationResultCardView: View {
    
    typealias ScenarioSectionEvaluation = DetailReportDataModel.SectionEvaluation
    
    let section: ScenarioSectionEvaluation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            ScenarioSectionEvaluationResultHeaderView(
                title: section.name,
                scoreText: scoreText,
                scoreColor: scoreColor
            )
            
            Divider()
            
            ScenarioSectionEvaluationResultCategoryListView(
                title: "Strengths",
                items: section.strengths,
                color: .green,
                icon: "checkmark"
            )
            
            ScenarioSectionEvaluationResultCategoryListView(
                title: "Areas of Improvement",
                items: section.improvements,
                color: .blue,
                icon: "arrow.up.right"
            )
            
            ScenarioSectionEvaluationResultCategoryListView(
                title: "Critical Errors",
                items: section.errors,
                color: .red,
                icon: "minus.circle"
            )
        }
        .padding()
        .background(cardBackground)
    }
}

// MARK: - Helpers
private extension ScenarioSectionEvaluationResultCardView {
    
    var scoreText: String {
        if let score = section.score {
            return String(format: "%.1f/10", score)
        }
        return "--"
    }
    
    var scoreColor: Color {
        if let hex = section.color {
            return Color(hex: hex)
        }
        return .red
    }
    
    var cardBackground: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color(.systemBackground))
            .shadow(color: .black.opacity(0.05), radius: 6)
    }
}
