//
//  AttemptBadgeView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 06/04/26.
//

import SwiftUI
import SwiftfulRouting

struct AttemptBadgeView: View {

    let router: AnyRouter
    let attemptNumber: Int
    let totalAttempts: Int
    let attemptsUsed: Int

    var body: some View {
        VStack(spacing: 0) {
            headerView
            contentView
        }
    }
}

// MARK: - Subviews

extension AttemptBadgeView {

    private var headerView: some View {
        HStack(spacing: 12) {
            Image(systemName: "flame.fill")
                .foregroundStyle(.white)
                .padding(10)
                .background(Color(hex: "E24B4A"))
                .clipShape(RoundedRectangle(cornerRadius: 8))

            Text("Attempt\nDetails")
                .font(.headline)
                .foregroundStyle(.primary)
                .lineLimit(2)

            Spacer()

            SwiftUIUtility
                .CircleCloseButton(
                    size: 35,
                    action: router.dismissScreen
                )
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
    }

    private var contentView: some View {
        VStack(spacing: 16) {
            attemptStatRow(
                icon: "number",
                title: "Current Attempt",
                value: "\(attemptNumber)"
            )

            Divider()

            attemptStatRow(
                icon: "chart.bar.fill",
                title: "Total Attempts Allowed",
                value: "\(totalAttempts)"
            )

            Divider()

            attemptStatRow(
                icon: "checkmark.circle.fill",
                title: "Attempts Used",
                value: "\(attemptsUsed)"
            )

            Divider()

            attemptStatRow(
                icon: "clock.fill",
                title: "Remaining Attempts",
                value: "\(max(0, totalAttempts - attemptsUsed))",
                valueColor: remainingAttemptsColor
            )
        }
        .padding()
    }

    private var remainingAttemptsColor: Color {
        let remaining = totalAttempts - attemptsUsed
        if remaining <= 0 {
            return .red
        } else if remaining <= 2 {
            return .orange
        }
        return .green
    }

    private func attemptStatRow(
        icon: String,
        title: String,
        value: String,
        valueColor: Color = .primary
    ) -> some View {
        HStack {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .foregroundStyle(Color(hex: "E24B4A"))
                    .frame(width: 24)

                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(value)
                .font(.title3.bold())
                .foregroundStyle(valueColor)
        }
    }
}

#Preview {
    RouterView { router in
        AttemptBadgeView(
            router: router,
            attemptNumber: 4,
            totalAttempts: 10,
            attemptsUsed: 9
        )
    }
}
