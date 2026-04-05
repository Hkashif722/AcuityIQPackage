//
//  ReportScoreGroupView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 01/04/26.
//

import SwiftUI

// MARK: - View

struct IntegrityScoreGroupView: View {
    typealias ScoreLevel = OverViewDataModel.ScenarioAttemptResponse.ScoreLevel

    let icon: String
    var iconColor: Color = .accentColor
    let title: String
    let subtitle: String
    let alertMessage: String
    let level: ScoreLevel

    var body: some View {
        GroupBox {
            contentView

        } label: {
            labelView
        }
    }
    
    private var contentView: some View {
        VStack(alignment: .leading, spacing: 12) {

            // Italic subtitle
            Text("— \(subtitle)")
                .font(.subheadline)
                .italic()
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            // Alert box
            HStack(alignment: .top, spacing: 0) {

                // Left accent bar
                Rectangle()
                    .fill(level.color)
                    .frame(width: 4)

                // Alert content
                VStack(alignment: .leading, spacing: 6) {
                    Label {
                        Text(level.alertTitle)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(level.color)
                    } icon: {
                        Image(systemName: level.alertIcon)
                            .foregroundStyle(level.alertIconColor)
                    }

                    Text(alertMessage)
                        .font(.subheadline)
                        .foregroundStyle(level.color.opacity(0.85))
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(level.color.opacity(0.08))
            }
            .clipShape(RoundedRectangle(cornerRadius: 6))
        }
        .padding(.top, 2)
    }
    
    
    private var labelView: some View {
        HStack(alignment: .center) {
            Label {
                Text(title)
            } icon: {
                Image(systemName: icon)
                    .foregroundStyle(iconColor)
            }
            .font(.headline)

            Spacer()

            Image(systemName: level.trailingIcon)
                .foregroundStyle(level.color)
                .font(.title3)
        }
    }
}

// MARK: - Preview

#Preview {
    ScrollView {
        IntegrityScoreGroupView(
            icon: "eye.circle",
            iconColor: .red,
            title: "Integrity Score",
            subtitle: "This score is based on how consistently and naturally eye contact is maintained during the interaction.",
            alertMessage: "Inconsistent eye contact suggests compromised response integrity and reduced confidence. This may indicate distraction, lack of preparation, or potential reliance on external sources.",
            level: .poor
        )

        IntegrityScoreGroupView(
            icon: "waveform.path.ecg",
            iconColor: .orange,
            title: "Confidence Score",
            subtitle: "Measured by vocal steadiness and pacing throughout the session.",
            alertMessage: "Some hesitation detected. Consider practicing responses to improve fluency and delivery.",
            level: .belowAverage
        )

        IntegrityScoreGroupView(
            icon: "chart.bar.fill",
            iconColor: .blue,
            title: "Clarity Score",
            subtitle: "Evaluates how clearly and concisely ideas were communicated.",
            alertMessage: "Responses were generally on point with room for minor improvement.",
            level: .average
        )

        IntegrityScoreGroupView(
            icon: "hand.thumbsup.fill",
            iconColor: .cyan,
            title: "Engagement Score",
            subtitle: "Reflects attentiveness and active participation throughout the session.",
            alertMessage: "Strong engagement observed. Keep maintaining this level of participation.",
            level: .good
        )

        IntegrityScoreGroupView(
            icon: "star.circle",
            iconColor: .green,
            title: "Communication Score",
            subtitle: "Evaluates clarity, structure, and articulation of responses.",
            alertMessage: "Clear and well-structured responses throughout. Excellent articulation maintained.",
            level: .excellent
        )
    }
    .versionedContentMarginsPkg()
}
