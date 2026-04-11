//
//  LeaderboardDataModel+NLB.swift
//  AcuityIQPackage
//
//  New-Leaderboard (NLB) computed properties added to the existing model.
//  Model & ViewModel remain unchanged — only extensions are added here.
//

import SwiftUI

// MARK: - NLB Computed Properties
extension LeaderboardDataModel.LeaderboardAttempt {

    // MARK: Avatar / Display

    /// Two-letter initials derived from `userName`.
    /// "LMS Admin" → "LA",  "James" → "JA",  "sanikaK" → "SK"
    var nlbInitials: String {
        let words = (userName ?? "?")
            .split(separator: " ")
            .map(String.init)
        if words.count >= 2 {
            let a = words[0].prefix(1)
            let b = words[1].prefix(1)
            return (a + b).uppercased()
        } else if let word = words.first, word.count >= 2 {
            return String(word.prefix(2)).uppercased()
        }
        return String((userName ?? "?").prefix(1)).uppercased()
    }

    // MARK: Score Representation

    /// Normalized 0–1 progress for the score bar (assumes max score = 10).
    var nlbScoreProgress: Double {
        let score = overallScore ?? 0.0
        return min(max(score / 10.0, 0.0), 1.0)
    }

    /// Whole-star rating out of 5 (ceil of score / 2, capped at 5).
    var nlbStarRating: Int {
        let raw = Int(ceil((overallScore ?? 0.0) / 2.0))
        return min(max(raw, 0), 5)
    }

    // MARK: OPEN / MIDDLE / CLOSE Feedback

    /// Section-aware feedback items mapped to OPEN / MIDDLE / CLOSE labels.
    /// Tries `sections` first (Beginning → OPEN, Middle → MIDDLE, End → CLOSE);
    /// falls back to indexing the flat `strengths` array.
    var nlbFeedbackItems: [(label: String, text: String)] {
        let sectionMap: [String: String] = [
            "beginning": "OPEN",
            "middle":    "MIDDLE",
            "end":       "CLOSE"
        ]

        // Prefer section-level strengths when available
        if let sections = sections, !sections.isEmpty {
            let items: [(String, String)] = sections.compactMap { section in
                guard
                    let name   = section.name,
                    let label  = sectionMap[name.lowercased()],
                    let text   = section.strengths?.first
                else { return nil }
                return (label, text)
            }
            if !items.isEmpty { return items }
        }

        // Fallback: index the flat strengths array
        let labels = ["OPEN", "MIDDLE", "CLOSE"]
        return (strengths ?? []).prefix(3).enumerated().map { i, text in
            (labels[i], text)
        }
    }

    // MARK: Badge Items

    /// Small circular badge descriptors derived from existing attempt data.
    /// Shown inline inside the rank card row.
    var nlbBadgeItems: [(icon: String, color: Color)] {
        var badges: [(String, Color)] = []

        // Attempt record
        if attemptsUsed != nil {
            badges.append(("doc.fill", Color(.systemGray2)))
        }
        // Multiple attempts used → lightning
        if (attemptsUsed ?? 0) > 1 {
            badges.append(("bolt.fill", Color(hex: "F5C518")))
        }
        // Has qualitative strengths → checkmark
        if strengths?.isEmpty == false {
            badges.append(("checkmark.circle.fill", Color(hex: "35B07A")))
        }
        // Herculean effort badge (always)
        badges.append(("heart.fill", Color(hex: "F5A623")))

        return badges
    }

    // MARK: Rank Styling (static)

    /// Accent colour for a given rank position (podium + card accent).
    static func nlbRankColor(for rank: Int) -> Color {
        switch rank {
        case 1:  return Color(hex: "F5C518")   // gold
        case 2:  return Color(hex: "5B8FF9")   // blue
        case 3:  return Color(hex: "35B07A")   // green
        default: return Color(.systemGray3)
        }
    }

    /// SF Symbol name for the rank medal shown above the rank number.
    static func nlbRankIcon(for rank: Int) -> String {
        rank == 1 ? "trophy.fill" : "medal.fill"
    }

    /// Medal tint for ranks 2 and 3.
    static func nlbMedalColor(for rank: Int) -> Color {
        rank == 2 ? Color(.systemGray) : Color(hex: "CD7F32")  // silver / bronze
    }
}
