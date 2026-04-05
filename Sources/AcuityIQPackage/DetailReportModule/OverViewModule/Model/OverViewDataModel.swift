//
//  OverallModel.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 31/03/26.
//

import Foundation

struct OverallModel {

    // MARK: - Root Response

    struct ScenarioAttemptResponse: Codable {
        let scenarioId: Int?
        let userId: Int?
        let attemptNumber: Int?
        let strengths: [String]?
        let improvements: [String]?
        let criticals: [String]?
        let overallScore: Double?
        let overallAttempts: Int?
        let duration: String?
        let summary: String?
        let behaviourGraphs: [BehaviourGraph]?
        let sections: [SectionEvaluation]?
        let evaluationCriteria: [EvaluationCriteria]?
        let videoPath: String?
        let keywordCoverage: String?
        let contentRelevance: String?
        let confidenceScore: Double?
        let whatWentWell: String?
        let improvementsRequired: [String: String]?

        /// Parses the raw `keywordCoverage` JSON string into typed models.
        var decodedKeywordCoverage: [KeywordCoverage] {
            guard
                let raw = keywordCoverage,
                let data = raw.data(using: .utf8)
            else { return [] }
            return (try? JSONDecoder().decode([KeywordCoverage].self, from: data)) ?? []
        }
    }

    // MARK: - Behaviour Graph

    struct BehaviourGraph: Codable, Identifiable {
        var id: String { name }
        let name: String            // id key — non-optional
        let average: Double?
        let data: [Double]?
        let labels: [String]?
        let color: String?
        let feedback: String?
    }

    // MARK: - Section Evaluation

    struct SectionEvaluation: Codable, Identifiable {
        var id: String { name }
        let name: String            // id key — non-optional
        let score: Double?
        let color: String?
        let strengths: [String]?
        let improvements: [String]?
        let errors: [String]?
    }

    // MARK: - Evaluation Criteria

    struct EvaluationCriteria: Codable, Identifiable {
        var id: String { parameter }
        let parameter: String       // id key — non-optional
        let remarks: String?
        let score: Double?
    }

    // MARK: - Keyword Coverage

    struct KeywordCoverage: Codable, Identifiable {
        var id: String { keyword }
        let keyword: String         // id key — non-optional
        let status: KeywordStatus?
    }

    // MARK: - Keyword Status

    enum KeywordStatus: String, Codable {
        case covered    = "Covered"
        case notCovered = "Not Covered"
    }
}

extension OverallModel.ScenarioAttemptResponse {

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
        overallScore: 1.8,
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
        keywordCoverage: """
        [{"keyword":"Breastfeeding","status":"Not Covered"},{"keyword":"Breast Milk Supply","status":"Not Covered"},{"keyword":"C section","status":"Not Covered"},{"keyword":"Pre-term","status":"Not Covered"},{"keyword":"Lactation insufficiency","status":"Not Covered"},{"keyword":"Postpartum recovery","status":"Not Covered"},{"keyword":"Galact","status":"Not Covered"},{"keyword":"Empower","status":"Not Covered"},{"keyword":"Prolactin","status":"Not Covered"},{"keyword":"39%","status":"Not Covered"},{"keyword":"Breast fullness","status":"Not Covered"},{"keyword":"9 hours","status":"Not Covered"},{"keyword":"5 hours","status":"Not Covered"},{"keyword":"Elaichi","status":"Not Covered"},{"keyword":"Chocolate","status":"Not Covered"},{"keyword":"Kesar","status":"Not Covered"},{"keyword":"Uterus","status":"Not Covered"},{"keyword":"Type 2 Diabetes","status":"Not Covered"},{"keyword":"Blood Pressure","status":"Not Covered"},{"keyword":"Heart Disease","status":"Not Covered"}]
        """,
        contentRelevance: "The core product/topic in the delivered video transcript does not match the reference material. The reference expectations focus on \"Galact,\" a product aimed at supporting breastfeeding mothers, while the transcript discusses \"Clarinova,\" which is related to clarithromycin and infections.",
        confidenceScore: 0.394,
        whatWentWell: nil,
        improvementsRequired: [:]
    )
}
