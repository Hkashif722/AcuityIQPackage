//
//  SwiftUIView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 05/04/26.
//

import SwiftUI

struct AcuityReportItemView: View {
    
    let scenario: AcuityIQReportDataModel.Scenario
    
    var onTapCard: (AcuityIQReportDataModel.Scenario) -> Void
    var onTapEvaluationCriteria: (AcuityIQReportDataModel.Scenario) -> Void
    var onTapKeywords: (AcuityIQReportDataModel.Scenario) -> Void
    var onTapUploadAttempt: (AcuityIQReportDataModel.Scenario) -> Void 
    
    var body: some View {
        VStack(spacing: 8) {
            scanarioNameAndAttemptView
            scenarioDescriptionView
            actionView
        }
        .cardStylePkg(shadowRadius: 3, padding: 8)
        .contentShape(Rectangle())
        .onTapGesture {
            onTapCard(scenario)
        }
    }
    
    
    
}

//MARK: Scenario Name and Attemp View
extension AcuityReportItemView {
    
    private var scanarioNameAndAttemptView: some View {
        HStack {
            senarioNameView
            scenarioAttempBadgeView
        }
    }
   
    private var senarioNameView: some View {
        Text(scenario.scenarioName ?? "")
            .font(.subheadline.bold())
            .foregroundStyle(.gray)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var scenarioAttempBadgeView: some View {
        HStack {
            Image(systemName: "arrow.triangle.2.circlepath")
                .font(.caption)
                .foregroundStyle(scenario.progressBadgeColor)
            
            Text("\(scenario.pendingAttempts ?? 0) / \(scenario.maximumAttempts ?? 0)")
                .font(.caption.bold())
                .foregroundColor(scenario.progressBadgeColor)
                
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(scenario.progressBadgeColor.opacity(0.15))
        .cornerRadius(12)
    }
}

// MARK: Secnario Description
extension AcuityReportItemView {
    
    private var scenarioDescriptionView: some View {
        Text(scenario.scenarioDescription ?? "")
            .font(.caption)
            .foregroundStyle(.gray)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: Bottom Active View
extension AcuityReportItemView {
    
    private var actionView: some View {
        VStack(alignment: .leading) {
            HStack {
                evaluationCrateriaActionButton
                keywordsActionButton
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            uploadActionButton
        }
    }
    
    private var evaluationCrateriaActionButton: some View {
        SwiftUIUtility
            .RectangularIconButton(
                title: "Evaluation criteria",
                font: .caption.bold(),
                backgroundColor: Color(hex: "#5b6afa").opacity(0.3),
                foregroundColor: Color(hex: "#5b6afa"),
                height: 35,
                action: { onTapEvaluationCriteria(scenario) }
            )
            .frame(width: 130)
    }
    
    private var keywordsActionButton: some View {
        SwiftUIUtility
            .RectangularIconButton(
                title: "Keywords",
                font: .caption.bold(),
                backgroundColor: Color(hex: "#5b6afa").opacity(0.3),
                foregroundColor: Color(hex: "#5b6afa"),
                height: 35,
                action: { onTapKeywords(scenario) }
            )
            .frame(width: 100)
    }
    
    @ViewBuilder
    private var uploadActionButton: some View {
        if scenario.pendingAttempts != 0 {
            SwiftUIUtility
                .RectangularIconButton(
                    title: "Upload attempt",
                    font: .caption.bold(),
                    iconName: "square.and.arrow.up",
                    isSystemIcon: true,
                    backgroundColor: Color(hex: "#5b6afa"),
                    foregroundColor: .white,
                    height: 35,
                    action: { onTapUploadAttempt(scenario) }
                )
                .frame(width: 150)
        }
    }
}

#Preview {
    AcuityReportItemView(
        scenario: AcuityIQReportDataModel.Scenario.preview,
        onTapCard: { scenario in
            print("Card tapped for: \(scenario.scenarioName ?? "")")
        },
        onTapEvaluationCriteria: { scenario in
            print("Eval tapped for: \(scenario.scenarioName ?? "")")
        },
        onTapKeywords: { scenario in
            print("Keywords tapped for: \(scenario.scenarioName ?? "")")
        },
        onTapUploadAttempt: { scenario in
            print("Upload tapped for: \(scenario.scenarioName ?? "")")
        }
    )
    .padding()
}
