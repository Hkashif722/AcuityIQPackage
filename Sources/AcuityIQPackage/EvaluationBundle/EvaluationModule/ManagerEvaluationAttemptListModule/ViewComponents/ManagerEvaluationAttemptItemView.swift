//
//  ManagerEvaluationAttemptItemView.swift
//  AcuityIQPackage
//

import SwiftUI

struct ManagerEvaluationAttemptItemView: View {

    let attempt: ManagerEvaluationListDataModel.ScenarioAttempt.Attempt
    let userName: String?
    let onTap: () -> Void
    let onEvaluate: () -> Void

    private var isEvaluated: Bool { attempt.evaluationSubmitted == true }

    var body: some View {
        cardContent
            .anyButton(.plain, action: onTap)
    }
}

// MARK: - Card Content
private extension ManagerEvaluationAttemptItemView {

    var cardContent: some View {
        VStack(alignment: .leading, spacing: 8) {
            attemptInfoRow
            if isEvaluated {
                evaluatedInfoRow
            } else {
                evaluateButton
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    var attemptInfoRow: some View {
        HStack(spacing: 12) {
            avatarView
            attemptInfoSection
            Spacer()
            aiScoreBadge
            chevron
        }
    }

    var attemptInfoSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(userName ?? "Unknown")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary)

            HStack(spacing: 8) {
                attemptNumberTag
                attemptDateText
            }
        }
    }

    var attemptNumberTag: some View {
        Text("Attempt #\(attempt.attemptNumber ?? 0)")
            .font(.caption)
            .foregroundStyle(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 2)
            .background(Color.blue.opacity(0.8))
            .clipShape(Capsule())
    }

    var attemptDateText: some View {
        Text(attempt.attemptDate ?? "")
            .font(.caption)
            .foregroundStyle(.secondary)
            .lineLimit(1)
    }

    var chevron: some View {
        Image(systemName: "chevron.right")
            .font(.caption)
            .foregroundStyle(.tertiary)
    }
}

// MARK: - Avatar
private extension ManagerEvaluationAttemptItemView {

    var avatarView: some View {
        Text(initials)
            .font(.system(size: 14, weight: .semibold))
            .foregroundStyle(.white)
            .frame(width: 40, height: 40)
            .background(avatarColor)
            .clipShape(Circle())
    }

    var initials: String {
        guard let name = userName else { return "?" }
        let parts = name.split(separator: " ")
        if parts.count >= 2 {
            return String(parts[0].prefix(1) + parts[1].prefix(1)).uppercased()
        }
        return String(name.prefix(2)).uppercased()
    }

    var avatarColor: Color {
        let colors: [Color] = [.blue, .purple, .orange, .green, .pink, .teal]
        return colors[abs((userName ?? "").hashValue) % colors.count]
    }
}

// MARK: - Score Badge
private extension ManagerEvaluationAttemptItemView {

    var aiScoreBadge: some View {
        Text(scoreFormatted(attempt.score))
            .font(.subheadline.weight(.bold))
            .foregroundStyle(scoreColor(for: attempt.score))
    }

    func scoreColor(for value: Double?) -> Color {
        guard let score = value else { return .gray }
        return score >= 8 ? Color(hex: "#10b981") : Color(hex: "#f59e0b")
    }
}

// MARK: - Evaluated Info Row
private extension ManagerEvaluationAttemptItemView {

    var evaluatedInfoRow: some View {
        HStack(spacing: 10) {
            managerScoreText
            evaluatedBadge
            Spacer()
        }
    }
    
    var evaluatedBadge: some View {
        HStack(spacing: 4) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 13))
            Text("Evaluated")
                .font(.subheadline.weight(.medium))
        }
        .foregroundStyle(Color(hex: "#10b981"))
    }

    var managerScoreText: some View {
        let color = scoreColor(for: attempt.overallScore)
        return HStack(spacing: 4) {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 14))
            Text(scoreFormatted(attempt.overallScore))
                .font(.subheadline.weight(.semibold))
        }
        .foregroundStyle(color)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(color.opacity(0.12))
        .clipShape(Capsule())
    }

    func scoreFormatted(_ value: Double?) -> String {
        guard let v = value else { return "-/10" }
        return String(format: "%.1f/10", v)
    }
}

// MARK: - Evaluate Button
private extension ManagerEvaluationAttemptItemView {

    var evaluateButton: some View {
        HStack {
            SwiftUIUtility
                .RectangularIconButton(
                    title: "Evaluate",
                    iconName: "play.circle.fill",
                    isSystemIcon: true,
                    backgroundColor: Color(hex: "#5b6afa"),
                    foregroundColor: .white,
                    height: 40,
                    action: onEvaluate
                )
                .frame(width: 130)
                .clipShape(Capsule())
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 10) {
            ManagerEvaluationAttemptItemView(
                attempt: .init(attemptId: 229, attemptNumber: 1, score: 8.8, attemptDate: "17 Apr 2026", attemptTime: "12:37 PM", evaluationSubmitted: true, overallScore: 8.2),
                userName: "Sahil Kumar",
                onTap: {},
                onEvaluate: {}
            )
            ManagerEvaluationAttemptItemView(
                attempt: .init(attemptId: 234, attemptNumber: 2, score: 5.5, attemptDate: "17 Apr 2026", attemptTime: "12:49 PM", evaluationSubmitted: false, overallScore: nil),
                userName: "Sahil Kumar",
                onTap: {},
                onEvaluate: {}
            )
        }
        .padding()
    }
}
