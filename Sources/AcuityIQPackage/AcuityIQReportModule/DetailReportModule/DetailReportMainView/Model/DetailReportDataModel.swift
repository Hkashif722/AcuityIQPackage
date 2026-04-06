//
//  File.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 31/03/26.
//

import SwiftUI
import SwiftUIUtilities
import NetworkService

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

        var requiresScenarioData: Bool {
            switch self {
            case .overview, .breakdown, .keywordsCoverage, .evaluationCriteria, .behavioralAnalysis:
                return true
            case .allAttempts, .leaderboard:
                return false
            }
        }
    }
}


//MARK: Request Model
extension DetailReportDataModel {

    struct GetScenarioAnalysisRequestModel: EndpointModel {
        
        let attemptID: Int

        var path: String {
            [
                APIConst.courseBaseUrl,
                APIConst.versionAPI,
                APIConst.GetScenarioAnalysis,
                "\(attemptID)"
            ].joined(separator: "/")
        }

        var method: NetworkService.HTTPMethod { .get }

        var headers: [String : String]? { nil }
    }
    
    
    
}


//MARK: Response Model
extension  DetailReportDataModel {
    
    // MARK: - Root Response

    struct ScenarioAttemptResponse: Codable {
        let scenarioType: String?
        let scenarioId: Int?
        let courseId: Int?
        let moduleId: Int?
        let moduleAttemptId: Int?
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
        let contentRelevance: String?
        let confidenceScore: Double?
        let whatWentWell: String?
        let improvementsRequired: [String: [String]]?
        let screenCaptureImages: [String]?
        let keywordCoverage: [KeywordCoverage]?

        enum CodingKeys: String, CodingKey {
            case scenarioType, scenarioId, courseId, moduleId, moduleAttemptId
            case userId, attemptNumber, strengths, improvements, criticals
            case overallScore, overallAttempts, duration, summary
            case behaviourGraphs, sections, evaluationCriteria, videoPath
            case contentRelevance, confidenceScore, whatWentWell
            case improvementsRequired, screenCaptureImages, keywordCoverage
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            scenarioType = try container.decodeIfPresent(String.self, forKey: .scenarioType)
            scenarioId = try container.decodeIfPresent(Int.self, forKey: .scenarioId)
            courseId = try container.decodeIfPresent(Int.self, forKey: .courseId)
            moduleId = try container.decodeIfPresent(Int.self, forKey: .moduleId)
            moduleAttemptId = try container.decodeIfPresent(Int.self, forKey: .moduleAttemptId)
            userId = try container.decodeIfPresent(Int.self, forKey: .userId)
            attemptNumber = try container.decodeIfPresent(Int.self, forKey: .attemptNumber)
            strengths = try container.decodeIfPresent([String].self, forKey: .strengths)
            improvements = try container.decodeIfPresent([String].self, forKey: .improvements)
            criticals = try container.decodeIfPresent([String].self, forKey: .criticals)
            overallScore = try container.decodeIfPresent(Double.self, forKey: .overallScore)
            overallAttempts = try container.decodeIfPresent(Int.self, forKey: .overallAttempts)
            duration = try container.decodeIfPresent(String.self, forKey: .duration)
            summary = try container.decodeIfPresent(String.self, forKey: .summary)
            behaviourGraphs = try container.decodeIfPresent([BehaviourGraph].self, forKey: .behaviourGraphs)
            sections = try container.decodeIfPresent([SectionEvaluation].self, forKey: .sections)
            evaluationCriteria = try container.decodeIfPresent([EvaluationCriteria].self, forKey: .evaluationCriteria)
            videoPath = try container.decodeIfPresent(String.self, forKey: .videoPath)
            contentRelevance = try container.decodeIfPresent(String.self, forKey: .contentRelevance)
            confidenceScore = try container.decodeIfPresent(Double.self, forKey: .confidenceScore)
            whatWentWell = try container.decodeIfPresent(String.self, forKey: .whatWentWell)
            improvementsRequired = try container.decodeIfPresent([String: [String]].self, forKey: .improvementsRequired)
            screenCaptureImages = try container.decodeIfPresent([String].self, forKey: .screenCaptureImages)

            // keywordCoverage comes as a JSON-encoded string from the API
            if let jsonString = try container.decodeIfPresent(String.self, forKey: .keywordCoverage),
               let data = jsonString.data(using: .utf8) {
                keywordCoverage = try? JSONDecoder().decode([KeywordCoverage].self, from: data)
            } else {
                keywordCoverage = nil
            }
        }

        // Memberwise initializer for preview/testing purposes
        init(
            scenarioType: String? = nil,
            scenarioId: Int? = nil,
            courseId: Int? = nil,
            moduleId: Int? = nil,
            moduleAttemptId: Int? = nil,
            userId: Int? = nil,
            attemptNumber: Int? = nil,
            strengths: [String]? = nil,
            improvements: [String]? = nil,
            criticals: [String]? = nil,
            overallScore: Double? = nil,
            overallAttempts: Int? = nil,
            duration: String? = nil,
            summary: String? = nil,
            behaviourGraphs: [BehaviourGraph]? = nil,
            sections: [SectionEvaluation]? = nil,
            evaluationCriteria: [EvaluationCriteria]? = nil,
            videoPath: String? = nil,
            keywordCoverage: [KeywordCoverage]? = nil,
            contentRelevance: String? = nil,
            confidenceScore: Double? = nil,
            whatWentWell: String? = nil,
            improvementsRequired: [String: [String]]? = nil,
            screenCaptureImages: [String]? = nil
        ) {
            self.scenarioType = scenarioType
            self.scenarioId = scenarioId
            self.courseId = courseId
            self.moduleId = moduleId
            self.moduleAttemptId = moduleAttemptId
            self.userId = userId
            self.attemptNumber = attemptNumber
            self.strengths = strengths
            self.improvements = improvements
            self.criticals = criticals
            self.overallScore = overallScore
            self.overallAttempts = overallAttempts
            self.duration = duration
            self.summary = summary
            self.behaviourGraphs = behaviourGraphs
            self.sections = sections
            self.evaluationCriteria = evaluationCriteria
            self.videoPath = videoPath
            self.keywordCoverage = keywordCoverage
            self.contentRelevance = contentRelevance
            self.confidenceScore = confidenceScore
            self.whatWentWell = whatWentWell
            self.improvementsRequired = improvementsRequired
            self.screenCaptureImages = screenCaptureImages
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
