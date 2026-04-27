//
//  ManagerEvaluationScoreCardView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 13/04/26.
//


//
//  ManagerEvaluationScoreCardView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 13/04/26.
//

import SwiftUI

struct ManagerEvaluationScoreCardView: View {

    let evaluation: AcuityIQReportDataModel.Scenario.ManagerEvaluation

    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            overAllScoreContentView
            statsView
            Spacer()
        }
        .padding(20)
        .background(Color(hex: "#f7f4ff"))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    
    private var overAllScoreContentView: some View {
        VStack(spacing: 16) {
            scoreRingView
            overallScore
        }
    }
    
    // MARK: - Score Ring

    private var scoreRingView: some View {
        ZStack {
            Circle()
                .stroke(
                    evaluation.overAllScoreLabel.borderColor.opacity(0.2),
                    lineWidth: 6
                )
                .frame(width: 80, height: 80)

            Circle()
                .trim(from: 0, to: (evaluation.overallScore ?? 0) / 10.0)
                .stroke(
                    evaluation.overAllScoreLabel.ringColor,
                    style: StrokeStyle(lineWidth: 6, lineCap: .round)
                )
                .frame(width: 80, height: 80)
                .rotationEffect(.degrees(-90))

            HStack(alignment: .bottom, spacing: 1) {
                Text(String(format: "%.1f", evaluation.overallScore ?? 0))                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.primary)
                Text("/10")
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
                    .padding(.bottom, 3)
            }
        }
    }
    
    private var overallScore: some View {
        Text("Overall Score")
            .font(.system(size: 16, weight: .semibold))
            .foregroundStyle(.secondary)
    }

    // MARK: - Stats

    private var statsView: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text("\(evaluation.parameterCount)")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.primary)
                Text("Parameters")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }

            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text("\(evaluation.scoredCount)")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(evaluation.scoreLabel.foregroundColor)
                Text("Scored")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }

            scoreBadgeView
        }
    }

    private var scoreBadgeView: some View {
        Text(evaluation.overAllScoreLabel.rawValue)
            .font(.system(size: 13, weight: .medium))
            .foregroundColor(evaluation.overAllScoreLabel.foregroundColor)
            .padding(.horizontal, 12)
            .padding(.vertical, 5)
            .background(evaluation.overAllScoreLabel.backgroundColor)
            .clipShape(Capsule())
    }
}

#Preview {
    ManagerEvaluationScoreCardView(
        evaluation: AcuityIQReportDataModel.Scenario.ManagerEvaluation(
            id: 1,
            date: "2026-04-13",
            time: "10:00 AM",
            overallScore: 7.5,
            parameters: [
                .init(parameter: "Clarity", score: 1, remarks: "Ggfgj", totalWeightage: "20"),
                .init(parameter: "Content Relevance", score: 2, remarks: "Gufdf hdgjjg", totalWeightage: "20")
            ]
        )
    )
    .padding()
}
