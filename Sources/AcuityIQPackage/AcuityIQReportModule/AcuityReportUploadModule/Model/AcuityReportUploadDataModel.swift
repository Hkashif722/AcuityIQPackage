//
//  AcuityReportUploadDataModel.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 06/04/26.
//

import SwiftUI
import NetworkService

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
        
        var getPayload: ScenarioPayload {
            ScenarioPayload(mediaURL: videoPath.appending(EnvironmentVariable.SAS_TOKEN), parameters: scenario.evaluationParameters, knowledgeURL: scenario.knowledgeDocument, description: scenario.scenarioDescription, referenceVideo: scenario.referenceVideo, keywords: scenario.keywords, successCriteria: scenario.successCriteria, contentType: scenario.usageDescription)
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
        let sttMinutes: Int?

        enum CodingKeys: String, CodingKey {
            case llmInputTokens  = "llm_input_tokens"
            case llmOutputTokens = "llm_output_tokens"
            case llmTotalTokens  = "llm_total_tokens"
            case sttMinutes      = "stt_minutes"
        }
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
