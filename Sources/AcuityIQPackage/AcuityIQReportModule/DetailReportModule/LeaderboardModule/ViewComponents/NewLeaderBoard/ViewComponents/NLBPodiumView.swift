//
//  NLBPodiumView.swift
//  AcuityIQPackage
//
//  Top podium section — #2 left, #1 centre (taller), #3 right.
//

import SwiftUI
import SwiftUIUtilities

// MARK: - Podium Container

struct NLBPodiumView: View {

    let attempts: [LeaderboardDataModel.LeaderboardAttempt]

    /// Rearranges so podium columns are: [#2, #1, #3]
    private var podiumColumns: [(rank: Int, attempt: LeaderboardDataModel.LeaderboardAttempt)] {
        var result: [(Int, LeaderboardDataModel.LeaderboardAttempt)] = []
        if attempts.count >= 2 { result.append((2, attempts[1])) }
        if attempts.count >= 1 { result.append((1, attempts[0])) }
        if attempts.count >= 3 { result.append((3, attempts[2])) }
        return result
    }

    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            ForEach(podiumColumns, id: \.rank) { column in
                NLBPodiumColumnView(rank: column.rank, attempt: column.attempt)
            }
        }
        .padding(.horizontal, 8)
        .padding(.top, 16)
    }
}

// MARK: - Single Podium Column

private struct NLBPodiumColumnView: View {

    let rank: Int
    let attempt: LeaderboardDataModel.LeaderboardAttempt

    private var rankColor: Color {
        LeaderboardDataModel.LeaderboardAttempt.nlbRankColor(for: rank)
    }

    private var avatarSize: CGFloat  { rank == 1 ? 72 : 58 }
    private var barHeight:  CGFloat  { rank == 1 ? 72 : rank == 2 ? 52 : 42 }
    private var nameFontStyle: Font  { rank == 1 ? .subheadline.bold() : .caption.bold() }
    private var scoreFontStyle: Font { rank == 1 ? .subheadline.bold() : .caption.bold() }

    var body: some View {
        VStack(spacing: 6) {

            // Crown icon only for rank 1
            if rank == 1 {
                Image(systemName: "crown.fill")
                    .foregroundStyle(Color(hex: "F5C518"))
                    .font(.title3)
            } else {
                Color.clear.frame(height: 22) // spacer to align avatars
            }

            // Avatar with rank badge
            ZStack(alignment: .bottomTrailing) {
                AsyncImageWithFallback(
                    urlString:attempt.profileFullPathURL?.absoluteString ,
                    defaultImageName: "user",
                    contentMode: .fill,
                    bundle: .module
                )
                .frame(width: avatarSize, height: avatarSize)
                .clipShape(Circle())
                .overlay {
                    Circle().stroke(rankColor, lineWidth: 1)
                }
                    

                // Rank badge bubble
                Text("\(rank)")
                    .font(.system(size: 10, weight: .black))
                    .foregroundStyle(.white)
                    .frame(width: 20, height: 20)
                    .background(rankColor.opacity(0.85))
                    .clipShape(Circle())
                    .overlay {
                        Circle().stroke(.white, lineWidth: 1.5)
                    }
                    .offset(x: 4, y: 4)
            }

            // Name
            Text(attempt.userName ?? "Unknown")
                .font(nameFontStyle)
                .foregroundStyle(.primary)
                .lineLimit(1)
                .padding(.horizontal, 4)

            // Score
            Text(String(format: "%.1f XP", attempt.overallScore ?? 0))
                .font(scoreFontStyle)
                .foregroundStyle(rankColor)

            // Podium bar
            Rectangle()
                .fill(rankColor)
                .frame(maxWidth: 250)
                .frame(height: barHeight)
                .cornerRadiusPkg(
                    12,
                    corners: rank == 1 ? [.topLeft, .topRight] : rank == 2 ? [.topLeft] : [.topRight]
                )
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Preview
#if Debug
#Preview {
    NLBPodiumView(attempts: LeaderboardDataModel.LeaderboardAttempt.previewArray)
        .padding()
}
#endif
