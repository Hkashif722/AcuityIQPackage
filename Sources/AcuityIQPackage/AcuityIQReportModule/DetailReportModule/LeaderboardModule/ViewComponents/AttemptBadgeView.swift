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

    private var statItems: [LeaderboardDataModel.AttemptStatItem] {
        LeaderboardDataModel.AttemptStatItem.statItems(
            attemptNumber: attemptNumber,
            totalAttempts: totalAttempts,
            attemptsUsed: attemptsUsed
        )
    }

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
        List(statItems) { item in
            attemptStatRow(item: item)
                .listRowSeparator(Visibility.visible)
                .listRowInsets(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
        }
        .listStyle(.plain)
        .applyScrollBounceBehaviorPkg()
    }

    private func attemptStatRow(item: LeaderboardDataModel.AttemptStatItem) -> some View {
        HStack {
            HStack(spacing: 12) {
                Image(systemName: item.icon)
                    .foregroundStyle(Color(hex: "E24B4A"))
                    .frame(width: 24)

                Text(item.title)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(item.value)
                .font(.title3.bold())
                .foregroundStyle(item.valueColor)
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
