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
            scoreRingView
            statsView
            Spacer()
        }
        .padding(20)
        .background(Color(red: 0.97, green: 0.94, blue: 0.99))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Score Ring

    private var scoreRingView: some View {
        ZStack {
            Circle()
                .stroke(Color(red: 0.91, green: 0.88, blue: 0.95), lineWidth: 6)
                .frame(width: 80, height: 80)

            Circle()
                .trim(from: 0, to: evaluation.totalScore / 10.0)
                .stroke(
                    evaluation.scoreLabel.ringColor,
                    style: StrokeStyle(lineWidth: 6, lineCap: .round)
                )
                .frame(width: 80, height: 80)
                .rotationEffect(.degrees(-90))

            HStack(alignment: .bottom, spacing: 1) {
                Text("\(Int(evaluation.totalScore.rounded()))")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.primary)
                Text("/10")
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
                    .padding(.bottom, 3)
            }
        }
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
                    .foregroundColor(Color(red: 0.07, green: 0.62, blue: 0.46))
                Text("Scored")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }

            scoreBadgeView
        }
    }

    private var scoreBadgeView: some View {
        Text(evaluation.scoreLabel.rawValue)
            .font(.system(size: 13, weight: .medium))
            .foregroundColor(evaluation.scoreLabel.foregroundColor)
            .padding(.horizontal, 12)
            .padding(.vertical, 5)
            .background(evaluation.scoreLabel.backgroundColor)
            .clipShape(Capsule())
    }
}

#Preview {
    ManagerEvaluationScoreCardView(
        evaluation: AcuityIQReportDataModel.Scenario.ManagerEvaluation(
            id: 1,
            date: "2026-04-13",
            time: "10:00 AM",
            parameters: [
                .init(parameter: "Clarity", score: 1, remarks: "Ggfgj"),
                .init(parameter: "Content Relevance", score: 2, remarks: "Gufdf hdgjjg")
            ]
        )
    )
    .padding()
}
