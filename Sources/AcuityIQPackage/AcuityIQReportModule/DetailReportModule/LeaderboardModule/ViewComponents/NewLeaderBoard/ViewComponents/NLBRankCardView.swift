//
//  NLBRankCardView.swift
//  AcuityIQPackage
//
//  Expandable rank card in the "DETAILED RANKINGS" list.
//  Layout: rank column | avatar | info (name / score bar / badge strip) | watch button
//
//  Badge strip shows all 10 LeaderboardDataModel.NLBBadge entries:
//    • Coloured when earned
//    • Grey + lock pip when not earned
//  Tapping any badge fires onBadgeTapped — parent owns the sheet.
//

import SwiftUI
import SwiftUIUtilities

struct NLBRankCardView: View {

    @State private var isExpanded: Bool

    let rank:                    Int
    let attempt:                 LeaderboardDataModel.LeaderboardAttempt
    let onWatchRecordingPressed: () -> Void
    let onBadgeTapped:           (LeaderboardDataModel.NLBBadge) -> Void

    private var rankColor: Color {
        LeaderboardDataModel.LeaderboardAttempt.nlbRankColor(for: rank)
    }

    init(
        rank:                    Int,
        attempt:                 LeaderboardDataModel.LeaderboardAttempt,
        initiallyExpanded:       Bool = false,
        onWatchRecordingPressed: @escaping () -> Void,
        onBadgeTapped:           @escaping (LeaderboardDataModel.NLBBadge) -> Void
    ) {
        self.rank                    = rank
        self.attempt                 = attempt
        self._isExpanded             = State(initialValue: initiallyExpanded)
        self.onWatchRecordingPressed = onWatchRecordingPressed
        self.onBadgeTapped           = onBadgeTapped
    }

    // ─────────────────────────────────────────────────────────────────
    // MARK: Body
    // ─────────────────────────────────────────────────────────────────

    var body: some View {
        VStack(spacing: 0) {

            // Coloured top accent stripe
            rankColor
                .frame(maxWidth: .infinity, minHeight: 3, maxHeight: 3)
                .clipShape(RoundedCorner(radius: 12, corners: [.topLeft, .topRight]))

            // Main content row
            mainRow
                .padding(.horizontal, 12)
                .padding(.vertical, 12)

            Divider().padding(.horizontal, 12)

            // Star Quality toggle row
            NLBStarAnalysisToggleRow(
                starRating: attempt.nlbStarRating,
                isExpanded: isExpanded,
                onToggle: {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        isExpanded.toggle()
                    }
                }
            )

            // Expandable feedback section
            if isExpanded {
                NLBFeedbackSectionView(attempt: attempt)
                    .transition(
                        .asymmetric(
                            insertion: .opacity
                                .combined(with: .move(edge: .top))
                                .combined(with: .scale(scale: 0.97, anchor: .top)),
                            removal: .opacity
                                .combined(with: .scale(scale: 0.97, anchor: .top))
                        )
                    )
            }
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.separator).opacity(0.5), lineWidth: 1)
        }
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }

    // ─────────────────────────────────────────────────────────────────
    // MARK: Main Row
    // ─────────────────────────────────────────────────────────────────

    private var mainRow: some View {
        HStack(alignment: .center, spacing: 12) {
            rankColumn
            avatarView
            infoColumn
            Spacer(minLength: 8)
            watchButton
        }
    }

    // ── Rank column (medal icon + "#N" label) ─────────────────────────

    private var rankColumn: some View {
        VStack(spacing: 4) {
            Image(systemName: LeaderboardDataModel.LeaderboardAttempt.nlbRankIcon(for: rank))
                .font(.subheadline)
                .foregroundStyle(
                    rank == 1
                        ? Color(hex: "F5C518")
                        : LeaderboardDataModel.LeaderboardAttempt.nlbMedalColor(for: rank)
                )
            Text("#\(rank)")
                .font(.subheadline.bold())
                .foregroundStyle(rankColor)
        }
        .frame(width: 32)
    }

    // ── Avatar circle ─────────────────────────────────────────────────

    private var avatarView: some View {
        ZStack {
            Circle()
                .fill(rankColor.opacity(0.15))
                .frame(width: 52, height: 52)
                .overlay { Circle().stroke(rankColor, lineWidth: 2) }

            if let url = attempt.profileFullPathURL?.absoluteString, !url.isEmpty {
                AsyncImageWithFallback(
                    urlString: url,
                    defaultImageName: "user",
                    contentMode: .fill,
                    bundle: .module
                )
                .aspectRatio(1, contentMode: .fill)
                .frame(width: 52, height: 52)
                .clipShape(Circle())
            } else {
                Text(attempt.nlbInitials)
                    .font(.headline.bold())
                    .foregroundStyle(rankColor)
            }
        }
    }

    // ── Info column (name + score bar + badge strip) ──────────────────

    private var infoColumn: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(attempt.userName ?? "Unknown")
                .font(.subheadline.bold())
                .foregroundStyle(.primary)
                .lineLimit(1)

            scoreBarRow
            badgeStrip
        }
    }

    private var scoreBarRow: some View {
        HStack(spacing: 6) {
            Text("Score")
                .font(.caption)
                .foregroundStyle(.secondary)

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color(.systemGray5))
                        .frame(height: 5)
                    Capsule()
                        .fill(rankColor)
                        .frame(width: geo.size.width * attempt.nlbScoreProgress, height: 5)
                }
            }
            .frame(height: 5)

            Text(String(format: "%.1f", attempt.overallScore ?? 0))
                .font(.caption.bold())
                .foregroundStyle(rankColor)
        }
    }

    // ─────────────────────────────────────────────────────────────────
    // MARK: Badge Strip
    //
    // All 10 LeaderboardDataModel.NLBBadge entries in a scrollable row.
    //   • Earned   → vibrant accent fill
    //   • Unearned → grey fill + tiny lock pip at bottom-trailing
    // Tapping any badge fires onBadgeTapped — parent owns the sheet.
    // ─────────────────────────────────────────────────────────────────

    private var badgeStrip: some View {
        let badges      = attempt.nlbBadges          // always exactly 10
        let earnedCount = badges.filter { $0.isEarned }.count
        let topRow      = Array(badges.prefix(5))    // indices 0–4
        let bottomRow   = Array(badges.suffix(5))    // indices 5–9
        
        return VStack(alignment: .leading, spacing: 4) {
            
            // Row 1 — Record Breaker, All Star, Storyteller, Product Wizard, Hustler
            HStack(spacing: 5) {
                ForEach(topRow) { badge in
                    badgeButton(badge)
                }
            }
            
            // Row 2 — Super Speaker, Honourable One, Clean Slate, Herculean, Mr.Consistent
            HStack(spacing: 5) {
                ForEach(bottomRow) { badge in
                    badgeButton(badge)
                }
            }
            
            // Summary label
            Text("\(earnedCount) of \(badges.count) badges earned")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }
    
    private func badgeButton(_ badge: LeaderboardDataModel.NLBBadge) -> some View {
        Button { onBadgeTapped(badge) } label: {
            ZStack {
                Circle()
                    .fill(badge.displayColor.opacity(badge.isEarned ? 0.15 : 0.15))
                    .frame(width: 26, height: 26)

                badge.icon.imageView(size: 12)
                    .foregroundStyle(badge.displayColor)
            }
            
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(badge.name), \(badge.isEarned ? "earned" : "not yet earned"). Tap for details.")
    }

    // ─────────────────────────────────────────────────────────────────
    // MARK: Watch Button
    // ─────────────────────────────────────────────────────────────────

    private var watchButton: some View {
        HStack(spacing: 4) {
            Image(systemName: "play.fill")
                .font(.caption.bold())
            Text("Watch")
                .font(.caption.bold())
        }
        .foregroundStyle(.primary)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
        .clipShape(Capsule())
        .overlay { Capsule().stroke(Color(.separator), lineWidth: 1.5) }
        .anyButton(.press, action: onWatchRecordingPressed)
    }
}

// MARK: - Preview


#if DEBUG
@available(iOS 17.0, *)
#Preview {
    // Preview owns the sheet state — mirrors real parent usage
    @Previewable @State var selectedBadge: LeaderboardDataModel.NLBBadge?

    ScrollView {
        LazyVStack(spacing: 12) {
            ForEach(
                Array(LeaderboardDataModel.LeaderboardAttempt.previewArray.enumerated()),
                id: \.element.id
            ) { idx, attempt in
                NLBRankCardView(
                    rank:                    idx + 1,
                    attempt:                 attempt,
                    initiallyExpanded:       idx == 0,
                    onWatchRecordingPressed: { },
                    onBadgeTapped:           { badge in selectedBadge = badge }
                )
            }
        }
        .padding()
    }
    .background(Color(.systemGroupedBackground))
    .sheet(item: $selectedBadge) { badge in
        NLBBadgeDetailView(badge: badge)
    }
}
#endif
