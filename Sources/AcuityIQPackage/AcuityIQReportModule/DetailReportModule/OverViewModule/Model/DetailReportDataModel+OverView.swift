//
//  File.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 01/04/26.
//

import SwiftUI


extension DetailReportDataModel.ScenarioAttemptResponse {
    
    struct StatCardModel: Identifiable {
        let id: UUID
        let icon: Icon
        let label: String
        let value: String

        init(id: UUID = UUID(), icon: Icon, label: String, value: String) {
            self.id = id
            self.icon = icon
            self.label = label
            self.value = value
        }
    }

    // MARK: - Individual Stat Cards

    var attemptCard: StatCardModel {
        StatCardModel(
            icon: .system(name: "chart.bar.fill"),
            label: "Attempt",
            value: attemptNumber.map { "#\($0)" } ?? "--"
        )
    }

    var durationCard: StatCardModel {
        StatCardModel(
            icon: .system(name: "clock.fill"),
            label: "Duration",
            value: duration ?? "--:--"
        )
    }

    var overallRatingCard: StatCardModel {
        let formatted = overallScore.map { String(format: "%.1f/10", $0) } ?? "--/10"
        return StatCardModel(
            icon: .system(name: "star"),
            label: "Overall Rating",
            value: formatted
        )
    }

    // MARK: - All Cards

    var statCards: [StatCardModel] {
        [attemptCard, durationCard, overallRatingCard]
    }
}

// MARK: - ScoreLevel & Model
extension DetailReportDataModel.ScenarioAttemptResponse {

    enum ScoreLevel: String, CaseIterable {
        case poor         = "Poor"
        case belowAverage = "Below Avg"
        case average      = "Average"
        case good         = "Good"
        case excellent    = "Excellent"

        // MARK: Gauge

        var color: Color {
            switch self {
            case .poor:         return .red
            case .belowAverage: return .orange
            case .average:      return .blue
            case .good:         return .cyan
            case .excellent:    return .green
            }
        }

        var location: Double {
            switch self {
            case .poor:         return 0.0
            case .belowAverage: return 0.25
            case .average:      return 0.5
            case .good:         return 0.75
            case .excellent:    return 1.0
            }
        }

        // MARK: Header

        var title: String {
            switch self {
            case .poor:         return "Poor Performance"
            case .belowAverage: return "Below Average Performance"
            case .average:      return "Average Performance"
            case .good:         return "Good Performance"
            case .excellent:    return "Excellent Performance"
            }
        }

        var icon: String {
            switch self {
            case .poor:         return "xmark.circle.fill"
            case .belowAverage: return "exclamationmark.triangle.fill"
            case .average:      return "minus.circle.fill"
            case .good:         return "hand.thumbsup.fill"
            case .excellent:    return "star.circle.fill"
            }
        }

        var iconColor: Color {
            switch self {
            case .poor:         return .red
            case .belowAverage: return .orange
            case .average:      return .blue
            case .good:         return .cyan
            case .excellent:    return .green
            }
        }

        // MARK: Alert Card

        var alertTitle: String {
            switch self {
            case .poor:         return "Poor Score"
            case .belowAverage: return "Below Average Score"
            case .average:      return "Average Score"
            case .good:         return "Good Score"
            case .excellent:    return "Excellent Score"
            }
        }

        var alertIcon: String {
            switch self {
            case .poor:         return "xmark.circle.fill"
            case .belowAverage: return "exclamationmark.triangle.fill"
            case .average:      return "minus.circle.fill"
            case .good:         return "hand.thumbsup.fill"
            case .excellent:    return "checkmark.circle.fill"
            }
        }

        var alertIconColor: Color {
            switch self {
            case .poor:         return .red
            case .belowAverage: return .yellow
            case .average:      return .blue
            case .good:         return .cyan
            case .excellent:    return .green
            }
        }

        var trailingIcon: String {
            switch self {
            case .poor:         return "exclamationmark.circle.fill"
            case .belowAverage: return "exclamationmark.circle"
            case .average:      return "minus.circle"
            case .good:         return "checkmark.circle"
            case .excellent:    return "checkmark.circle.fill"
            }
        }

        // MARK: Descriptive Text

        var subtitle: String {
            switch self {
            case .poor:
                return "Performance is significantly below expectations and requires immediate attention."
            case .belowAverage:
                return "Performance is below the expected standard with notable areas needing improvement."
            case .average:
                return "Performance meets the basic standard but has clear room for growth."
            case .good:
                return "Performance is above average with only minor areas left to refine."
            case .excellent:
                return "Performance exceeds expectations across all evaluated parameters."
            }
        }

        var alertMessage: String {
            switch self {
            case .poor:
                return "Critical gaps detected. Immediate intervention and focused practice are strongly recommended."
            case .belowAverage:
                return "Several areas require improvement. Consistent practice and targeted feedback will help raise performance."
            case .average:
                return "A reasonable baseline has been established. Continued effort and refinement will lead to stronger results."
            case .good:
                return "Strong performance overall. Minor adjustments could elevate this to an excellent level."
            case .excellent:
                return "Outstanding performance. Maintain this standard and serve as a benchmark for peers."
            }
        }
    }
    
    var scoreLevel: ScoreLevel {
        let score = overallScore ?? 0
        let normalized = score > 5 ? score / 2 : score  // matches overallScoreModel logic
        switch normalized {
        case 0..<1:   return .poor
        case 1..<2:   return .belowAverage
        case 2..<3:   return .average
        case 3..<4:   return .good
        default:      return .excellent
        }
    }
    
    struct OverallScoreModel {
        let value: Double
        let range: ClosedRange<Double>
        let segments: [GaugeSegment]
        
        var normalizedValue: Double {
            min(max(value, range.lowerBound), range.upperBound)
        }
    }

    var overallScoreModel: OverallScoreModel {
        let score = overallScore ?? 0
        
        return OverallScoreModel(
            value: score,
            range: 0...10,
            segments: .defaultSegments()
        )
    }
}



extension DetailReportDataModel.ScenarioAttemptResponse {

    static let preview: Self = .init(
        scenarioId: 113,
        userId: 9868,
        attemptNumber: 3,
        strengths: [
            "In the beginning, the user shows enthusiasm in their introduction, which is engaging.",
            "Towards the middle, the user maintains a clear structure in presenting the product, even though it is not relevant to the reference.",
            "In the end, the user's confidence in discussing the product is evident."
        ],
        improvements: [
            "At 00:00, the user should start by introducing Galact and its relevance to breastfeeding mothers, aligning with the reference material.",
            "At 00:30, the user should discuss the common challenges faced by mothers in breastfeeding to connect with the audience.",
            "At 01:00, the user should emphasize the benefits of Galact, such as increasing breast milk volume and enhancing mothers' confidence."
        ],
        criticals: [
            "The video uploaded was not relevant to the reference material."
        ],
        overallScore: 2.5,
        overallAttempts: 3,
        duration: "01:01",
        summary: "The delivered video transcript fails to align with the reference material, which focuses on 'Galact' for breastfeeding mothers, while the transcript discusses 'Clarinova' related to infections, indicating a complete mismatch in subject matter.",
        behaviourGraphs: [
            .init(
                name: "Clarity",
                average: 6.5,
                data: [0.0, 5.9, 5.7, 8.0],
                labels: ["00:00", "00:30", "01:00", "01:01"],
                color: "rgb(59, 130, 246)",
                feedback: "Your clarity supported the interaction adequately, with room for refinement."
            ),
            .init(
                name: "Filler Usage",
                average: 5.9,
                data: [0.0, 4.4, 7.1, 6.3],
                labels: ["00:00", "00:30", "01:00", "01:01"],
                color: "rgb(236, 72, 153)",
                feedback: "During the core part of the discussion, controlled pauses can strengthen delivery."
            ),
            .init(
                name: "Mood",
                average: 5.5,
                data: [0.0, 5.6, 5.6, 5.4],
                labels: ["00:00", "00:30", "01:00", "01:01"],
                color: "rgb(245, 158, 11)",
                feedback: "Towards the end of the conversation, expressive delivery can enhance engagement."
            ),
            .init(
                name: "Pitch",
                average: 3.6,
                data: [0.0, 4.5, 4.7, 1.5],
                labels: ["00:00", "00:30", "01:00", "01:01"],
                color: "rgb(139, 92, 246)",
                feedback: "At the beginning of the conversation, strategic emphasis through pitch can enhance expression."
            ),
            .init(
                name: "Pace",
                average: 6.0,
                data: [0.0, 4.9, 5.1, 7.9],
                labels: ["00:00", "00:30", "01:00", "01:01"],
                color: "rgb(16, 185, 129)",
                feedback: "With better control, pace could improve overall communication quality."
            ),
            .init(
                name: "Tone",
                average: 5.1,
                data: [0.0, 5.2, 5.2, 4.8],
                labels: ["00:00", "00:30", "01:00", "01:01"],
                color: "rgb(14, 165, 233)",
                feedback: "Strengthening tone would help create a more confident delivery."
            )
        ],
        sections: [
            .init(
                name: "Beginning",
                score: 1.7,
                color: "red",
                strengths: [],
                improvements: [
                    "The user should start by introducing Galact and its relevance to breastfeeding mothers, aligning with the reference material."
                ],
                errors: [
                    "The video uploaded was not relevant to the reference material."
                ]
            ),
            .init(
                name: "Middle",
                score: 0.0,
                color: "red",
                strengths: [],
                improvements: [
                    "At 00:00, the user should start by introducing Galact and its relevance to breastfeeding mothers.",
                    "At 00:30, the user should discuss the common challenges faced by mothers in breastfeeding.",
                    "At 01:00, the user should emphasize the benefits of Galact."
                ],
                errors: [
                    "The video uploaded was not relevant to the reference material."
                ]
            ),
            .init(
                name: "End",
                score: 1.7,
                color: "red",
                strengths: [],
                improvements: [
                    "At 00:00, the user should start by introducing Galact and its relevance to breastfeeding mothers.",
                    "At 00:30, the user should discuss the common challenges faced by mothers in breastfeeding.",
                    "At 01:00, the user should emphasize the benefits of Galact."
                ],
                errors: [
                    "The video uploaded was not relevant to the reference material."
                ]
            )
        ],
        evaluationCriteria: [
            .init(
                parameter: "Clarity",
                remarks: "The introduction of the product is somewhat clear, but the transition to different products is abrupt and may confuse the audience.",
                score: 1.6
            ),
            .init(
                parameter: "Content Relevance",
                remarks: "The content shifts from introducing galact to discussing clarinova, which may dilute the focus on the intended product.",
                score: 1.3
            ),
            .init(
                parameter: "Structure & Organization",
                remarks: "The presentation lacks a coherent structure, making it difficult to follow the main points effectively.",
                score: 0.6
            ),
            .init(
                parameter: "Intent Clarity",
                remarks: "The intent to promote a product is present, but it is not clearly articulated due to the mixed messaging.",
                score: 1.2
            ),
            .init(
                parameter: "Confidence & Presence",
                remarks: "The delivery shows some confidence, but the mixed focus may undermine the speaker's presence.",
                score: 1.6
            ),
            .init(
                parameter: "Closure / Outcome Orientation",
                remarks: "The conclusion lacks a strong call to action regarding the endorsement of the product.",
                score: 0.4
            )
        ],
        videoPath: "https://uat.gogetempowered.com/org-content/uatempworedcontent/enth/video/mp4/639105679696961888Clarinova1.mp4",
        keywordCoverage: [
            .init(keyword: "Breastfeeding", status: .notCovered),
            .init(keyword: "Breast Milk Supply", status: .notCovered),
            .init(keyword: "C section", status: .notCovered),
            .init(keyword: "Pre-term", status: .notCovered),
            .init(keyword: "Lactation insufficiency", status: .notCovered),
            .init(keyword: "Postpartum recovery", status: .notCovered),
            .init(keyword: "Galact", status: .notCovered),
            .init(keyword: "Empower", status: .notCovered),
            .init(keyword: "Prolactin", status: .notCovered),
            .init(keyword: "39%", status: .notCovered),
            .init(keyword: "Breast fullness", status: .notCovered),
            .init(keyword: "9 hours", status: .notCovered),
            .init(keyword: "5 hours", status: .notCovered),
            .init(keyword: "Elaichi", status: .notCovered),
            .init(keyword: "Chocolate", status: .notCovered),
            .init(keyword: "Kesar", status: .notCovered),
            .init(keyword: "Uterus", status: .notCovered),
            .init(keyword: "Type 2 Diabetes", status: .notCovered),
            .init(keyword: "Blood Pressure", status: .notCovered),
            .init(keyword: "Heart Disease", status: .notCovered)
        ],
        contentRelevance: "The core product/topic in the delivered video transcript does not match the reference material. The reference expectations focus on \"Galact,\" a product aimed at supporting breastfeeding mothers, while the transcript discusses \"Clarinova,\" which is related to clarithromycin and infections.",
        confidenceScore: 0.394,
        whatWentWell: "The introduction was polite and established a professional tone, which is crucial in sales communication. The speaker clearly stated their name and the company they represent, creating a sense of credibility. The mention of specific products and their components demonstrates knowledge and expertise, which can instill confidence in the listener. However, the delivery could benefit from improved clarity and pacing to ensure the information is easily digestible.",
        improvementsRequired: [
            "Clarity": [
                "0:05 - Clearly articulate the product names and their components.",
                "0:10 - Break down complex terms into simpler language."
            ],
            "Filler Usage": [
                "0:35 - Minimize filler phrases like 'sir'.",
                "0:40 - Avoid unnecessary pauses."
            ],
            "Mood": [
                "0:45 - Create a more positive mood.",
                "0:50 - Use uplifting language."
            ],
            "Pace": [
                "0:55 - Slow down delivery slightly.",
                "1:00 - Use pauses effectively."
            ],
            "Pitch": [
                "0:15 - Use varied pitch for emphasis.",
                "0:20 - Avoid monotone delivery."
            ],
            "Tone": [
                "0:25 - Maintain an enthusiastic tone.",
                "0:30 - Use a warm and inviting tone."
            ]
        ]
    )
}
