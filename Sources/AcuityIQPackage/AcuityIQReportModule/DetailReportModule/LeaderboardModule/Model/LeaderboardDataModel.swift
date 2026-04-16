//
//  LeaderboardDataModel.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 05/04/26.
//

import SwiftUI
import SwiftUIUtilities
import NetworkService

struct LeaderboardDataModel {

    struct GetScenarioLeaderboardRequestModel: EndpointModel {

        let secnarioID: Int

        var path: String {
            [
                APIConst.courseBaseUrl,
                APIConst.versionAPI,
                APIConst.GetScenarioLeaderboard,
                String(secnarioID)
            ].joined(separator: "/")
        }

        var method: NetworkService.HTTPMethod { .get }

        var headers: [String: String]? { nil }
    }
}

// MARK: - Response Model

extension LeaderboardDataModel {

    struct LeaderboardAttempt: Codable, Identifiable {
        var id: Int { attemptId }

        let attemptId: Int
        let userId: Int?
        let userName: String?
        let profilePicture: String?
        let attemptNumber: Int?
        let attemptsUsed: Int?
        let totalAttempts: Int?
        let strengths: [String]?
        let improvements: [String]?
        let criticals: [String]?
        let overallScore: Double?
        let overallAttempts: Int?
        let behaviourGraphs: [BehaviourGraph]?
        let sections: [Section]?
        let evaluationCriteria: [EvaluationCriteria]?
        let videoPath: String?
        let keywordCoverage: [KeywordCoverage]?

        // MARK: Computed Properties

        var profileFullPathURL: URL? {
            ResourceUtils.getResourceURLPath(self.profilePicture)
        }

        var fullVideoPath: String {
            ResourceUtils.getResourcPath(self.videoPath)
        }

        // MARK: Nested Types

        struct BehaviourGraph: Codable, Identifiable {
            var id: String { name ?? UUID().uuidString }
            let name: String?
            let average: Double?
            let data: [Double]?
            let labels: [String]?
            let color: String?
            let feedback: String?
        }

        struct Section: Codable, Identifiable {
            var id: String { name ?? UUID().uuidString }
            let name: String?
            let score: Double?
            let color: String?
            let strengths: [String]?
            let improvements: [String]?
            let errors: [String]?
        }

        struct EvaluationCriteria: Codable, Identifiable {
            var id: String { parameter ?? UUID().uuidString }
            let parameter: String?
            let remarks: String?
            let score: Double?
        }

        // MARK: Coding Keys

        enum CodingKeys: String, CodingKey {
            case attemptId, userId, userName, profilePicture, attemptNumber, attemptsUsed, totalAttempts
            case strengths, improvements, criticals, overallScore, overallAttempts
            case behaviourGraphs, sections, evaluationCriteria, videoPath, keywordCoverage
        }

        // MARK: Decodable Init

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            attemptId       = try container.decode(Int.self,                  forKey: .attemptId)
            userId          = try container.decodeIfPresent(Int.self,         forKey: .userId)
            userName        = try container.decodeIfPresent(String.self,      forKey: .userName)
            profilePicture  = try container.decodeIfPresent(String.self,      forKey: .profilePicture)
            attemptNumber   = try container.decodeIfPresent(Int.self,         forKey: .attemptNumber)
            attemptsUsed    = try container.decodeIfPresent(Int.self,         forKey: .attemptsUsed)
            totalAttempts   = try container.decodeIfPresent(Int.self,         forKey: .totalAttempts)
            strengths       = try container.decodeIfPresent([String].self,    forKey: .strengths)
            improvements    = try container.decodeIfPresent([String].self,    forKey: .improvements)
            criticals       = try container.decodeIfPresent([String].self,    forKey: .criticals)
            overallScore    = try container.decodeIfPresent(Double.self,      forKey: .overallScore)
            overallAttempts = try container.decodeIfPresent(Int.self,         forKey: .overallAttempts)
            behaviourGraphs = try container.decodeIfPresent([BehaviourGraph].self, forKey: .behaviourGraphs)
            sections        = try container.decodeIfPresent([Section].self,        forKey: .sections)
            evaluationCriteria = try container.decodeIfPresent([EvaluationCriteria].self, forKey: .evaluationCriteria)
            videoPath       = try container.decodeIfPresent(String.self,      forKey: .videoPath)

            if let jsonStr  = try container.decodeIfPresent(String.self, forKey: .keywordCoverage),
               let jsonData = jsonStr.data(using: .utf8) {
                keywordCoverage = try? JSONDecoder().decode([KeywordCoverage].self, from: jsonData)
            } else {
                keywordCoverage = nil
            }
        }

        // MARK: Memberwise Init

        init(
            attemptId: Int,
            userId: Int? = nil,
            userName: String? = nil,
            profilePicture: String? = nil,
            attemptNumber: Int? = nil,
            attemptsUsed: Int? = nil,
            totalAttempts: Int? = nil,
            strengths: [String]? = nil,
            improvements: [String]? = nil,
            criticals: [String]? = nil,
            overallScore: Double? = nil,
            overallAttempts: Int? = nil,
            behaviourGraphs: [BehaviourGraph]? = nil,
            sections: [Section]? = nil,
            evaluationCriteria: [EvaluationCriteria]? = nil,
            videoPath: String? = nil,
            keywordCoverage: [KeywordCoverage]? = nil
        ) {
            self.attemptId          = attemptId
            self.userId             = userId
            self.userName           = userName
            self.profilePicture     = profilePicture
            self.attemptNumber      = attemptNumber
            self.attemptsUsed       = attemptsUsed
            self.totalAttempts      = totalAttempts
            self.strengths          = strengths
            self.improvements       = improvements
            self.criticals          = criticals
            self.overallScore       = overallScore
            self.overallAttempts    = overallAttempts
            self.behaviourGraphs    = behaviourGraphs
            self.sections           = sections
            self.evaluationCriteria = evaluationCriteria
            self.videoPath          = videoPath
            self.keywordCoverage    = keywordCoverage
        }
    }

    // MARK: - Keyword Coverage

    struct KeywordCoverage: Codable, Identifiable {
        var id: String { keyword ?? UUID().uuidString }
        let keyword: String?
        let status: String?
        var isCovered: Bool { status?.lowercased() == "covered" }
    }
}

// MARK: - Attempt Stat Item Model

extension LeaderboardDataModel {

    struct AttemptStatItem: Identifiable {
        let id = UUID()
        let icon: String
        let title: String
        let value: String
        let valueColor: Color

        init(icon: String, title: String, value: String, valueColor: Color = .primary) {
            self.icon       = icon
            self.title      = title
            self.value      = value
            self.valueColor = valueColor
        }

        static func remainingAttemptsColor(totalAttempts: Int, attemptsUsed: Int) -> Color {
            let remaining = totalAttempts - attemptsUsed
            if remaining <= 0  { return .red }
            if remaining <= 2  { return .orange }
            return .green
        }

        static func statItems(
            attemptNumber: Int,
            totalAttempts: Int,
            attemptsUsed: Int
        ) -> [AttemptStatItem] {
            [
                AttemptStatItem(icon: "number",              title: "Current Attempt",        value: "\(attemptNumber)"),
                AttemptStatItem(icon: "chart.bar.fill",      title: "Total Attempts Allowed",  value: "\(totalAttempts)"),
                AttemptStatItem(icon: "checkmark.circle.fill", title: "Attempts Used",         value: "\(attemptsUsed)"),
                AttemptStatItem(
                    icon: "clock.fill",
                    title: "Remaining Attempts",
                    value: "\(max(0, totalAttempts - attemptsUsed))",
                    valueColor: remainingAttemptsColor(totalAttempts: totalAttempts, attemptsUsed: attemptsUsed)
                )
            ]
        }
    }
}

// MARK: - NLB Badge Types

extension LeaderboardDataModel {

    // MARK: Badge Detail Item

    /// A single label / value row displayed inside an earned badge popup.
    struct NLBBadgeDetailItem: Identifiable {
        let id    = UUID()
        let label: String
        /// Empty → renders as a bullet row (e.g. Herculean strengths list).
        let value: String
    }

    // MARK: Badge

    struct NLBBadge: Identifiable {

        /// Keys mirror Angular getBadgeShortfall() switch cases exactly.
        enum BadgeKey: String {
            case allStar       = "allstar"
            case storyteller   = "storyteller"
            case productWizard = "wizard"
            case hustler       = "hustler"
            case superSpeaker  = "speaker"
            case honourableOne = "honourable"
            case cleanSlate    = "cleanslate"
            case herculean     = "herculean"
            case mrConsistent  = "consistent"
            case recordBreaker = "recordbreaker"
        }

        let key:           BadgeKey
        let name:          String
        /// SF Symbol name.
        let icon: LeaderboardDataModel.BadgeIcon
        /// Accent colour when earned.
        let activeColor:   Color
        let isEarned:      Bool
        /// Human-readable criteria shown in the unearned card.
        let criteriaText:  String
        /// Rows shown inside the popup when earned.
        let earnedItems:   [NLBBadgeDetailItem]
        /// Optional single-line centred summary (Record Breaker, Clean Slate).
        let earnedSummary: String?
        /// Shortfall explanation shown when not earned.
        let shortfallText: String

        var id: String { key.rawValue }

        var disabledColor: Color { Color(.systemGray3) }
        var displayColor:  Color { isEarned ? activeColor : disabledColor }
    }
}

// MARK: - General Computed Helpers

extension LeaderboardDataModel.LeaderboardAttempt {

    var profilePictureURL: URL? {
        guard let path = profilePicture, !path.isEmpty else { return nil }
        return URL(string: "https://uat.gogetempowered.com/org-content/\(path)")
    }

    var videoURL: URL? {
        guard let path = videoPath else { return nil }
        return ResourceUtils.getResourceURLPath(path)
    }

    var hasRemainingAttempts: Bool {
        (attemptsUsed ?? 0) < (totalAttempts ?? 0)
    }

    static var leaderBoardHeaderGradientStop: [Gradient.Stop] {
        [
            Gradient.Stop(color: Color(hex: "5B6AFA"), location: 0.0),
            Gradient.Stop(color: Color(hex: "7B8AFE"), location: 0.5),
            Gradient.Stop(color: Color(hex: "9B8AFF"), location: 1.0)
        ]
    }
}

// MARK: - NLB Computed Properties

extension LeaderboardDataModel.LeaderboardAttempt {

    // File-private typealiases to avoid full qualification inside this extension.
    private typealias Badge     = LeaderboardDataModel.NLBBadge
    private typealias BadgeItem = LeaderboardDataModel.NLBBadgeDetailItem

    // ─────────────────────────────────────────────────────────────────
    // MARK: Avatar
    // ─────────────────────────────────────────────────────────────────

    /// Two-letter initials from userName.
    /// "LMS Admin" → "LA",  "sanikaK" → "SK",  "James" → "JA"
    var nlbInitials: String {
        let words = (userName ?? "?").split(separator: " ").map(String.init)
        if words.count >= 2 {
            return (words[0].prefix(1) + words[1].prefix(1)).uppercased()
        } else if let w = words.first, w.count >= 2 {
            return String(w.prefix(2)).uppercased()
        }
        return String((userName ?? "?").prefix(1)).uppercased()
    }

    // ─────────────────────────────────────────────────────────────────
    // MARK: Score Helpers
    // ─────────────────────────────────────────────────────────────────

    /// Normalised 0–1 progress for the score bar (max score = 10).
    var nlbScoreProgress: Double {
        min(max((overallScore ?? 0) / 10.0, 0), 1)
    }

    /// Whole-star rating out of 5 (ceil of score ÷ 2, capped 0–5).
    var nlbStarRating: Int {
        min(max(Int(ceil((overallScore ?? 0) / 2.0)), 0), 5)
    }

    // ─────────────────────────────────────────────────────────────────
    // MARK: OPEN / MIDDLE / CLOSE Feedback
    // ─────────────────────────────────────────────────────────────────

    /// Feedback items mapped to OPEN / MIDDLE / CLOSE labels.
    var nlbFeedbackItems: [(label: String, text: String)] {
        let map: [String: String] = ["beginning": "OPEN", "middle": "MIDDLE", "end": "CLOSE"]
        if let secs = sections, !secs.isEmpty {
            let items: [(String, String)] = secs.compactMap { sec in
                guard let n = sec.name,
                      let label = map[n.lowercased()],
                      let text  = sec.strengths?.first
                else { return nil }
                return (label, text)
            }
            if !items.isEmpty { return items }
        }
        let labels = ["OPEN", "MIDDLE", "CLOSE"]
        return (strengths ?? []).prefix(3).enumerated().map { i, text in (labels[i], text) }
    }

    // ─────────────────────────────────────────────────────────────────
    // MARK: Rank Styling (static helpers)
    // ─────────────────────────────────────────────────────────────────

    static func nlbRankColor(for rank: Int) -> Color {
        switch rank {
        case 1:  return Color(hex: "F5C518")   // gold
        case 2:  return Color(hex: "5B8FF9")   // blue-silver
        case 3:  return Color(hex: "35B07A")   // green-bronze
        default: return Color(.systemGray3)
        }
    }

    static func nlbRankIcon(for rank: Int) -> String {
        rank == 1 ? "trophy.fill" : "medal.fill"
    }

    static func nlbMedalColor(for rank: Int) -> Color {
        rank == 2 ? Color(.systemGray) : Color(hex: "CD7F32")
    }

    // ─────────────────────────────────────────────────────────────────
    // MARK: Private Eligibility Helpers
    //       Each mirrors its Angular isXxxEligible() counterpart exactly.
    // ─────────────────────────────────────────────────────────────────

    /// All eval ≥ 8  AND  all behaviour ≥ 5  AND  no critical errors.
    private var nlb_isAllStarEligible: Bool {
        guard let evals = evaluationCriteria, !evals.isEmpty else { return false }
        guard evals.allSatisfy({ ($0.score ?? 0) >= 8 }) else { return false }
        if let bg = behaviourGraphs, !bg.isEmpty {
            guard bg.allSatisfy({ ($0.average ?? 0) >= 5 }) else { return false }
        }
        return nlb_validCriticals.isEmpty
    }

    /// All evaluation parameters ≥ 8.
    private var nlb_isCertifiedStorytellerEligible: Bool {
        guard let evals = evaluationCriteria, !evals.isEmpty else { return false }
        return evals.allSatisfy { ($0.score ?? 0) >= 8 }
    }

    /// ≥ 50 % of keywords are covered.
    private var nlb_isProductWizardEligible: Bool {
        let (c, t) = nlb_keywordCoverageStats
        return t > 0 && Double(c) / Double(t) >= 0.5
    }

    /// ≥ 70 % of available attempts have been used.
    private var nlb_isHustlerEligible: Bool {
        let used  = attemptsUsed ?? 0
        let total = totalAttempts ?? 0
        return total > 0 && Double(used) / Double(total) >= 0.7
    }

    /// All behavioural parameter averages ≥ 5.
    private var nlb_isSuperSpeakerEligible: Bool {
        guard let bg = behaviourGraphs, !bg.isEmpty else { return false }
        return bg.allSatisfy { ($0.average ?? 0) >= 5 }
    }

    /// Integrity / confidence score > 0.8.
    /// Stub — replace `return false` with `return (confidenceScore ?? 0) > 0.8`
    /// once `confidenceScore` is added to the model.
    private var nlb_isHonourableOneEligible: Bool { false }

    /// No non-empty critical errors.
    private var nlb_isCleanSlateEligible: Bool { nlb_validCriticals.isEmpty }

    /// More than 2 non-empty strengths.
    private var nlb_isHerculeanEffortEligible: Bool { nlb_validStrengths.count > 2 }

    /// All sections (beginning / middle / end) score ≥ 7.5.
    private var nlb_isMrConsistentEligible: Bool {
        guard let secs = sections, !secs.isEmpty else { return false }
        return secs.allSatisfy { ($0.score ?? 0) >= 7.5 }
    }

    /// Overall score ≥ 9.
    private var nlb_isRecordBreakerEligible: Bool { (overallScore ?? 0) >= 9 }

    // ─────────────────────────────────────────────────────────────────
    // MARK: Private Convenience
    // ─────────────────────────────────────────────────────────────────

    private var nlb_keywordCoverageStats: (covered: Int, total: Int) {
        guard let kw = keywordCoverage else { return (0, 0) }
        return (kw.filter { $0.isCovered }.count, kw.count)
    }

    private var nlb_validStrengths: [String] {
        (strengths ?? []).filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
    }

    private var nlb_validCriticals: [String] {
        (criticals ?? []).filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
    }

    // ─────────────────────────────────────────────────────────────────
    // MARK: All 10 Badges
    // ─────────────────────────────────────────────────────────────────

    /// Full badge list for this attempt, ordered highest prestige first.
    /// Mirrors the Angular leaderboard column badge order.
    var nlbBadges: [LeaderboardDataModel.NLBBadge] {[
        nlb_makeAllStarBadge(),
        nlb_makeStorytellerBadge(),
        nlb_makeProductWizardBadge(),
        nlb_makeHustlerBadge(),
        nlb_makeSuperSpeakerBadge(),
        nlb_makeHonourableOneBadge(),
        nlb_makeCleanSlateBadge(),
        nlb_makeHerculeanBadge(),
        nlb_makeMrConsistentBadge(),
        nlb_makeRecordBreakerBadge()
    ]}

    // ── Individual Badge Builders ─────────────────────────────────────
    // Each builder is private — callers always go through `nlbBadges`.

    private func nlb_makeAllStarBadge() -> Badge {
        let earned = nlb_isAllStarEligible
        var items: [BadgeItem] = []
        if earned {
            (evaluationCriteria ?? []).forEach { e in
                items.append(.init(label: e.parameter ?? "—", value: String(format: "%.1f/10", e.score ?? 0)))
            }
            (behaviourGraphs ?? []).forEach { b in
                items.append(.init(label: b.name ?? "—", value: String(format: "%.1f", b.average ?? 0)))
            }
        }
        var reasons: [String] = []
        if let ev = evaluationCriteria, !ev.isEmpty {
            let f = ev.filter { ($0.score ?? 0) < 8 }
            if !f.isEmpty {
                reasons.append(f.map { $0.parameter ?? "?" }.joined(separator: ", ") + " scored below 8")
            }
        }
        if let bg = behaviourGraphs, !bg.isEmpty {
            let f = bg.filter { ($0.average ?? 0) < 5 }
            if !f.isEmpty {
                reasons.append(f.map { $0.name ?? "?" }.joined(separator: ", ") + " below 5")
            }
        }
        if !nlb_validCriticals.isEmpty {
            reasons.append("\(nlb_validCriticals.count) critical error(s) recorded")
        }
        return Badge(
            key:           .allStar,
            name:          "All Star",
            icon:          .system("trophy.fill"),
            activeColor:   Color(hex: "8B5CF6"),
            isEarned:      earned,
            criteriaText:  "All eval ≥ 8, all behaviour ≥ 5, no critical errors.",
            earnedItems:   items,
            earnedSummary: nil,
            shortfallText: reasons.isEmpty ? "Criteria not met" : reasons.joined(separator: ". ")
        )
    }

    private func nlb_makeStorytellerBadge() -> Badge {
        let earned = nlb_isCertifiedStorytellerEligible
        let items: [BadgeItem] = earned
            ? (evaluationCriteria ?? []).map {
                .init(label: $0.parameter ?? "—", value: String(format: "%.1f/10", $0.score ?? 0))
              }
            : []
        let shortfall: String = {
            guard let ev = evaluationCriteria, !ev.isEmpty else { return "No evaluation data available" }
            let f = ev.filter { ($0.score ?? 0) < 8 }
            return f.map { "\($0.parameter ?? "?") (\(String(format: "%.1f", $0.score ?? 0))/10)" }
                    .joined(separator: ", ") + " scored below 8"
        }()
        return Badge(
            key:           .storyteller,
            name:          "Certified Storyteller",
            icon:          .system("book.closed.fill"),
            activeColor:   Color(hex: "6366F1"),
            isEarned:      earned,
            criteriaText:  "All evaluation parameters must score ≥ 8.",
            earnedItems:   items,
            earnedSummary: nil,
            shortfallText: shortfall
        )
    }

    private func nlb_makeProductWizardBadge() -> Badge {
        let earned           = nlb_isProductWizardEligible
        let (covered, total) = nlb_keywordCoverageStats
        let pct              = total > 0 ? Int(Double(covered) / Double(total) * 100) : 0
        return Badge(
            key:           .productWizard,
            name:          "Product Wizard",
            icon:          .system("bolt.fill"),
            activeColor:   Color(hex: "3B82F6"),
            isEarned:      earned,
            criteriaText:  "≥ 50% of defined keywords must be covered.",
            earnedItems:   earned ? [.init(label: "Keywords Covered", value: "\(covered) of \(total)")] : [],
            earnedSummary: nil,
            shortfallText: total == 0
                ? "No keywords defined"
                : "Only \(pct)% covered (\(covered)/\(total)). Need 50% or more"
        )
    }

    private func nlb_makeHustlerBadge() -> Badge {
        let earned = nlb_isHustlerEligible
        let used   = attemptsUsed ?? 0
        let total  = totalAttempts ?? 0
        let pct    = total > 0 ? Int(Double(used) / Double(total) * 100) : 0
        return Badge(
            key:           .hustler,
            name:          "Hustler",
            icon:          .system("flame.fill"),
            activeColor:   Color(hex: "EF4444"),
            isEarned:      earned,
            criteriaText:  "≥ 70% of available attempts must be utilised.",
            earnedItems:   earned ? [.init(label: "Attempts Used", value: "\(used) of \(total)")] : [],
            earnedSummary: nil,
            shortfallText: total == 0
                ? "No attempts data"
                : "Only \(pct)% used (\(used)/\(total)). Need 70% or more"
        )
    }

    private func nlb_makeSuperSpeakerBadge() -> Badge {
        let earned = nlb_isSuperSpeakerEligible
        let items: [BadgeItem] = earned
            ? (behaviourGraphs ?? []).map {
                .init(label: $0.name ?? "—", value: String(format: "%.1f", $0.average ?? 0))
              }
            : []
        let shortfall: String = {
            guard let bg = behaviourGraphs, !bg.isEmpty else { return "No behavioural data available" }
            let f = bg.filter { ($0.average ?? 0) < 5 }
            return f.map { "\($0.name ?? "?") (\(String(format: "%.1f", $0.average ?? 0)))" }
                    .joined(separator: ", ") + " scored below 5"
        }()
        return Badge(
            key:           .superSpeaker,
            name:          "Super Speaker",
            icon:          .system("star.fill"),
            activeColor:   Color(hex: "10B981"),
            isEarned:      earned,
            criteriaText:  "Score ≥ 5 across all behavioural parameters.",
            earnedItems:   items,
            earnedSummary: nil,
            shortfallText: shortfall
        )
    }

    private func nlb_makeHonourableOneBadge() -> Badge {
        Badge(
            key:           .honourableOne,
            name:          "Honourable One",
            icon:          .system("shield.lefthalf.filled"),
            activeColor:   Color(hex: "06B6D4"),
            isEarned:      nlb_isHonourableOneEligible,
            criteriaText:  "Achieve a high integrity score (> 0.8).",
            earnedItems:   [],
            earnedSummary: nil,
            shortfallText: "Integrity score unavailable. Need above 0.8"
        )
    }

    private func nlb_makeCleanSlateBadge() -> Badge {
        let earned    = nlb_isCleanSlateEligible
        let shortfall = nlb_validCriticals.isEmpty
            ? "Criteria not met"
            : "\(nlb_validCriticals.count) critical error(s): " + nlb_validCriticals.prefix(3).joined(separator: "; ")
        return Badge(
            key:           .cleanSlate,
            name:          "Clean Slate",
            icon:          .system("checkmark.seal.fill"),
            activeColor:   Color(hex: "14B8A6"),
            isEarned:      earned,
            criteriaText:  "Complete the scenario with no critical errors.",
            earnedItems:   [],
            earnedSummary: earned ? "No critical errors recorded ✓" : nil,
            shortfallText: shortfall
        )
    }

    private func nlb_makeHerculeanBadge() -> Badge {
        let earned = nlb_isHerculeanEffortEligible
        return Badge(
            key:           .herculean,
            name:          "Herculean Effort",
            icon:          .custom("fist"),
            activeColor:   Color(hex: "F97316"),
            isEarned:      earned,
            criteriaText:  "More than 2 strengths must be identified.",
            earnedItems:   earned ? nlb_validStrengths.map { .init(label: $0, value: "") } : [],
            earnedSummary: nil,
            shortfallText: "Only \(nlb_validStrengths.count) strength(s) identified. Need more than 2"
        )
    }

    private func nlb_makeMrConsistentBadge() -> Badge {
        let earned   = nlb_isMrConsistentEligible
        let labelMap = ["beginning": "OPEN", "middle": "MIDDLE", "end": "CLOSE"]
        let items: [BadgeItem] = earned
            ? (sections ?? []).map { sec in
                let label = labelMap[sec.name?.lowercased() ?? ""] ?? (sec.name ?? "—")
                return .init(label: label, value: String(format: "%.1f/10", sec.score ?? 0))
              }
            : []
        let shortfall: String = {
            guard let secs = sections, !secs.isEmpty else { return "No section data available" }
            let f = secs.filter { ($0.score ?? 0) < 7.5 }
            return f.map { "\($0.name ?? "?") (\(String(format: "%.1f", $0.score ?? 0))/10)" }
                    .joined(separator: ", ") + " scored below 7.5"
        }()
        return Badge(
            key:           .mrConsistent,
            name:          "Mr. Consistent",
            icon:          .custom("scale"),
            activeColor:   Color(hex: "5B8FF9"),
            isEarned:      earned,
            criteriaText:  "Score ≥ 7.5 across beginning, middle and end.",
            earnedItems:   items,
            earnedSummary: nil,
            shortfallText: shortfall
        )
    }
    
    
    private func nlb_makeRecordBreakerBadge() -> Badge {
        let score = overallScore ?? 0
        return Badge(
            key:           .recordBreaker,
            name:          "Record Breaker",
            icon:          .custom("diamond"),
            activeColor:   Color(hex: "F59E0B"),
            isEarned:      nlb_isRecordBreakerEligible,
            criteriaText:  "Overall score of 9 or above.",
            earnedItems:   [],
            earnedSummary: String(format: "%.1f / 10 — Outstanding performance! 🌟", score),
            shortfallText: String(format: "Overall score is %.1f/10. Need 9 or above.", score)
        )
    }
}


// MARK: - Badge Icon

extension LeaderboardDataModel {

    enum BadgeIcon: Equatable {

        /// SF Symbol — use with Image(systemName:)
        case system(String)

        /// Asset Catalog inside this package — use with Image(_:bundle:)
        case custom(String)

        // MARK: SwiftUI View

        var image: Image {
            switch self {
            case .system(let name): return Image(systemName: name)
            case .custom(let name): return Image(name, bundle: .module)
            }
        }

        /// Size-aware view — use this wherever you need precise sizing.
        /// SF Symbols scale via font; custom assets use resizable + frame.
        @ViewBuilder
        func imageView(size: CGFloat = 24) -> some View {
            switch self {
            case .system(let name):
                Image(systemName: name)
                    .font(.system(size: size, weight: .semibold))
            case .custom(let name):
                Image(name, bundle: .module)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: size, height: size)
            }
        }

        // MARK: UIKit (optional)

        var uiImage: UIImage? {
            switch self {
            case .system(let name): return UIImage(systemName: name)
            case .custom(let name): return UIImage(named: name, in: .module, with: nil)
            }
        }
    }
}
// MARK: - Debug Previews

#if DEBUG
extension LeaderboardDataModel.LeaderboardAttempt {

    static var previewArray: [LeaderboardDataModel.LeaderboardAttempt] {
        [
            // Actual API-based preview
            .init(
                attemptId: 560,
                userId: 9868,
                userName: "LMS Admin",
                profilePicture: "enth/639092864775167395.png",
                attemptNumber: 4,
                attemptsUsed: 9,
                totalAttempts: 4,
                strengths: [
                    "In the beginning, the user introduced themselves confidently, which sets a positive tone.",
                    "Towards the middle, the user maintained a steady flow while discussing the products, indicating familiarity with the topic.",
                    "In the end, the user attempted to provide additional product information, which shows an effort to engage."
                ],
                improvements: [
                    "At 00:00, ensure the discussion is centered on clarinovatab to align with the reference material.",
                    "At 00:15, incorporate specific details about clarinovatab's indications, dosages, and pricing to enhance relevance.",
                    "At 00:30, focus on the competitive advantages of clarinovatab over other brands, as highlighted in the reference material."
                ],
                criticals: [
                    "The video uploaded was not relevant to the reference material.",
                    "Inconsistent eye contact suggests compromised response integrity and reduced confidence."
                ],
                overallScore: 1.9,
                overallAttempts: 4,
                behaviourGraphs: [
                    .init(name: "Clarity",      average: 6.7, data: [0.0, 6.8, 6.6, 6.6], labels: ["00:00", "00:30", "01:00", "01:15"], color: "rgb(59, 130, 246)",  feedback: "Your clarity supported the interaction adequately, with room for refinement."),
                    .init(name: "Filler Usage", average: 6.1, data: [0.0, 4.4, 7.8, 6.2], labels: ["00:00", "00:30", "01:00", "01:15"], color: "rgb(236, 72, 153)", feedback: "As the conversation progressed, reducing filler words can improve fluency."),
                    .init(name: "Mood",         average: 5.6, data: [0.0, 5.6, 5.6, 5.6], labels: ["00:00", "00:30", "01:00", "01:15"], color: "rgb(245, 158, 11)", feedback: "In the closing moments, expressive delivery can enhance engagement."),
                    .init(name: "Pitch",        average: 3.9, data: [0.0, 3.8, 3.9, 3.9], labels: ["00:00", "00:30", "01:00", "01:15"], color: "rgb(139, 92, 246)", feedback: "At the beginning of the conversation, greater pitch variation can improve engagement."),
                    .init(name: "Pace",         average: 6.0, data: [0.0, 7.5, 6.1, 4.5], labels: ["00:00", "00:30", "01:00", "01:15"], color: "rgb(16, 185, 129)", feedback: "Overall, pace was acceptable, though minor adjustments could strengthen communication."),
                    .init(name: "Tone",         average: 5.2, data: [0.0, 5.3, 5.2, 5.2], labels: ["00:00", "00:30", "01:00", "01:15"], color: "rgb(14, 165, 233)", feedback: "The tone showed noticeable inconsistency and needs improvement.")
                ],
                sections: [
                    .init(name: "Beginning", score: 0.8, color: "red",
                          strengths: [],
                          improvements: ["The user should ensure they are discussing the correct product, aligning with the reference material about clarinovatab."],
                          errors: ["The video uploaded was not relevant to the reference material."]),
                    .init(name: "Middle", score: 1.4, color: "red",
                          strengths: [],
                          improvements: ["At 00:00, the user should ensure they are discussing the correct product.", "At 00:15, the user could incorporate specific details about clarinovatab.", "At 00:30, the user should focus on competitive advantages."],
                          errors: ["The video uploaded was not relevant to the reference material."]),
                    .init(name: "End", score: 1.8, color: "red",
                          strengths: [],
                          improvements: ["At 00:18, ensure discussion is centred on clarinovatab.", "At 00:19, incorporate specific product details.", "At 00:20, focus on competitive advantages."],
                          errors: ["The video uploaded was not relevant to the reference material."])
                ],
                evaluationCriteria: [
                    .init(parameter: "Clarity",               remarks: "The communication lacks clarity, with some phrases being convoluted and difficult to follow.",              score: 1.9),
                    .init(parameter: "Content Relevance",     remarks: "The content is somewhat relevant but diverges into details that may not directly address customer concerns.", score: 1.8),
                    .init(parameter: "Structure & Organization", remarks: "The structure is disorganized, making it hard to track the main points being presented.",                score: 1.6),
                    .init(parameter: "Intent Clarity",        remarks: "The intent is not clearly articulated, leading to confusion about the primary message.",                   score: 1.6),
                    .init(parameter: "Confidence & Presence", remarks: "The delivery lacks confidence, which diminishes the overall impact of the message.",                       score: 0.2)
                ],
                videoPath: "https://uat.gogetempowered.com/org-content/uatempworedcontent/enth/video/mp4/639108205421805725639093591349777061TELMIKINDCT.mp4",
                keywordCoverage: [
                    .init(keyword: "test22", status: "Not Covered"),
                    .init(keyword: "test",   status: "Not Covered")
                ]
            ),

            // Empty / minimal state
            .init(attemptId: 0, userName: "Guest", attemptNumber: 1, attemptsUsed: 0, totalAttempts: 3),

            // High performer
            .init(
                attemptId: 999,
                userName: "Top Performer",
                attemptNumber: 1,
                attemptsUsed: 1,
                totalAttempts: 3,
                strengths: ["Exceptional clarity", "Masterful storytelling"],
                improvements: [],
                criticals: [],
                overallScore: 98.2,
                overallAttempts: 42,
                behaviourGraphs: [.previewConfidence],
                sections: [.previewIntro],
                evaluationCriteria: [.init(parameter: "Overall", remarks: "Outstanding", score: 9.8)],
                videoPath: "videos/top.mp4",
                keywordCoverage: [
                    .init(keyword: "leadership", status: "covered"),
                    .init(keyword: "excellence", status: "covered")
                ]
            )
        ]
    }
}

extension LeaderboardDataModel.LeaderboardAttempt.BehaviourGraph {
    static var previewConfidence: LeaderboardDataModel.LeaderboardAttempt.BehaviourGraph {
        .init(
            name: "Confidence",
            average: 8.4,
            data: [6.5, 7.2, 8.0, 8.8, 9.1, 8.5, 8.4],
            labels: ["Start", "0:30", "1:00", "1:30", "2:00", "2:30", "End"],
            color: "rgb(91, 106, 250)",
            feedback: "Confidence grew steadily."
        )
    }
}

extension LeaderboardDataModel.LeaderboardAttempt.Section {
    static var previewIntro: LeaderboardDataModel.LeaderboardAttempt.Section {
        .init(
            name: "Introduction",
            score: 9.0,
            color: "rgb(46, 204, 113)",
            strengths: ["Strong hook"],
            improvements: ["Be concise"],
            errors: []
        )
    }
}
#endif
