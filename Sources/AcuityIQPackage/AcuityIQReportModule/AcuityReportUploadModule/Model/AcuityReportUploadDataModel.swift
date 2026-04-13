//
//  AcuityReportUploadDataModel.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 06/04/26.
//

import SwiftUI
import NetworkService
import SwiftUIUtilities

struct AcuityReportUploadDataModel {

    // MARK: - Action Button Model

    struct ActionButton: Identifiable {
        let id = UUID()
        let title: String
        let action: () -> Void
    }

    // MARK: - Preview Item Model

    struct PreviewItem: Identifiable {
        let id = UUID()
        let icon: String
        let title: String
        let action: () -> Void
    }
}

// MARK: - Constants

extension AcuityReportUploadDataModel {

    enum Constants {
        static let maxFileSizeMB: Int = 150
        static let maxFileSizeBytes: Int64 = Int64(maxFileSizeMB) * 1024 * 1024
        static let gradientColors: [Color] = [Color.blue, Color.purple]
    }
}

// MARK: - Static Factory Methods

extension AcuityReportUploadDataModel {

    static func actionButtons(
        onEvaluationCriteria: @escaping () -> Void,
        onKeywords: @escaping () -> Void
    ) -> [ActionButton] {
        [
            ActionButton(title: "Evaluation Criteria", action: onEvaluationCriteria),
            ActionButton(title: "Keywords", action: onKeywords)
        ]
    }

    static func previewItems(
        refVideo: String?,
        onProductKnowledge: @escaping () -> Void,
        onReferenceVideo: @escaping () -> Void
    ) -> [PreviewItem] {
        var model: [PreviewItem] = [PreviewItem(icon: "doc.text.fill", title: "Product Knowledge", action: onProductKnowledge)]
        
        if let refVideo, !refVideo.isEmpty {
            model.append( PreviewItem(icon: "play.circle.fill", title: "Reference Video", action: onReferenceVideo))
        }
        
        return model
    }
}



extension AcuityReportUploadDataModel {
    ///---------------------
    ///-------------------
    // MARK: Post File Upload
    struct PostFileUpload: EndpointModel {
        
        private struct PayLoad: Codable  {
            var CustomerCode: String = AcuityIQAPIManager.shared.getOrgCode
        }
        
        func getPayLoad() throws -> [String: String]? {
            return try PayLoad().toStringDictionary()
        }
        
        var path: String {
            [
                APIConst.courseBaseUrl,
                APIConst.versionAPI,
                APIConst.PostFileUpload
            ].joined(separator: "/")
        }
        
        var method: NetworkService.HTTPMethod { .post }
        
        var headers: [String : String]? { nil }
    }
    
    ///---------------------
    ///-------------------
    // MARK: Post Video Proctoring
    struct PostVideoProctoring: EndpointModel {
        
        struct Payload: Codable {
            let videoURL: String
            let sasToken: String = EnvironmentVariable.SAS_TOKEN
            let organizationID: String = EnvironmentVariable.ORG_ID
            
            enum CodingKeys: String, CodingKey {
                case videoURL       = "video_url"
                case sasToken       = "sas_token"
                case organizationID = "organization_id"
            }
            
            init(videoURL: String) {
                self.videoURL  = videoURL
            }
        }
        
        let videoPath: String
        
        var payload: Payload { Payload(videoURL: videoPath) }
        
        var path: String {
            [
                APIConst.courseBaseUrl,
                APIConst.videoProctoring
            ].joined(separator: "/")
        }
        
        var method: NetworkService.HTTPMethod { .post }
        
        var headers: [String : String]? { nil }
    }
    
    /// Response Model
    struct VideoAnalysisResponse: Codable {
        let response: VideoAnalysisResult?
        let statusCode: Int?

        enum CodingKeys: String, CodingKey {
            case response
            case statusCode = "status_code"
        }
    }

    struct VideoAnalysisResult: Codable {
        let detectedObjects: String?
        let durationSeconds: Double?
        let maxPersonsInFrame: Int?
        let persons: [Person]?
        let status: String?
        let totalPersonsDetected: Int?
        let videoID: String?

        enum CodingKeys: String, CodingKey {
            case detectedObjects      = "detected_objects"
            case durationSeconds      = "duration_seconds"
            case maxPersonsInFrame    = "max_persons_in_frame"
            case persons
            case status
            case totalPersonsDetected = "total_persons_detected"
            case videoID              = "video_id"
        }
    }

    struct Person: Codable {
        let durationVisible: Double?
        let firstSeen: Double?
        let isCheatingSuspected: Bool?
        let lastSeen: Double?
        let metrics: Metrics?
        let overallConfidence: Double?
        let personID: String?
        let riskLevel: String?
        let violations: [Violation]?

        enum CodingKeys: String, CodingKey {
            case durationVisible     = "duration_visible"
            case firstSeen           = "first_seen"
            case isCheatingSuspected = "is_cheating_suspected"
            case lastSeen            = "last_seen"
            case metrics
            case overallConfidence   = "overall_confidence"
            case personID            = "person_id"
            case riskLevel           = "risk_level"
            case violations
        }
    }

    struct Metrics: Codable {
        let avgAttentionScore: Double?
        let gazeViolations: Int?
        let maxAttentionScore: Double?
        let minAttentionScore: Double?
        let objectViolations: Int?
        let totalViolations: Int?

        enum CodingKeys: String, CodingKey {
            case avgAttentionScore = "avg_attention_score"
            case gazeViolations    = "gaze_violations"
            case maxAttentionScore = "max_attention_score"
            case minAttentionScore = "min_attention_score"
            case objectViolations  = "object_violations"
            case totalViolations   = "total_violations"
        }
    }

    struct Violation: Codable {
        let confidence: Double?
        let details: ViolationDetails?
        let gazeDirection: String?
        let timestamp: Double?
        let type: String?

        enum CodingKeys: String, CodingKey {
            case confidence
            case details
            case gazeDirection = "gaze_direction"
            case timestamp
            case type
        }
    }

    struct ViolationDetails: Codable {
        let gazeDeviation: Double?
        let gazeH: Double?
        let gazeV: Double?

        enum CodingKeys: String, CodingKey {
            case gazeDeviation = "gaze_deviation"
            case gazeH         = "gaze_h"
            case gazeV         = "gaze_v"
        }
    }
    

}

//MARK: Evaluate Video Parameter
extension AcuityReportUploadDataModel {
    
    struct EvaluateVideoParameterRequestModel: EndpointModel {
        
        struct ScenarioPayload: Codable {
            let mediaURL: String?
            let parameters: [AcuityIQReportDataModel.Scenario.EvaluationParameter]?
            let knowledgeURL: String?
            let description: String?
            let referenceVideo: String?
            let keywords: [String]?
            let successCriteria: String?
            let contentType: String?

            enum CodingKeys: String, CodingKey {
                case mediaURL        = "media_url"
                case parameters
                case knowledgeURL    = "knowledge_url"
                case description
                case referenceVideo
                case keywords
                case successCriteria = "success_criteria"
                case contentType     = "content_type"
            }
        }
        
        
        let videoPath: String
        let scenario: AcuityIQReportDataModel.Scenario
        var getFullKnowledgePath: String {
            var fullpath = ResourceUtils.getResourcPath(scenario.knowledgeDocument)
            fullpath = fullpath.appending(EnvironmentVariable.SAS_TOKEN)
            return fullpath
        }
        
        var computedVideoPath: String {
            AcuityIQAPIManager.shared.isUAT ? videoPath.appending(EnvironmentVariable.SAS_TOKEN) : videoPath
        }
        
        var getPayload: ScenarioPayload {
            ScenarioPayload(
                mediaURL: computedVideoPath,
                parameters: scenario.evaluationParameters,
                knowledgeURL: getFullKnowledgePath,
                description: scenario.scenarioDescription,
                referenceVideo: scenario.referenceVideo,
                keywords: scenario.keywords,
                successCriteria: scenario.successCriteria,
                contentType: scenario.usageDescription
            )
        }
        
        var path: String {
            [
                APIConst.courseBaseUrl,
                APIConst.evaluateVideoParameter
            ].joined(separator: "/")
        }
        
        var method: NetworkService.HTTPMethod { .post }
        
        var headers: [String : String]? { nil }
    }
    
    // Response Model
    
    struct ScenarioAnalysisResponse: Codable {
        let contentOverall: String?
        let contentRelevance: String?
        let improvementsRequired: [String: [String]]?
        let keywordCoverage: [DetailReportDataModel.KeywordCoverage]?
        let normalizedScore: Double?
        let response: [ParameterScore]?
        let usage: UsageMetrics?
        let whatWentWell: String?

        enum CodingKeys: String, CodingKey {
            case contentOverall      = "content_overall"
            case contentRelevance    = "content_relevance"
            case improvementsRequired = "improvements_required"
            case keywordCoverage     = "keyword_coverage"
            case normalizedScore     = "normalized_score"
            case response
            case usage
            case whatWentWell        = "what_went_well"
        }
    }
    
    struct ParameterScore: Codable {
        let maxScore: Double?
        let parameter: String?
        let remarks: String?
        let score: Double?

        enum CodingKeys: String, CodingKey {
            case maxScore  = "max_score"
            case parameter
            case remarks
            case score
        }
    }
    
    struct UsageMetrics: Codable {
        let llmInputTokens: Int?
        let llmOutputTokens: Int?
        let llmTotalTokens: Int?
        let sttMinutes: Double?

        enum CodingKeys: String, CodingKey {
            case llmInputTokens  = "llm_input_tokens"
            case llmOutputTokens = "llm_output_tokens"
            case llmTotalTokens  = "llm_total_tokens"
            case sttMinutes      = "stt_minutes"
        }
    }


}

//MARK: Post Usage
extension AcuityReportUploadDataModel {

    struct PostUsageRequestModel: EndpointModel {

        struct Payload: Codable {
            let apiQueried: String
            let type: String
            let inputTokens: Int
            let outputTokens: Int
            let contentLength: Int
            let totalToken: Int
            let attemptId: Int
            let sttMinutes: Double
        }

        let payload: Payload

        var path: String {
            [
                APIConst.courseBaseUrl,
                APIConst.versionAPI,
                APIConst.Post_Usage
            ].joined(separator: "/")
        }

        var method: NetworkService.HTTPMethod { .post }

        var headers: [String : String]? { nil }
    }

    struct PostUsageResponse: Codable {
        let success: Bool?
        let message: String?
    }
}

//MARK: Speech Analysis
extension AcuityReportUploadDataModel {

    struct SpeechAnalysisRequestModel: EndpointModel {

        struct Payload: Codable {
            let mediaURL: String

            enum CodingKeys: String, CodingKey {
                case mediaURL = "media_url"
            }
        }

        let videoPath: String
        
        var computedVideoPath: String {
            AcuityIQAPIManager.shared.isUAT ? videoPath.appending(EnvironmentVariable.SAS_TOKEN) : videoPath
        }

        var payload: Payload {
            Payload(mediaURL: computedVideoPath)
        }

        var path: String {
            [
                APIConst.courseBaseUrl,
                APIConst.speechAnalysis
            ].joined(separator: "/")
        }

        var method: NetworkService.HTTPMethod { .post }

        var headers: [String : String]? { nil }
    }

    struct SpeechAnalysisResponse: Codable {
        let duration: String?
        let graphs: [DetailReportDataModel.BehaviourGraph]?
        let overallAverage: Double?

        enum CodingKeys: String, CodingKey {
            case duration
            case graphs
            case overallAverage = "overall_average"
        }
    }
}

//MARK: Speech Insights
extension AcuityReportUploadDataModel {

    struct SpeechInsightsRequestModel: EndpointModel {

        struct Payload: Codable {
            let mediaURL: String
            let normalizedScore: Double
            let overallAverage: Double
            let contentRelevance: String
            let contentOverall: String
            let confidenceScore: Double

            enum CodingKeys: String, CodingKey {
                case mediaURL         = "media_url"
                case normalizedScore  = "normalized_score"
                case overallAverage   = "overall_average"
                case contentRelevance = "content_relevance"
                case contentOverall   = "content_overall"
                case confidenceScore
            }
        }

        let videoPath: String
        let scenarioResponse: ScenarioAnalysisResponse
        let speechAnalysisResponse: SpeechAnalysisResponse
        
        var computedVideoPath: String {
            AcuityIQAPIManager.shared.isUAT ? videoPath.appending(EnvironmentVariable.SAS_TOKEN) : videoPath
        }


        var payload: Payload {
            Payload(
                mediaURL: computedVideoPath,
                normalizedScore: scenarioResponse.normalizedScore ?? 0.0,
                overallAverage: speechAnalysisResponse.overallAverage ?? 0.0,
                contentRelevance: scenarioResponse.contentRelevance ?? "",
                contentOverall: scenarioResponse.contentOverall ?? "",
                confidenceScore: 0.0
            )
        }

        var path: String {
            [
                APIConst.courseBaseUrl,
                APIConst.speechInsights
            ].joined(separator: "/")
        }

        var method: NetworkService.HTTPMethod { .post }

        var headers: [String : String]? { nil }
    }

    struct SpeechInsightsResponse: Codable {
        let insights: [InsightSection]?
        let overview: InsightOverview?
        let usage: UsageMetrics?
    }

    struct InsightSection: Codable, Identifiable {
        var id: String { name }
        let name: String
        let color: String?
        let score: Double?
        let strengths: [String]?
        let improvements: [String]?
        let errors: [String]?
    }

    struct InsightOverview: Codable {
        let confidenceScore: Double?
        let overallCriticalErrors: [String]?
        let overallImprovements: [String]?
        let overallScore: Double?
        let overallStrengths: [String]?
        let summary: String?

        enum CodingKeys: String, CodingKey {
            case confidenceScore       = "confidencescore"
            case overallCriticalErrors = "overall_criticalerrors"
            case overallImprovements   = "overall_improvements"
            case overallScore          = "overall_score"
            case overallStrengths      = "overall_strengths"
            case summary
        }
    }
}

// MARK: - Post Analysis
extension AcuityReportUploadDataModel {

    struct PostAnalysisRequestModel: EndpointModel {

        struct Payload: Codable {
            let sections: [AnalysisSection]
            let strengths: [String]
            let improvements: [String]
            let criticals: [String]
            let overallScore: Double
            let duration: String
            let summary: String
            let evaluationCriteria: [EvaluationCriteriaItem]
            let behaviourGraphs: [DetailReportDataModel.BehaviourGraph]
            let videoPath: String
            let keywordCoverage: String
            let contentRelevance: String
            let confidenceScore: Double
            let improvementsRequired: [String: [String]]
            let whatWentWell: String
            let scenarioId: Int
            let moduleId: Int?
            let courseId: Int?
            let moduleAttemptId: Int?
        }

        struct AnalysisSection: Codable {
            let color: String?
            let errors: [String]
            let improvements: [String]
            let name: String
            let score: Double
            let strengths: [String]
        }

        struct EvaluationCriteriaItem: Codable {
            let maxScore: Double
            let parameter: String
            let remarks: String
            let score: Double

            enum CodingKeys: String, CodingKey {
                case maxScore = "max_score"
                case parameter
                case remarks
                case score
            }
        }

        let scenarioResponse: ScenarioAnalysisResponse
        let speechAnalysisResponse: SpeechAnalysisResponse
        let speechInsightsResponse: SpeechInsightsResponse
        let videoPath: String
        let scenarioId: Int
        let moduleId: Int?
        let courseId: Int?
        let moduleAttemptId: Int?

        var payload: Payload {
            // Build sections from insights
            let sections: [AnalysisSection] = speechInsightsResponse.insights?.map { insight in
                AnalysisSection(
                    color: insight.color,
                    errors: insight.errors ?? [],
                    improvements: insight.improvements ?? [],
                    name: insight.name,
                    score: insight.score ?? 0,
                    strengths: insight.strengths ?? []
                )
            } ?? []

            // Build evaluation criteria from scenario response
            let evaluationCriteria: [EvaluationCriteriaItem] = scenarioResponse.response?.map { param in
                EvaluationCriteriaItem(
                    maxScore: param.maxScore ?? 10,
                    parameter: param.parameter ?? "",
                    remarks: param.remarks ?? "",
                    score: param.score ?? 0
                )
            } ?? []

            // Use behaviour graphs directly from speech analysis response
            let behaviourGraphs = speechAnalysisResponse.graphs ?? []

            // Convert keyword coverage to JSON string
            let keywordCoverageString: String
            if let keywordCoverage = scenarioResponse.keywordCoverage,
               let jsonData = try? JSONEncoder().encode(keywordCoverage),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                keywordCoverageString = jsonString
            } else {
                keywordCoverageString = "[]"
            }

            return Payload(
                sections: sections,
                strengths: speechInsightsResponse.overview?.overallStrengths ?? [],
                improvements: speechInsightsResponse.overview?.overallImprovements ?? [],
                criticals: speechInsightsResponse.overview?.overallCriticalErrors ?? [],
                overallScore: speechInsightsResponse.overview?.overallScore ?? 0,
                duration: speechAnalysisResponse.duration ?? "",
                summary: speechInsightsResponse.overview?.summary ?? "",
                evaluationCriteria: evaluationCriteria,
                behaviourGraphs: behaviourGraphs,
                videoPath: videoPath,
                keywordCoverage: keywordCoverageString,
                contentRelevance: scenarioResponse.contentRelevance ?? "",
                confidenceScore: speechInsightsResponse.overview?.confidenceScore ?? 0,
                improvementsRequired: scenarioResponse.improvementsRequired ?? [:],
                whatWentWell: scenarioResponse.whatWentWell ?? "",
                scenarioId: scenarioId,
                moduleId: moduleId,
                courseId: courseId,
                moduleAttemptId: moduleAttemptId
            )
        }

        var path: String {
            [
                APIConst.courseBaseUrl,
                APIConst.versionAPI,
                APIConst.PostAnalysis
            ].joined(separator: "/")
        }

        var method: NetworkService.HTTPMethod { .post }

        var headers: [String : String]? { nil }
    }

    struct PostAnalysisResponse: Codable {
        let attemptId: Int?
        let message: String?
    }
}

// MARK: - Mark Module Attempt
extension AcuityReportUploadDataModel {

    struct MarkModuleAttemptRequestModel: EndpointModel {

        struct Payload: Codable {
            let projectId: Int
            let courseId: Int
            let moduleId: Int
            let isNewAttempt: Bool
        }

        let payload: Payload

        var path: String {
            [
                APIConst.courseBaseUrl,
                APIConst.versionAPI,
                APIConst.MarkModuleAttempt
            ].joined(separator: "/")
        }

        var method: NetworkService.HTTPMethod { .post }

        var headers: [String : String]? { nil }
    }
}

// MARK: - Preview Data

#if DEBUG
extension AcuityReportUploadDataModel {

    static var previewScenario: AcuityIQReportDataModel.Scenario {
        AcuityIQReportDataModel.Scenario(
            scenarioId: 1,
            scenarioName: "Test Scenario",
            scenarioDescription: "A structured session where the candidate introduces a product or service, highlights its value, and engages the target audience to create interest or move toward a sale.",
            evaluationParameters: [
                .init(name: "Clarity", description: "How clearly ideas are communicated", weightage: "20"),
                .init(name: "Content Relevance", description: "Alignment with intended purpose", weightage: "20")
            ],
            knowledgeDocument: "/enth/application/pdf/sample.pdf",
            referenceVideo: "/enth/video/sample.mp4",
            keywords: ["keyword1", "keyword2"],
            maximumAttempts: 10,
            pendingAttempts: 5
        )
    }
}
#endif
