//
//  AcuityAttemptItemView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 05/04/26.
//

import SwiftUI

struct AcuityAttemptItemView: View {

    let attempt: AcuityIQReportDataModel.Scenario.Attempt
    var onManagerEvaluationTap: (AcuityIQReportDataModel.Scenario.Attempt) -> Void
    var onTap: (AcuityIQReportDataModel.Scenario.Attempt) -> Void

    var body: some View {
        cardContent
            .anyButton(.plain, action: { onTap(attempt)})
    }
}

// MARK: - Card Content
private extension AcuityAttemptItemView {
    
    var cardContent: some View {
        HStack(spacing: 12) {
            userAvatarView
            userInfoSection
            scoreBadge
            managerEvalautionView
            chevronIndicator
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    var userInfoSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            headerRow
            detailsRow
        }
    }
    
    var headerRow: some View {
        Text(attempt.userName ?? "Unknown")
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundStyle(.primary)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var detailsRow: some View {
        HStack(spacing: 8) {
            attemptNumberTag
            attemptDateText
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
    
    @ViewBuilder
    var managerEvalautionView: some View {
        if let managerEvaluation = attempt.managerEvaluation {
            Image(systemName: "person.crop.circle.fill")
                .foregroundStyle(managerEvaluation.scoreLabel.foregroundColor, managerEvaluation.scoreLabel.backgroundColor)
                .font(.system(size: 36))
                .overlay(
                    Circle()
                        .stroke(managerEvaluation.scoreLabel.ringColor, lineWidth: 2)
                )
                .anyButton(.plain, action: { onManagerEvaluationTap(attempt) })
        }
    }
    
    var chevronIndicator: some View {
        Image(systemName: "chevron.right")
            .font(.caption)
            .foregroundStyle(.tertiary)
    }
}

// MARK: - User Avatar
private extension AcuityAttemptItemView {
    
    var userAvatarView: some View {
        Text(userInitials)
            .font(.system(size: 14, weight: .semibold))
            .foregroundStyle(.white)
            .frame(width: 40, height: 40)
            .background(avatarColor)
            .clipShape(Circle())
    }

    var userInitials: String {
        guard let name = attempt.userName else { return "?" }
        let components = name.split(separator: " ")
        if components.count >= 2 {
            return String(components[0].prefix(1) + components[1].prefix(1)).uppercased()
        }
        return String(name.prefix(2)).uppercased()
    }

    var avatarColor: Color {
        let colors: [Color] = [.blue, .purple, .orange, .green, .pink, .teal]
        let index = abs((attempt.userName ?? "").hashValue) % colors.count
        return colors[index]
    }
}

// MARK: - Score Badge
private extension AcuityAttemptItemView {
    
    var scoreBadge: some View {
        Text(scoreText)
            .font(.subheadline)
            .fontWeight(.bold)
            .foregroundStyle(scoreColor)
    }

    var scoreText: String {
        guard let score = attempt.score else { return "-/10" }
        return String(format: "%.1f/10", score)
    }

    var scoreColor: Color {
        guard let score = attempt.score else { return .gray }
        switch score {
        case 8...:  return Color(hex: "#10b981")  // good  → score >= 8
        default:    return Color(hex: "#f59e0b")  // avg   → score < 8
        }
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 10) {
            AcuityAttemptItemView(
                attempt: AcuityIQReportDataModel.Scenario.Attempt(
                    attemptId: 565,
                    attemptNumber: 9,
                    userId: 9868,
                    userName: "LMS Admin",
                    score: 1.5,
                    attemptDate: "Friday, April 3, 2026 3:22 PM", managerEvaluation: nil
                ),
                onManagerEvaluationTap: { _ in },
                onTap: { _ in }
            )

            AcuityAttemptItemView(
                attempt: AcuityIQReportDataModel.Scenario.Attempt(
                    attemptId: 564,
                    attemptNumber: 8,
                    userId: 9868,
                    userName: "John Smith",
                    score: 7.3,
                    attemptDate: "Friday, April 3, 2026 2:55 PM", managerEvaluation: nil
                ),
                onManagerEvaluationTap: { _ in },
                onTap: { _ in }
            )

            AcuityAttemptItemView(
                attempt: AcuityIQReportDataModel.Scenario.Attempt(
                    attemptId: 563,
                    attemptNumber: 7,
                    userId: 9868,
                    userName: "Sarah Connor",
                    score: 4.5,
                    attemptDate: "Friday, April 3, 2026 2:15 PM", managerEvaluation: nil
                ),
                onManagerEvaluationTap: { _ in },
                onTap: { _ in }
            )
        }
        .padding()
    }
}
