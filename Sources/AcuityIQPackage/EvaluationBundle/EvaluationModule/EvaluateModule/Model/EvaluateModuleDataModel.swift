//
//  EvaluateModuleDataModel.swift
//  AcuityIQPackage
//

import Foundation
import NetworkService

struct EvaluateModuleDataModel {

    // MARK: - Request

    struct PostManagerEvaluationRequest: EndpointModel {

        struct Payload: Codable {
            let attemptId: Int
            let evaluationData: [EvaluationEntry]
            let scenarioType: String
            let overallScore: Double
        }

        struct EvaluationEntry: Codable {
            let parameter: String
            let score: Double
            let remarks: String
        }

        let payload: Payload

        var path: String {
            [APIConst.courseBaseUrl, APIConst.versionAPI, APIConst.PostManagerEvaluation]
                .joined(separator: "/")
        }
        var method: HTTPMethod { .post }
        var headers: [String: String]? { nil }
    }

    // MARK: - Response

    struct PostManagerEvaluationResponse: Codable {
        let evaluationId: Int?
    }

    // MARK: - Form State

    struct EvaluationFormEntry: Identifiable {
        let id: UUID
        let parameter: String
        let maxScore: Int
        var scoreText: String
        var remarks: String

        init(parameter: String, maxScore: Int) {
            self.id = UUID()
            self.parameter = parameter
            self.maxScore = maxScore
            self.scoreText = ""
            self.remarks = ""
        }
    }
}
