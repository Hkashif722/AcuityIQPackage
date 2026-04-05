//
//  File.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 31/03/26.
//

import SwiftUI
import SwiftUIUtilities

struct DetailReportDataModel {
    // MARK: - Model
    
    enum AnalyticsTab: String, CaseIterable, SegmentItemRepresentable {
        case overview
        case breakdown
        case keywordsCoverage
        case evaluationCriteria
        case behavioralAnalysis
        case allAttempts
        case leaderboard

        var id: String { rawValue }

        var menuTitle: String {
            switch self {
            case .overview:           return "Overview"
            case .breakdown:          return "Breakdown"
            case .keywordsCoverage:   return "Keywords Coverage"
            case .evaluationCriteria: return "Evaluation Criteria"
            case .behavioralAnalysis: return "Behavioral Analysis"
            case .allAttempts:        return "All Attempts"
            case .leaderboard:        return "Leaderboard"
            }
        }

        var icon: SegmentIconType {
            switch self {
            case .overview:           return .system(name: "chart.bar.fill")
            case .breakdown:          return .system(name: "arrow.branch")
            case .keywordsCoverage:   return .system(name: "doc.text.fill")
            case .evaluationCriteria: return .system(name: "checklist")
            case .behavioralAnalysis: return .system(name: "brain")
            case .allAttempts:        return .system(name: "chart.line.uptrend.xyaxis")
            case .leaderboard:        return .system(name: "trophy.fill")
            }
        }

        var selectedColor: Color { Color.blue.opacity(0.12) }
        var unSelectedColor: Color { Color(.systemGray6) }
    }
}


extension  DetailReportDataModel {
    
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
        let keywordCoverage: [KeywordCoverage]?
        let contentRelevance: String?
        let confidenceScore: Double?
        let whatWentWell: String?
        let improvementsRequired: [String: [String]]?

//        /// Parses the raw `keywordCoverage` JSON string into typed models.
//        var decodedKeywordCoverage: [KeywordCoverage] {
//            guard
//                let raw = keywordCoverage,
//                let data = raw.data(using: .utf8)
//            else { return [] }
//            return (try? JSONDecoder().decode([KeywordCoverage].self, from: data)) ?? []
//        }
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
        
        var color: Color {
            switch self {
            case .covered:
                return ColorUtility.mintGreen
            case .notCovered:
                return Color(hex: "#c34133")
            }
        }
    }
    
    
}
