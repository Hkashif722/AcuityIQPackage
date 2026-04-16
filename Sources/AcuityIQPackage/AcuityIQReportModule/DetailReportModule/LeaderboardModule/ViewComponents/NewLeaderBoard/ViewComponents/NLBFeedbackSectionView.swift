//
//  NLBFeedbackSectionView.swift
//  AcuityIQPackage
//
//  Collapsible "Star Quality Analysis" footer inside each rank card.
//  Uses the existing brown-bullet design for OPEN / MIDDLE / CLOSE entries.
//

import SwiftUI

// MARK: - Star + Toggle Row

struct NLBStarAnalysisToggleRow: View {

    let starRating: Int   // 0–5
    let isExpanded: Bool
    let onToggle:   () -> Void

    var body: some View {
        HStack(spacing: 8) {
            starRow
            Text("Star Qualities")
                .font(.subheadline.bold())
                .foregroundStyle(.primary)
            Spacer()
            Image(systemName: "triangle.fill")
                .font(.caption2)
                .rotationEffect(isExpanded ? .degrees(180) : .degrees(0))
                .foregroundStyle(.secondary)
                .animation(.easeInOut(duration: 0.25), value: isExpanded)
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .contentShape(Rectangle())
        .onTapGesture(perform: onToggle)
    }

    private var starRow: some View {
        HStack(spacing: 2) {
            ForEach(1...5, id: \.self) { index in
                Image(systemName: index <= starRating ? "star.fill" : "star")
                    .font(.caption)
                    .foregroundStyle(
                        index <= starRating ? Color(hex: "F5C518") : Color(.systemGray4)
                    )
            }
        }
    }
}

// MARK: - Expanded Feedback List

struct NLBFeedbackSectionView: View {

    let attempt: LeaderboardDataModel.LeaderboardAttempt

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            let items = attempt.nlbFeedbackItems
            if items.isEmpty {
                emptyFeedback
            } else {
                ForEach(items, id: \.label) { item in
                    feedbackRow(label: item.label, text: item.text)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
        .padding(.bottom, 16)
    }

    // MARK: Empty State

    private var emptyFeedback: some View {
        HStack(spacing: 8) {
            Image(systemName: "text.bubble")
                .foregroundStyle(Color(.systemGray3))
            Text("No feedback available yet.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 6)
    }

    // MARK: Row — bullet circle + label badge + feedback text

    private func feedbackRow(label: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            bulletIcon
            VStack(alignment: .leading, spacing: 3) {
                Text(label)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(.secondary)
                Text(text)
                    .font(.footnote)
                    .foregroundStyle(Color(.darkGray))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    /// Brown bullet from the original LeaderboardStarQuatilyFeedbackView.
    private var bulletIcon: some View {
        Circle()
            .fill(.brown.opacity(0.3))
            .frame(width: 22, height: 22)
            .overlay(Circle().fill(.brown).frame(width: 6, height: 6))
            .padding(.top, 2)
    }
}

// MARK: - Preview

#if DEBUG
#Preview {
    NLBFeedbackSectionView(
        attempt: LeaderboardDataModel.LeaderboardAttempt.previewArray[0]
    )
    .padding()
}
#endif
