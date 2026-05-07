//
//  ManagerEvaluationListDataModel.swift
//  AcuityIQPackage
//

import Foundation
import NetworkService

struct ManagerEvaluationListDataModel {

    // MARK: - Request

    struct GetScenarioAttemptsRequest: EndpointModel {

        struct Payload: Codable {
            let page: Int
            let pageSize: Int
            let users: [Int]?
            var search: String = ""

            func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode(page, forKey: .page)
                try container.encode(pageSize, forKey: .pageSize)
                try container.encodeIfPresent(users, forKey: .users)
                try container.encode(search, forKey: .search)
            }
        }

        let payload: Payload

        var path: String {
            [APIConst.courseBaseUrl, APIConst.versionAPI, APIConst.GetScenarioAttemptsForManager]
                .joined(separator: "/")
        }

        var method: HTTPMethod { .post }
        var headers: [String: String]? { nil }
    }

    // MARK: - Response

    struct ScenarioAttemptsResponse: Codable {
        let data: [ScenarioAttempt]?
        let totalCount: Int?
    }

    // MARK: - ScenarioAttempt

    struct ScenarioAttempt: Codable, Identifiable {
        var id: String { "\(userId ?? 0)_\(scenarioId)" }
        let userId: Int?
        let userName: String?
        let scenarioId: Int
        let scenarioName: String?
        let scenarioDescription: String?
        let scenarioType: String?
        let type: String?
        let attemptDate: String?
        let overallScore: Double?
        let evaluationParameters: [EvaluationParameter]?
        let status: String?
        let managerEvaluationId: Int?
        let lastEvaluationDate: String?
        let lastEvaluationTime: String?
        let newAttempts: Bool?
        let courseId: Int?
        let courseTitle: String?
        let moduleId: Int?
        let allAttempts: [Attempt]?

        // MARK: - Nested Types

        struct EvaluationParameter: Codable {
            let name: String?
            let description: String?
            let weightage: String?
        }

        struct Attempt: Codable, Identifiable {
            let attemptId: Int
            let attemptNumber: Int?
            let score: Double?
            let attemptDate: String?
            let attemptTime: String?
            let evaluationSubmitted: Bool?
            let overallScore: Double?

            var id: Int { attemptId }
        }

        // MARK: - Custom Decoder
        // evaluationParameters arrives as a stringified JSON array — handle both forms.

        private enum CodingKeys: String, CodingKey {
            case userId, userName, scenarioId, scenarioName, scenarioDescription
            case scenarioType, type, attemptDate, overallScore, evaluationParameters
            case status, managerEvaluationId, lastEvaluationDate, lastEvaluationTime
            case newAttempts, courseId, courseTitle, moduleId, allAttempts
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            scenarioId = try container.decode(Int.self, forKey: .scenarioId)
            userId = try container.decodeIfPresent(Int.self, forKey: .userId)
            userName = try container.decodeIfPresent(String.self, forKey: .userName)
            scenarioName = try container.decodeIfPresent(String.self, forKey: .scenarioName)
            scenarioDescription = try container.decodeIfPresent(String.self, forKey: .scenarioDescription)
            scenarioType = try container.decodeIfPresent(String.self, forKey: .scenarioType)
            type = try container.decodeIfPresent(String.self, forKey: .type)
            attemptDate = try container.decodeIfPresent(String.self, forKey: .attemptDate)
            overallScore = try container.decodeIfPresent(Double.self, forKey: .overallScore)
            status = try container.decodeIfPresent(String.self, forKey: .status)
            managerEvaluationId = try container.decodeIfPresent(Int.self, forKey: .managerEvaluationId)
            lastEvaluationDate = try container.decodeIfPresent(String.self, forKey: .lastEvaluationDate)
            lastEvaluationTime = try container.decodeIfPresent(String.self, forKey: .lastEvaluationTime)
            newAttempts = try container.decodeIfPresent(Bool.self, forKey: .newAttempts)
            courseId = try container.decodeIfPresent(Int.self, forKey: .courseId)
            courseTitle = try container.decodeIfPresent(String.self, forKey: .courseTitle)
            moduleId = try container.decodeIfPresent(Int.self, forKey: .moduleId)
            allAttempts = try container.decodeIfPresent([Attempt].self, forKey: .allAttempts)

            // evaluationParameters is a stringified JSON array in this API
            if let raw = try container.decodeIfPresent(String.self, forKey: .evaluationParameters),
               !raw.isEmpty,
               let data = raw.data(using: .utf8) {
                evaluationParameters = try? JSONDecoder().decode([EvaluationParameter].self, from: data)
            } else {
                evaluationParameters = try? container.decodeIfPresent([EvaluationParameter].self, forKey: .evaluationParameters)
            }
        }
    }
}

// MARK: - Computed UI helpers

extension ManagerEvaluationListDataModel.ScenarioAttempt {

    var isSubmitted: Bool {
        status?.lowercased() == "submitted"
    }

    var hasNewAttempts: Bool {
        newAttempts == true
    }

    static func preview(
        scenarioId: Int = 3,
        scenarioName: String = "Clarinova",
        courseTitle: String = "clarinova",
        userName: String = "sahil",
        type: String = "AcuityIQ",
        status: String = "Pending",
        newAttempts: Bool = false
    ) -> Self {
        let json = """
        {
            "scenarioId": \(scenarioId),
            "scenarioName": "\(scenarioName)",
            "courseTitle": "\(courseTitle)",
            "userName": "\(userName)",
            "type": "\(type)",
            "status": "\(status)",
            "newAttempts": \(newAttempts)
        }
        """
        let data = json.data(using: .utf8)!
        return (try? JSONDecoder().decode(Self.self, from: data))!
    }
}
