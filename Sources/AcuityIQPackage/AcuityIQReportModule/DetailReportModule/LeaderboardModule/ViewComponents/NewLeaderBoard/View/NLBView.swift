//
//  NLBView.swift
//  AcuityIQPackage
//
//  New Leaderboard main view.
//  Drop-in replacement for LeaderboardView — same ViewModel, same routing.
//
//  Changes from v1:
//    • NLBPodiumView always renders (even 0 participants) — placeholders fill gaps.
//    • NLBRankCardView no longer receives badge-selection callbacks;
//      badge detail is handled internally via sheet.
//    • Empty leaderboard state shown when no data is present.
//

import SwiftUI
import SwiftUIUtilities
import SwiftfulRouting

struct NLBView: View {

    @StateObject private var vm: LeaderboardViewModel

    init(router: AnyRouter, leaderboardResponse: [LeaderboardDataModel.LeaderboardAttempt]) {
        _vm = StateObject(
            wrappedValue: LeaderboardViewModel(
                router: router,
                leaderboardResponse: leaderboardResponse
            )
        )
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0, pinnedViews: []) {

                // ── Podium ─────────────────────────────────────────────
                // Always rendered. NLBPodiumView fills missing ranks with
                // "Open Spot" placeholder columns.
                NLBPodiumView(
                    attempts: Array(vm.leaderboardResponseModel.prefix(3))
                )
                .padding(.bottom, 28)

                if vm.leaderboardResponseModel.isEmpty {

                    // ── Empty State ────────────────────────────────────
                    emptyState
                        .padding(.top, 40)

                } else {

                    // ── Section Header ─────────────────────────────────
                    sectionHeader("DETAILED RANKINGS")
                        .padding(.horizontal)
                        .padding(.bottom, 10)

                    // ── Rank Cards ─────────────────────────────────────
                    LazyVStack(spacing: 10) {
                        ForEach(
                            Array(vm.leaderboardResponseModel.enumerated()),
                            id: \.element.id
                        ) { index, attempt in
                            NLBRankCardView(
                                rank:    index + 1,
                                attempt: attempt,
                                initiallyExpanded: false,
                                onWatchRecordingPressed: {
                                    vm.onWatchRecordingPressed(attempt)
                                },
                                onBadgeTapped: vm.onBadgeSelect(_:)
                            )
                        }
                    }
                }
            }
        }
        .background(Color(.systemGroupedBackground))
        .versionedContentMarginsPkg()
    }

    // ─────────────────────────────────────────────────────────────────
    // MARK: Helpers
    // ─────────────────────────────────────────────────────────────────

    private func sectionHeader(_ title: String) -> some View {
        HStack(spacing: 8) {
            Rectangle()
                .fill(Color(hex: "F5C518"))
                .frame(width: 3, height: 14)
                .clipShape(Capsule())
            Text(title)
                .font(.caption.bold())
                .foregroundStyle(.secondary)
            Spacer()
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "trophy.fill")
                .font(.system(size: 48))
                .foregroundStyle(Color(.systemGray4))

            Text("No Rankings Yet")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text("Leaderboard data will appear here once participants complete the scenario.")
                .font(.footnote)
                .foregroundStyle(Color(.systemGray3))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }
}

// MARK: - Preview

#if DEBUG
#Preview("Full leaderboard") {
    RouterView { router in
        NLBView(
            router: router,
            leaderboardResponse: LeaderboardDataModel.LeaderboardAttempt.previewArray
        )
    }
}

#Preview("Single participant — 2 placeholders on podium") {
    RouterView { router in
        NLBView(
            router: router,
            leaderboardResponse: [LeaderboardDataModel.LeaderboardAttempt.previewArray[0]]
        )
    }
}

#Preview("Empty leaderboard") {
    RouterView { router in
        NLBView(router: router, leaderboardResponse: [])
    }
}
#endif
