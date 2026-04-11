//
//  NLBRankCardView.swift
//  AcuityIQPackage
//
//  Expandable rank card shown in the "DETAILED RANKINGS" list.
//  Layout: rank column | avatar + info | watch button
//

import SwiftUI
import SwiftUIUtilities

struct NLBRankCardView: View {

    @State private var isExpanded: Bool

    let rank: Int
    let attempt: LeaderboardDataModel.LeaderboardAttempt
    let onAttemptBadgeSelection: () -> Void
    let onHerculeanEffortSelection: () -> Void
    let onWatchRecordingPressed: () -> Void

    private var rankColor: Color {
        LeaderboardDataModel.LeaderboardAttempt.nlbRankColor(for: rank)
    }

    init(
        rank: Int,
        attempt: LeaderboardDataModel.LeaderboardAttempt,
        initiallyExpanded: Bool = false,
        onAttemptBadgeSelection: @escaping () -> Void,
        onHerculeanEffortSelection: @escaping () -> Void,
        onWatchRecordingPressed: @escaping () -> Void
    ) {
        self.rank = rank
        self.attempt = attempt
        self._isExpanded = State(initialValue: initiallyExpanded)
        self.onAttemptBadgeSelection = onAttemptBadgeSelection
        self.onHerculeanEffortSelection = onHerculeanEffortSelection
        self.onWatchRecordingPressed = onWatchRecordingPressed
    }

    var body: some View {
        VStack(spacing: 0) {

            // Top accent stripe
            rankColor
                .frame(maxWidth: .infinity)
                .frame(height: 3)
                .clipShape(
                    RoundedCorner(radius: 12, corners: [.topLeft, .topRight])
                )

            // Main content row
            mainRow
                .padding(.horizontal, 12)
                .padding(.vertical, 12)

            Divider()
                .padding(.horizontal, 12)

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

            // Expandable feedback
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

    // MARK: - Main Row

    private var mainRow: some View {
        HStack(alignment: .center, spacing: 12) {
            rankColumn
            avatarView
            infoColumn
            Spacer()
            watchButton
        }
    }

    // MARK: Rank Column (medal icon + "#N" label)

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

    // MARK: Avatar Circle

    private var avatarView: some View {
        ZStack {
            Circle()
                .fill(rankColor.opacity(0.15))
                .frame(width: 52, height: 52)
                .overlay {
                    Circle().stroke(rankColor, lineWidth: 2)
                }

            // Profile picture or initials fallback
            if let urlString = attempt.profilePicture, !urlString.isEmpty {
                AsyncImageWithFallback(
                    urlString:attempt.profileFullPathURL?.absoluteString,
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

    // MARK: Info Column (name + score bar + badges)

    private var infoColumn: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(attempt.userName ?? "Unknown")
                .font(.subheadline.bold())
                .foregroundStyle(.primary)
                .lineLimit(1)

            scoreBarRow

            badgeRow
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

    private var badgeRow: some View {
        let badges = attempt.nlbBadgeItems
        return HStack(spacing: 4) {
            ForEach(badges.indices, id: \.self) { i in
                Image(systemName: badges[i].icon)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(badges[i].color)
                    .frame(width: 22, height: 22)
                    .background(badges[i].color.opacity(0.12))
                    .clipShape(Circle())
                    .onTapGesture {
                        if badges[i].icon == "flame.fill" || badges[i].icon == "doc.fill" {
                            onAttemptBadgeSelection()
                        } else if badges[i].icon == "heart.fill" {
                            onHerculeanEffortSelection()
                        }
                    }
            }

            Text("\(badges.count) badge\(badges.count == 1 ? "" : "s")")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: Watch Button

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
        .overlay {
            Capsule()
                .stroke(Color(.separator), lineWidth: 1.5)
        }
        .anyButton(.press, action: onWatchRecordingPressed)
    }
}

// MARK: - Preview
#if Debug
#Preview {
    ScrollView {
        LazyVStack(spacing: 12) {
            ForEach(Array(LeaderboardDataModel.LeaderboardAttempt.previewArray.enumerated()), id: \.element.id) { index, attempt in
                NLBRankCardView(
                    rank: index + 1,
                    attempt: attempt,
                    initiallyExpanded: index == 2,
                    onAttemptBadgeSelection: {},
                    onHerculeanEffortSelection: {},
                    onWatchRecordingPressed: {}
                )
            }
        }
        .padding()
    }
}
#endif
