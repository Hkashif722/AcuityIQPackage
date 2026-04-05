//
//  ReportInfoView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 01/04/26.
//

import SwiftUI

struct ReportInfoView: View {
    typealias ScoreLevel = DetailReportDataModel.ScenarioAttemptResponse.ScoreLevel

    let summary: String
    let strength: [String]
    let areaOfImprovement: [String]
    let criticalErrors: [String]
    let detailedAnalysis: String  // fixed typo
    let level: ScoreLevel

    var body: some View {
        VStack(spacing: 16) {
            summaryReportView
            strengthReportView
            areaOfImprovementReportView
            criticalErrorsReportView
            detailedAnalysisReportView
            IntegrityScoreGroupView(level: level)
        }
    }

    // MARK: - Subviews

    private var summaryReportView: some View {
        ReportGroupView(
            icon: "doc.on.doc.fill",
            iconColor: .pink,
            title: "Summary",
            description: summary
        )
    }

    private var strengthReportView: some View {
        ReportBulletGroupView(
            icon: "checkmark.circle.fill",
            iconColor: .green,
            title: "Strengths",
            bullets: strength,
            bulletColor: .green
        )
    }

    private var areaOfImprovementReportView: some View {
        ReportBulletGroupView(
            icon: "chart.line.uptrend.xyaxis",
            iconColor: .blue,
            title: "Areas of Improvement",
            bullets: areaOfImprovement,
            bulletColor: .blue
        )
    }

    private var criticalErrorsReportView: some View {
        ReportBulletGroupView(
            icon: "exclamationmark.triangle.fill",
            iconColor: .red,
            title: "Critical Errors",
            bullets: criticalErrors,
            bulletColor: .red
        )
    }

    private var detailedAnalysisReportView: some View {
        ReportGroupView(
            icon: "text.magnifyingglass",
            iconColor: .purple,
            title: "Detailed Analysis",
            description: detailedAnalysis
        )
    }
}

// MARK: - Preview

#Preview {
    ScrollView {
        ReportInfoView(
            summary: "The delivered video transcript does not align with the reference material on thrombolytic for acute ischemic stroke, resulting in key gaps.",
            strength: [
                "In the beginning, the user introduced themselves confidently.",
                "Towards the middle, the user provided specific clinical data.",
                "In the end, the user attempted to present multiple treatment options."
            ],
            areaOfImprovement: [
                "Align content with the reference material by covering all key drug mechanisms.",
                "Incorporate clinical data and studies supporting thrombolytic therapy.",
                "Include a clear call to action for physicians to consider treatment protocols."
            ],
            criticalErrors: [
                "Incorrect dosage mentioned for alteplase administration.",
                "Contraindications were not addressed during the session.",
                "Failed to mention the 4.5-hour treatment window guideline."
            ],
            detailedAnalysis: "The session revealed a significant misalignment between the presented content and the approved reference material. While the structure showed promise, the clinical accuracy requires immediate attention before the next interaction.",
            level: .poor
        )
    }
    .versionedContentMarginsPkg()
}
