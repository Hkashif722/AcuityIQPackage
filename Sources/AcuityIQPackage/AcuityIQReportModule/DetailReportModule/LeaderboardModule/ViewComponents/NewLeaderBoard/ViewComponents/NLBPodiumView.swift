//
//  NLBPodiumView.swift
//  AcuityIQPackage
//
//  Top podium section — always renders exactly 3 columns:
//    Visual order (left → right): #2 | #1 | #3
//
//  When 2nd or 3rd-place data is absent, an "Open Spot" placeholder
//  fills that column so the podium shape is never broken.
//

import SwiftUI
import SwiftUIUtilities

// MARK: - Podium Slot

/// Discriminates between a real participant and an empty placeholder.
private enum PodiumSlot {
    case filled(rank: Int, attempt: LeaderboardDataModel.LeaderboardAttempt)
    case empty(rank: Int)
}

// MARK: - Podium Container

struct NLBPodiumView: View {

    let attempts: [LeaderboardDataModel.LeaderboardAttempt]

    /// Always produces exactly 3 slots in visual order: [#2, #1, #3].
    private var slots: [PodiumSlot] {
        let first  = attempts.count >= 1
            ? PodiumSlot.filled(rank: 1, attempt: attempts[0])
            : PodiumSlot.empty(rank: 1)
        let second = attempts.count >= 2
            ? PodiumSlot.filled(rank: 2, attempt: attempts[1])
            : PodiumSlot.empty(rank: 2)
        let third  = attempts.count >= 3
            ? PodiumSlot.filled(rank: 3, attempt: attempts[2])
            : PodiumSlot.empty(rank: 3)
        return [second, first, third]  // visual order
    }

    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            ForEach(0..<slots.count, id: \.self) { i in
                switch slots[i] {
                case .filled(let rank, let attempt):
                    NLBPodiumFilledColumn(rank: rank, attempt: attempt)
                case .empty(let rank):
                    NLBPodiumEmptyColumn(rank: rank)
                }
            }
        }
        .padding(.horizontal, 8)
        .padding(.top, 16)
    }
}

// MARK: - Filled Column

private struct NLBPodiumFilledColumn: View {

    let rank:    Int
    let attempt: LeaderboardDataModel.LeaderboardAttempt

    private var rankColor:  Color   { LeaderboardDataModel.LeaderboardAttempt.nlbRankColor(for: rank) }
    private var avatarSize: CGFloat { rank == 1 ? 72 : 58 }
    private var barHeight:  CGFloat { rank == 1 ? 72 : rank == 2 ? 52 : 42 }
    private var nameFont:   Font    { rank == 1 ? .subheadline.bold() : .caption.bold() }

    var body: some View {
        VStack(spacing: 6) {

            // Crown (rank 1 only) — spacer keeps rows aligned for ranks 2 & 3
            if rank == 1 {
                Image(systemName: "crown.fill")
                    .foregroundStyle(Color(hex: "F5C518"))
                    .font(.title3)
            } else {
                Color.clear.frame(height: 22)
            }

            // Avatar with rank badge bubble
            ZStack(alignment: .bottomTrailing) {
                avatarCircle
                rankBubble
            }

            // Name
            Text(attempt.userName ?? "Unknown")
                .font(nameFont)
                .foregroundStyle(.primary)
                .lineLimit(1)
                .padding(.horizontal, 4)

            // Score
            Text(String(format: "%.1f XP", attempt.overallScore ?? 0))
                .font(nameFont)
                .foregroundStyle(rankColor)

            // Podium bar
            podiumBar
        }
        .frame(maxWidth: .infinity)
    }

    // ── Sub-views ─────────────────────────────────────────────────────

    @ViewBuilder
    private var avatarCircle: some View {
        Group {
            if let url = attempt.profileFullPathURL?.absoluteString, !url.isEmpty {
                AsyncImageWithFallback(
                    urlString: url,
                    defaultImageName: "user",
                    contentMode: .fill,
                    bundle: .module
                )
                .aspectRatio(1, contentMode: .fill)
            } else {
                ZStack {
                    Circle().fill(rankColor.opacity(0.18))
                    Text(attempt.nlbInitials)
                        .font(rank == 1 ? .headline.bold() : .subheadline.bold())
                        .foregroundStyle(rankColor)
                }
            }
        }
        .frame(width: avatarSize, height: avatarSize)
        .clipShape(Circle())
        .overlay { Circle().stroke(rankColor, lineWidth: 2) }
    }

    private var rankBubble: some View {
        Text("\(rank)")
            .font(.system(size: 10, weight: .black))
            .foregroundStyle(.white)
            .frame(width: 20, height: 20)
            .background(rankColor.opacity(0.9))
            .clipShape(Circle())
            .overlay { Circle().stroke(.white, lineWidth: 1.5) }
            .offset(x: 4, y: 4)
    }

    private var podiumBar: some View {
        Rectangle()
            .fill(rankColor)
            .frame(maxWidth: .infinity)
            .frame(height: barHeight)
            .cornerRadiusPkg(
                12,
                corners: rank == 1
                    ? [.topLeft, .topRight]
                    : rank == 2 ? [.topLeft] : [.topRight]
            )
    }
}

// MARK: - Empty / Placeholder Column

private struct NLBPodiumEmptyColumn: View {

    let rank: Int

    private var rankColor:  Color   { LeaderboardDataModel.LeaderboardAttempt.nlbRankColor(for: rank) }
    private var avatarSize: CGFloat { rank == 1 ? 72 : 58 }
    private var barHeight:  CGFloat { rank == 1 ? 72 : rank == 2 ? 52 : 42 }
    private var nameFont:   Font    { rank == 1 ? .subheadline.bold() : .caption.bold() }

    var body: some View {
        VStack(spacing: 6) {

            // Alignment spacer row (crown row height)
            Color.clear.frame(height: 22)

            // Dashed placeholder avatar
            ZStack {
                Circle()
                    .strokeBorder(
                        style: StrokeStyle(lineWidth: 2, dash: [5, 3])
                    )
                    .foregroundStyle(Color(.systemGray4))
                    .frame(width: avatarSize, height: avatarSize)

                VStack(spacing: 3) {
                    Image(systemName: "person.fill.questionmark")
                        .font(.system(size: rank == 1 ? 22 : 17))
                        .foregroundStyle(Color(.systemGray3))

                    Text("#\(rank)")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundStyle(Color(.systemGray4))
                }
            }

            // "Open Spot" label
            Text("Open Spot")
                .font(nameFont)
                .foregroundStyle(Color(.systemGray3))
                .lineLimit(1)
                .padding(.horizontal, 4)

            // Dash instead of a score
            Text("—")
                .font(nameFont)
                .foregroundStyle(Color(.systemGray4))

            // Greyed podium bar with rank watermark
            podiumBar
        }
        .frame(maxWidth: .infinity)
    }

    private var podiumBar: some View {
        ZStack {
            Rectangle()
                .fill(Color(.systemGray5))
                .frame(maxWidth: .infinity)
                .frame(height: barHeight)
                .cornerRadiusPkg(
                    12,
                    corners: rank == 1
                        ? [.topLeft, .topRight]
                        : rank == 2 ? [.topLeft] : [.topRight]
                )

            Text("#\(rank)")
                .font(.system(size: 16, weight: .black))
                .foregroundStyle(Color(.systemGray3).opacity(0.5))
        }
    }
}

// MARK: - Preview

#if DEBUG
#Preview("Full podium — 3 participants") {
    NLBPodiumView(attempts: LeaderboardDataModel.LeaderboardAttempt.previewArray)
        .padding()
        .background(Color(.systemGroupedBackground))
}

#Preview("Only 1 participant — 2nd & 3rd are placeholders") {
    NLBPodiumView(attempts: [LeaderboardDataModel.LeaderboardAttempt.previewArray[0]])
        .padding()
        .background(Color(.systemGroupedBackground))
}

#Preview("2 participants — 3rd is placeholder") {
    NLBPodiumView(attempts: Array(LeaderboardDataModel.LeaderboardAttempt.previewArray.prefix(2)))
        .padding()
        .background(Color(.systemGroupedBackground))
}
#endif
