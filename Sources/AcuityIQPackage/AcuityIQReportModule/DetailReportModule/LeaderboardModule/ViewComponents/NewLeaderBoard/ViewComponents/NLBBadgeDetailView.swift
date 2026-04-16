//
//  NLBBadgeDetailView.swift
//  AcuityIQPackage
//

import SwiftUI

struct NLBBadgeDetailView: View {

    let badge: LeaderboardDataModel.NLBBadge

    @Environment(\.dismiss) private var dismiss

    private var headerColor: Color {
        badge.isEarned ? badge.activeColor : Color(hex: "6B7280")
    }

    var body: some View {
        VStack(spacing: 12) {
            header
            bodyContent
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .background(Color(.systemBackground))
        
    }

    // ─────────────────────────────────────────────────────────────────
    // MARK: Header  [icon]  Badge Name  [✕]
    // ─────────────────────────────────────────────────────────────────
    
    private var header: some View {
        HStack(spacing: 0) {
            
            badge.icon.imageView(size: 20)
                .foregroundStyle(.white)
                .frame(width: 52)
            
            Spacer(minLength: 0)
            
            Text(badge.name)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            
            Spacer(minLength: 0)
            
            Button(action: { dismiss() }) {
                Image(systemName: "xmark")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(.white.opacity(0.85))
                    .frame(width: 26, height: 26)
                    .background(.white.opacity(0.22))
                    .clipShape(Circle())
            }
            .frame(width: 52)
        }
        .padding(.vertical, 16)
        .background(headerColor)
    }
    

    // ─────────────────────────────────────────────────────────────────
    // MARK: Body
    // ─────────────────────────────────────────────────────────────────

    private var bodyContent: some View {
        Group {
            if badge.isEarned {
                earnedBody
            } else {
                unearnedBody
            }
        }
        .padding(.horizontal, 10)
    }

    // ── Earned ────────────────────────────────────────────────────────

    @ViewBuilder
    private var earnedBody: some View {
        VStack(spacing: 0) {

            // Centred summary (Clean Slate, Record Breaker)
            if let summary = badge.earnedSummary {
                Text(summary)
                    .font(.subheadline.bold())
                    .foregroundStyle(badge.activeColor)
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 8)

            } else if !badge.earnedItems.isEmpty {

                let hasBullets = badge.earnedItems.allSatisfy { $0.value.isEmpty }

                if hasBullets {
                    // Checkmark bullet list — Herculean Effort
                    VStack(alignment: .leading, spacing: 14) {
                        ForEach(badge.earnedItems) { item in
                            HStack(alignment: .top, spacing: 10) {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundStyle(badge.activeColor)
                                    .padding(.top, 1)
                                Text(item.label)
                                    .font(.subheadline)
                                    .foregroundStyle(.primary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                } else {
                    // Label / value rows — Mr. Consistent, Storyteller
                    VStack(spacing: 0) {
                        ForEach(Array(badge.earnedItems.enumerated()), id: \.element.id) { idx, item in
                            HStack {
                                Text(item.label)
                                    .font(.subheadline.bold())
                                    .foregroundStyle(.primary)
                                Spacer()
                                Text(item.value)
                                    .font(.subheadline.bold())
                                    .foregroundStyle(badge.activeColor)
                            }
                            .padding(.vertical, 14)

                            if idx < badge.earnedItems.count - 1 {
                                Divider()
                            }
                        }
                    }
                }
            }
        }
    }

    // ── Unearned ──────────────────────────────────────────────────────

    private var unearnedBody: some View {
        VStack(spacing: 16) {

            Text("Criteria: \(badge.criteriaText)")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(Color(.label))
                .multilineTextAlignment(.center)

            Divider()

            HStack(alignment: .center, spacing: 8) {
                Image(systemName: "exclamationmark.circle.fill")
                    .font(.system(size: 15))
                    .foregroundStyle(Color(hex: "EF4444"))

                Text(badge.shortfallText)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(Color(hex: "EF4444"))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color(hex: "FEF2F2"))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(hex: "FECACA"), lineWidth: 1)
            }
        }
    }
}

// MARK: - Preview

#if DEBUG

#Preview("Unearned — All Star") {
    Color.clear.sheet(isPresented: .constant(true)) {
        NLBBadgeDetailView(badge: .init(
            key: .allStar, name: "All Star", icon: .system("star.circle.fill"),
            activeColor: Color(hex: "8B5CF6"), isEarned: false,
            criteriaText: "Score ≥8 in all evaluation, ≥5 in all behavioural, no critical errors.",
            earnedItems: [], earnedSummary: nil,
            shortfallText: "Structure & Organization (7.8/10), Closure / Outcome Orientation (7.8/10) scored below 8. Pitch (3.6) scored below 5"
        ))
    }
}

#Preview("Unearned — Product Wizard") {
    Color.clear.sheet(isPresented: .constant(true)) {
        NLBBadgeDetailView(badge: .init(
            key: .productWizard, name: "Product Wizard", icon: .system("bolt.fill"),
            activeColor: Color(hex: "3B82F6"), isEarned: false,
            criteriaText: "≥50% of defined keywords must be covered.",
            earnedItems: [], earnedSummary: nil,
            shortfallText: "Only 25% keywords covered (1/4). Need 50% or more"
        ))
    }
}

#Preview("Unearned — Hustler") {
    Color.clear.sheet(isPresented: .constant(true)) {
        NLBBadgeDetailView(badge: .init(
            key: .hustler, name: "Hustler", icon: .system("flame.fill"),
            activeColor: Color(hex: "EF4444"), isEarned: false,
            criteriaText: "≥70% of available attempts must be utilized.",
            earnedItems: [], earnedSummary: nil,
            shortfallText: "Only 53% attempts used (16/30). Need 70% or more"
        ))
    }
}

#Preview("Unearned — Super Speaker") {
    Color.clear.sheet(isPresented: .constant(true)) {
        NLBBadgeDetailView(badge: .init(
            key: .superSpeaker, name: "Super Speaker", icon: .system("waveform"),
            activeColor: Color(hex: "10B981"), isEarned: false,
            criteriaText: "Score ≥5 across all behavioural parameters.",
            earnedItems: [], earnedSummary: nil,
            shortfallText: "Pitch (3.6) scored below 5"
        ))
    }
}

#Preview("Unearned — Honourable One") {
    Color.clear.sheet(isPresented: .constant(true)) {
        NLBBadgeDetailView(badge: .init(
            key: .honourableOne, name: "Honourable One", icon: .system("shield.fill"),
            activeColor: Color(hex: "06B6D4"), isEarned: false,
            criteriaText: "Achieve a high integrity score (>0.8).",
            earnedItems: [], earnedSummary: nil,
            shortfallText: "Integrity score is 0.00. Need above 0.8"
        ))
    }
}

#Preview("Unearned — Record Breaker") {
    Color.clear.sheet(isPresented: .constant(true)) {
        NLBBadgeDetailView(badge: .init(
            key: .recordBreaker, name: "Record Breaker", icon: .system("diamond.fill"),
            activeColor: Color(hex: "F59E0B"), isEarned: false,
            criteriaText: "Overall score of 9 or above.",
            earnedItems: [], earnedSummary: nil,
            shortfallText: "Overall score is 8.8/10. Need 9 or above"
        ))
    }
}

#Preview("Unearned — Certified Storyteller") {
    Color.clear.sheet(isPresented: .constant(true)) {
        NLBBadgeDetailView(badge: .init(
            key: .storyteller, name: "Certified Storyteller", icon: .system("book.closed.fill"),
            activeColor: Color(hex: "6366F1"), isEarned: false,
            criteriaText: "Score ≥8 across all evaluation parameters.",
            earnedItems: [], earnedSummary: nil,
            shortfallText: "Structure & Organization (7.8/10), Closure / Outcome Orientation (7.8/10) scored below 8"
        ))
    }
}

#Preview("Earned — Herculean Effort") {
    Color.clear.sheet(isPresented: .constant(true)) {
        NLBBadgeDetailView(badge: .init(
            key: .herculean, name: "Herculean Effort",
            icon: .system("figure.strengthtraining.traditional"),
            activeColor: Color(hex: "F97316"), isEarned: true,
            criteriaText: "More than 2 strengths must be identified.",
            earnedItems: [
                .init(label: "In the beginning, the user demonstrates knowledge of the pharmaceutical product, indicating a level of expertise in that area.", value: ""),
                .init(label: "Towards the middle, the user maintains a clear articulation of the product details, which shows confidence in their subject matter.", value: ""),
                .init(label: "In the end, the user's mention of the product's manufacturing quality suggests an understanding of safety and efficacy.", value: "")
            ],
            earnedSummary: nil, shortfallText: ""
        ))
    }
}

#Preview("Earned — Mr. Consistent") {
    Color.clear.sheet(isPresented: .constant(true)) {
        NLBBadgeDetailView(badge: .init(
            key: .mrConsistent, name: "Mr.Consistent", icon: .system("scalemass.fill"),
            activeColor: Color(hex: "5B8FF9"), isEarned: true,
            criteriaText: "Score ≥7.5 across beginning, middle and end.",
            earnedItems: [
                .init(label: "Beginning", value: "8.2/10"),
                .init(label: "Middle",    value: "8/10"),
                .init(label: "End",       value: "8/10")
            ],
            earnedSummary: nil, shortfallText: ""
        ))
    }
}

#Preview("Earned — Clean Slate") {
    Color.clear.sheet(isPresented: .constant(true)) {
        NLBBadgeDetailView(badge: .init(
            key: .cleanSlate, name: "Clean Slate", icon: .system("checkmark.seal.fill"),
            activeColor: Color(hex: "14B8A6"), isEarned: true,
            criteriaText: "Complete the scenario with no critical errors.",
            earnedItems: [],
            earnedSummary: "No critical errors recorded",
            shortfallText: ""
        ))
    }
}

#endif
