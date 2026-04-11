//
//  NLBView.swift
//  AcuityIQPackage
//
//  New Leaderboard main view.
//  Drop-in replacement for LeaderboardView — same ViewModel, same routing.
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

                // ── Podium ───────────────────────────────────────────────
                if vm.leaderboardResponseModel.count >= 1 {
                    NLBPodiumView(
                        attempts: Array(vm.leaderboardResponseModel.prefix(3))
                    )
                    .padding(.bottom, 28)
                }

                // ── Section header ───────────────────────────────────────
                sectionHeader("DETAILED RANKINGS")
                    .padding(.horizontal)
                    .padding(.bottom, 10)

                // ── Rank cards ───────────────────────────────────────────
                LazyVStack(spacing: 10) {
                    ForEach(
                        Array(vm.leaderboardResponseModel.enumerated()),
                        id: \.element.id
                    ) { index, attempt in
                        NLBRankCardView(
                            rank: index + 1,
                            attempt: attempt,
                            initiallyExpanded: false,
                            onAttemptBadgeSelection: {
                                vm.onAttemptBadgeSelection(attempt)
                            },
                            onHerculeanEffortSelection: {
                                vm.onHerculeanEffortSelection(attempt)
                            },
                            onWatchRecordingPressed: {
                                vm.onWatchRecordingPressed(attempt)
                            }
                        )
                    }
                }
            }
        }
        .background(Color(.systemGroupedBackground))
        .versionedContentMarginsPkg()
    }

    // MARK: Helpers

    private func sectionHeader(_ title: String) -> some View {
        HStack {
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
}

// MARK: - Preview

#if Debug
#Preview {
    RouterView { router in
        NLBView(
            router: router,
            leaderboardResponse: LeaderboardDataModel.LeaderboardAttempt.previewArray
        )
    }
}
#endif
