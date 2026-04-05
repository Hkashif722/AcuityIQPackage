//
//  LeaderboardDataModel.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 05/04/26.
//

import SwiftUI
import SwiftUIUtilities

struct LeaderboardDataModel {
    
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
        
        enum CodingKeys: String, CodingKey {
            case attemptId, userId, userName, profilePicture, attemptNumber, attemptsUsed, totalAttempts
            case strengths, improvements, criticals, overallScore, overallAttempts
            case behaviourGraphs, sections, evaluationCriteria, videoPath, keywordCoverage
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            attemptId = try container.decode(Int.self, forKey: .attemptId)
            userId = try container.decodeIfPresent(Int.self, forKey: .userId)
            userName = try container.decodeIfPresent(String.self, forKey: .userName)
            profilePicture = try container.decodeIfPresent(String.self, forKey: .profilePicture)
            attemptNumber = try container.decodeIfPresent(Int.self, forKey: .attemptNumber)
            attemptsUsed = try container.decodeIfPresent(Int.self, forKey: .attemptsUsed)
            totalAttempts = try container.decodeIfPresent(Int.self, forKey: .totalAttempts)
            strengths = try container.decodeIfPresent([String].self, forKey: .strengths)
            improvements = try container.decodeIfPresent([String].self, forKey: .improvements)
            criticals = try container.decodeIfPresent([String].self, forKey: .criticals)
            overallScore = try container.decodeIfPresent(Double.self, forKey: .overallScore)
            overallAttempts = try container.decodeIfPresent(Int.self, forKey: .overallAttempts)
            behaviourGraphs = try container.decodeIfPresent([BehaviourGraph].self, forKey: .behaviourGraphs)
            sections = try container.decodeIfPresent([Section].self, forKey: .sections)
            evaluationCriteria = try container.decodeIfPresent([EvaluationCriteria].self, forKey: .evaluationCriteria)
            videoPath = try container.decodeIfPresent(String.self, forKey: .videoPath)
            
            if let jsonStr = try container.decodeIfPresent(String.self, forKey: .keywordCoverage),
               let jsonData = jsonStr.data(using: .utf8) {
                keywordCoverage = try? JSONDecoder().decode([KeywordCoverage].self, from: jsonData)
            } else {
                keywordCoverage = nil
            }
        }
        
        init(attemptId: Int, userId: Int? = nil, userName: String? = nil, profilePicture: String? = nil,
             attemptNumber: Int? = nil, attemptsUsed: Int? = nil, totalAttempts: Int? = nil,
             strengths: [String]? = nil, improvements: [String]? = nil, criticals: [String]? = nil,
             overallScore: Double? = nil, overallAttempts: Int? = nil, behaviourGraphs: [BehaviourGraph]? = nil,
             sections: [Section]? = nil, evaluationCriteria: [EvaluationCriteria]? = nil,
             videoPath: String? = nil, keywordCoverage: [KeywordCoverage]? = nil) {
            self.attemptId = attemptId
            self.userId = userId
            self.userName = userName
            self.profilePicture = profilePicture
            self.attemptNumber = attemptNumber
            self.attemptsUsed = attemptsUsed
            self.totalAttempts = totalAttempts
            self.strengths = strengths
            self.improvements = improvements
            self.criticals = criticals
            self.overallScore = overallScore
            self.overallAttempts = overallAttempts
            self.behaviourGraphs = behaviourGraphs
            self.sections = sections
            self.evaluationCriteria = evaluationCriteria
            self.videoPath = videoPath
            self.keywordCoverage = keywordCoverage
        }
    }
    
    struct KeywordCoverage: Codable, Identifiable {
        var id: String { keyword ?? UUID().uuidString }
        let keyword: String?
        let status: String?
        var isCovered: Bool { status?.lowercased() == "covered" }
    }
}

// MARK: - Computed Helpers

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
}

extension LeaderboardDataModel.LeaderboardAttempt {
    
    static var leaderBoardHeaderGradientStop: [Gradient.Stop] {
        [
            Gradient.Stop(color: Color(hex: "5B6AFA"), location: 0.0),
            Gradient.Stop(color: Color(hex: "7B8AFE"), location: 0.5),
            Gradient.Stop(color: Color(hex: "9B8AFF"), location: 1.0)
        ]
    }
}

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
                    .init(name: "Clarity", average: 6.7,  data: [0.0, 6.8, 6.6, 6.6], labels: ["00:00", "00:30", "01:00", "01:15"], color: "rgb(59, 130, 246)", feedback: "Your clarity supported the interaction adequately, with room for refinement."),
                    .init(name: "Filler Usage", average: 6.1,  data: [0.0, 4.4, 7.8, 6.2], labels: ["00:00", "00:30", "01:00", "01:15"], color: "rgb(236, 72, 153)", feedback: "As the conversation progressed, reducing filler words can improve fluency."),
                    .init(name: "Mood", average: 5.6,  data: [0.0, 5.6, 5.6, 5.6], labels: ["00:00", "00:30", "01:00", "01:15"], color: "rgb(245, 158, 11)", feedback: "In the closing moments, expressive delivery can enhance engagement."),
                    .init(name: "Pitch", average: 3.9,  data: [0.0, 3.8, 3.9, 3.9], labels: ["00:00", "00:30", "01:00", "01:15"], color: "rgb(139, 92, 246)", feedback: "At the beginning of the conversation, greater pitch variation can improve engagement."),
                    .init(name: "Pace", average: 6.0,  data: [0.0, 7.5, 6.1, 4.5], labels: ["00:00", "00:30", "01:00", "01:15"], color: "rgb(16, 185, 129)", feedback: "Overall, pace was acceptable, though minor adjustments could strengthen communication."),
                    .init(name: "Tone", average: 5.2,  data: [0.0, 5.3, 5.2, 5.2], labels: ["00:00", "00:30", "01:00", "01:15"], color: "rgb(14, 165, 233)", feedback: "The tone showed noticeable inconsistency and needs improvement.")
                ],
                sections: [
                    .init(name: "Beginning", score: 0.8, color: "red", strengths: [], improvements: ["The user should ensure they are discussing the correct product, aligning with the reference material about clarinovatab."], errors: ["The video uploaded was not relevant to the reference material."]),
                    .init(name: "Middle", score: 1.4, color: "red", strengths: [], improvements: ["At 00:00, the user should ensure they are discussing the correct product, aligning with the reference material about clarinovatab.", "At 00:15, the user could incorporate specific details about clarinovatab's indications, dosages, and pricing to enhance relevance.", "At 00:30, the user should focus on the competitive advantages of clarinovatab over other brands, as highlighted in the reference material."], errors: ["The video uploaded was not relevant to the reference material."]),
                    .init(name: "End", score: 1.8, color: "red", strengths: [], improvements: ["At 00:18, the user should ensure they are discussing the correct product, aligning with the reference material about clarinovatab.", "At 00:19, the user could incorporate specific details about clarinovatab's indications, dosages, and pricing to enhance relevance.", "At 00:20, the user should focus on the competitive advantages of clarinovatab over other brands, as highlighted in the reference material."], errors: ["The video uploaded was not relevant to the reference material."])
                ],
                evaluationCriteria: [
                    .init(parameter: "Clarity", remarks: "The communication lacks clarity, with some phrases being convoluted and difficult to follow.", score: 1.9),
                    .init(parameter: "Content Relevance", remarks: "The content is somewhat relevant but diverges into details that may not directly address customer concerns.", score: 1.8),
                    .init(parameter: "Structure & Organization", remarks: "The structure is disorganized, making it hard to track the main points being presented.", score: 1.6),
                    .init(parameter: "Intent Clarity", remarks: "The intent is not clearly articulated, leading to confusion about the primary message.", score: 1.6),
                    .init(parameter: "Confidence & Presence", remarks: "The delivery lacks confidence, which diminishes the overall impact of the message.", score: 0.2)
                ],
                videoPath: "https://uat.gogetempowered.com/org-content/uatempworedcontent/enth/video/mp4/639108205421805725639093591349777061TELMIKINDCT.mp4",
                keywordCoverage: [
                    .init(keyword: "test22", status: "Not Covered"),
                    .init(keyword: "test", status: "Not Covered")
                ]
            ),
            
            // Empty state
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
    static var previewConfidence: LeaderboardDataModel.LeaderboardAttempt.BehaviourGraph  {
        .init(name: "Confidence", average: 8.4,  data: [6.5, 7.2, 8.0, 8.8, 9.1, 8.5, 8.4], labels: ["Start", "0:30", "1:00", "1:30", "2:00", "2:30", "End"], color: "rgb(91, 106, 250)", feedback: "Confidence grew steadily.")
    }
}

extension LeaderboardDataModel.LeaderboardAttempt.Section {
    static var previewIntro: LeaderboardDataModel.LeaderboardAttempt.Section {
        .init(name: "Introduction", score: 9.0, color: "rgb(46, 204, 113)", strengths: ["Strong hook"], improvements: ["Be concise"], errors: [])
    }
}
#endif
