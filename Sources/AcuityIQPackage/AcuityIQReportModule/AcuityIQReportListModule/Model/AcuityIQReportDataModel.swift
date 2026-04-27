//
//  AcuityIQReportDataModel.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 05/04/26.
//

import SwiftUI
import NetworkService


struct AcuityIQReportDataModel {
    
    struct GetUserScenarioRequestModel: EndpointModel {
        
        var path: String {
            [
                APIConst.courseBaseUrl,
                APIConst.versionAPI,
                APIConst.GetScenariosForUser
            ].joined(separator: "/")
        }
        
        var method: NetworkService.HTTPMethod { .get }
        
        var headers: [String : String]? { nil }
    }
}


// MARK: Response Model
extension AcuityIQReportDataModel {
    /// Represents a single scenario from the API response.
    /// Note: The root API response is an array: `[Scenario]`
    struct Scenario: Codable, Identifiable {
        let scenarioId: Int
        let scenarioName: String?
        let scenarioDescription: String?
        let evaluationParameters: [EvaluationParameter]?
        let knowledgeDocument: String?
        let referenceVideo: String?
        let open: Bool?
        let isManagerEvaluation: Bool?
        let attempts: [Attempt]?
        let keywords: [String]?
        let maximumAttempts: Int?
        let pendingAttempts: Int?
        let scenarioType: String?
        let successCriteria: String?
        let usageType: String?
        let customUsageType: String?
        let usageDescription: String?

        var id: Int { scenarioId }
        
        // MARK: - Nested Models

        struct EvaluationParameter: Codable {
            let name: String?
            let description: String?
            let weightage: String?
        }

        struct Attempt: Codable, Identifiable {
            let attemptId: Int
            let attemptNumber: Int?
            let userId: Int?
            let userName: String?
            let score: Double?
            let attemptDate: String?
            let managerEvaluation: ManagerEvaluation?

            var id: Int { attemptId }
        }

        // MARK: - ManagerEvaluation

        struct ManagerEvaluation: Codable {
            let id: Int?
            let date: String?
            let time: String?
            let overallScore: Double?
            let parameters: [ManagerEvaluationParameter]?

            // MARK: - Computed

            var totalScore: Double {
                let scores = parameters?.compactMap { $0.score } ?? []
                guard !scores.isEmpty else { return 0 }
                return scores.reduce(0, +) / Double(scores.count)
            }

            var totalScoreFormatted: String {
                "\(Int(totalScore.rounded()))/10"
            }

            var parameterCount: Int {
                parameters?.count ?? 0
            }

            var scoredCount: Int {
                parameters?.filter { ($0.score ?? 0) > 0 }.count ?? 0
            }

           
            var scoreLabel: ScoreLabel {
                switch totalScore {
                case 8...:   return .good
                case 5..<8:  return .average
                default:     return .low
                }
            }

            var overAllScoreLabel: ScoreLabel {
                switch overallScore ?? 0 {
                case 8...:   return .good
                case 5..<8:  return .average
                default:     return .low
                }
            }

            // MARK: - ScoreLabel

            enum ScoreLabel: String {
                case good    = "Good"
                case average = "Average"
                case low     = "Low"

                /// Text / number color — badge label, score ring number, scored count
                var foregroundColor: Color {
                    switch self {
                    case .good:    return Color(hex: "#059669")  // green-700  — mgr-chip-good
                    case .average: return Color(hex: "#b45309")  // amber-700  — mgr-chip-avg
                    case .low:     return Color(hex: "#dc2626")  // red-600    — mgr-chip-low
                    }
                }

                /// Soft tinted fill — card background, badge background
                var backgroundColor: Color {
                    switch self {
                    case .good:    return Color(hex: "#ecfdf5")  // green-50
                    case .average: return Color(hex: "#fffbeb")  // amber-50
                    case .low:     return Color(hex: "#fef2f2")  // red-50
                    }
                }

                /// Vivid stroke — ring progress, border, progress bar fill
                var borderColor: Color {
                    switch self {
                    case .good:    return Color(hex: "#10b981")  // green-500
                    case .average: return Color(hex: "#f59e0b")  // amber-400
                    case .low:     return Color(hex: "#dc2626")  // red-600
                    }
                }

                var ringColor: Color { borderColor }

                var icon: String { "person.circle" }  // fa-user-circle-o
            }
        }

        // MARK: - ManagerEvaluationParameter

        struct ManagerEvaluationParameter: Codable {
            let parameter: String?
            let score: Double?
            let remarks: String?
            let totalWeightage: String?
            
            // MARK: - Computed
            
            var effectiveMax: Int {
                Int(totalWeightage ?? "20") ?? 20
            }
            
            var scoreFormatted: String {
                "\(Int(score ?? 0))/20"
            }
            
            var progress: Double {
                min((score ?? 0) / 20.0, 1.0)
            }
            
            
            private var scoreLabel: ManagerEvaluation.ScoreLabel {
                let normalized = (score ?? 0) / Double(effectiveMax)
                switch normalized {
                case 0.8...:    return .good
                case 0.5..<0.8: return .average
                default:        return .low
                }
            }
            
            /// Text + number color inside score badge
            var badgeForegroundColor: Color {
                scoreLabel.foregroundColor
            }
            
            /// Soft tinted fill — score badge background + card border tint
            var badgeBackgroundColor: Color {
                scoreLabel.backgroundColor
            }
            
            /// Vivid progress bar fill — uses borderColor (saturated token)
            /// matches web: amber bar for avg, red bar for low, green bar for good
            var progressBarColor: Color {
                scoreLabel.borderColor
            }
        }
        // MARK: - Custom Decoder
        
        private enum CodingKeys: String, CodingKey {
            case scenarioId, scenarioName, scenarioDescription, evaluationParameters, knowledgeDocument, referenceVideo, open, isManagerEvaluation, attempts, keywords, maximumAttempts, pendingAttempts, scenarioType, successCriteria, usageType, customUsageType, usageDescription
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            scenarioId = try container.decode(Int.self, forKey: .scenarioId)
            
            scenarioName = try container.decodeIfPresent(String.self, forKey: .scenarioName)
            scenarioDescription = try container.decodeIfPresent(String.self, forKey: .scenarioDescription)
            knowledgeDocument = try container.decodeIfPresent(String.self, forKey: .knowledgeDocument)
            referenceVideo = try container.decodeIfPresent(String.self, forKey: .referenceVideo)
            open = try container.decodeIfPresent(Bool.self, forKey: .open)
            isManagerEvaluation = try container.decodeIfPresent(Bool.self, forKey: .isManagerEvaluation)
            attempts = try container.decodeIfPresent([Attempt].self, forKey: .attempts)
            maximumAttempts = try container.decodeIfPresent(Int.self, forKey: .maximumAttempts)
            pendingAttempts = try container.decodeIfPresent(Int.self, forKey: .pendingAttempts)
            scenarioType = try container.decodeIfPresent(String.self, forKey: .scenarioType)
            successCriteria = try container.decodeIfPresent(String.self, forKey: .successCriteria)
            usageType = try container.decodeIfPresent(String.self, forKey: .usageType)
            customUsageType = try container.decodeIfPresent(String.self, forKey: .customUsageType)
            usageDescription = try container.decodeIfPresent(String.self, forKey: .usageDescription)
            
            // Handle stringified JSON arrays: supports both string AND native array
            if let evalString = try container.decodeIfPresent(String.self, forKey: .evaluationParameters),
               !evalString.isEmpty,
               let evalData = evalString.data(using: .utf8) {
                evaluationParameters = try? JSONDecoder().decode([EvaluationParameter].self, from: evalData)
            } else {
                // Fallback: try decoding as native array if not a string
                evaluationParameters = try? container.decodeIfPresent([EvaluationParameter].self, forKey: .evaluationParameters)
            }
            
            if let keyString = try container.decodeIfPresent(String.self, forKey: .keywords),
               !keyString.isEmpty,
               let keyData = keyString.data(using: .utf8) {
                keywords = try? JSONDecoder().decode([String].self, from: keyData)
            } else {
                keywords = try? container.decodeIfPresent([String].self, forKey: .keywords)
            }
        }
        
        // Convenience initializer for previews/tests
        init(
            scenarioId: Int,
            scenarioName: String? = nil,
            scenarioDescription: String? = nil,
            evaluationParameters: [EvaluationParameter]? = nil,
            knowledgeDocument: String? = nil,
            referenceVideo: String? = nil,
            open: Bool? = nil,
            isManagerEvaluation: Bool? = nil,
            attempts: [Attempt]? = nil,
            keywords: [String]? = nil,
            maximumAttempts: Int? = nil,
            pendingAttempts: Int? = nil,
            scenarioType: String? = nil,
            successCriteria: String? = nil,
            usageType: String? = nil,
            customUsageType: String? = nil,
            usageDescription: String? = nil
        ) {
            self.scenarioId = scenarioId
            self.scenarioName = scenarioName
            self.scenarioDescription = scenarioDescription
            self.evaluationParameters = evaluationParameters
            self.knowledgeDocument = knowledgeDocument
            self.referenceVideo = referenceVideo
            self.open = open
            self.isManagerEvaluation = isManagerEvaluation
            self.attempts = attempts
            self.keywords = keywords
            self.maximumAttempts = maximumAttempts
            self.pendingAttempts = pendingAttempts
            self.scenarioType = scenarioType
            self.successCriteria = successCriteria
            self.usageType = usageType
            self.customUsageType = customUsageType
            self.usageDescription = usageDescription
        }
    }
}

extension AcuityIQReportDataModel.Scenario {
    var progressBadgeColor: Color {
        guard let max = maximumAttempts, max > 0, let pending = pendingAttempts else {
            return .gray
        }
        if pending == 0 { return .red }
        if Double(pending) / Double(max) <= 0.33 { return .orange }
        return .purple
    }
}

extension AcuityIQReportDataModel.Scenario {
    static var preview: AcuityIQReportDataModel.Scenario {
        AcuityIQReportDataModel.Scenario(
            scenarioId: 120,
            scenarioName: "Multi Language Display Check",
            scenarioDescription: "A scenario focused on addressing customer concerns or pushbacks effectively, demonstrating problem-solving, persuasion, and alignment with the customer's priorities.",
            evaluationParameters: [
                EvaluationParameter(name: "Clarity", description: "How clearly ideas are communicated and understood", weightage: "20"),
                EvaluationParameter(name: "Content Relevance", description: "Alignment with intended purpose or topic", weightage: "20")
            ],
            knowledgeDocument: "/enth/application/pdf/639108270782459724639042057274624036Clarinova.pdf",
            referenceVideo: "",
            open: false,
            isManagerEvaluation: false,
            attempts: [
                Attempt(attemptId: 577, attemptNumber: 1, userId: 9868, userName: "LMS Admin", score: 1.9, attemptDate: "Friday, April 3, 2026 6:10 PM", managerEvaluation: nil)
            ],
            keywords: ["Multi_Language_Display_Check"],
            maximumAttempts: 20,
            pendingAttempts: 9,
            scenarioType: "Objection Handling",
            successCriteria: "Multi_Language_Display_Check",
            usageType: "Knowledge Guide",
            customUsageType: "",
            usageDescription: "This document is used only as a factual reference."
        )
    }
    
    static var previewData: [AcuityIQReportDataModel.Scenario] {
        // ✅ Use RAW string literal (#""") so \" stays as \" in output
        let mockJSON = #"""
        [
            {
                "scenarioId": 120,
                "scenarioName": "Multi Language Display Check",
                "scenarioDescription": " A scenario focused on addressing customer concerns or pushbacks effectively, demonstrating problem-solving, persuasion, and alignment with the customer's priorities.",
                "evaluationParameters": "[{\"name\":\"Clarity\",\"description\":\"How clearly ideas are communicated and understood\",\"weightage\":\"20\"},{\"name\":\"Content Relevance\",\"description\":\"Alignment of what is presented with the intended purpose or topic\",\"weightage\":\"20\"},{\"name\":\"Structure & Organization\",\"description\":\"Effectiveness of verbal expression, vocabulary, and sentence construction\",\"weightage\":\"20\"},{\"name\":\"Intent Clarity\",\"description\":\"How clearly the objective or message comes across.\",\"weightage\":\"20\"},{\"name\":\"Confidence & Presence\",\"description\":\"Poise, assurance, and overall delivery impact\",\"weightage\":\"20\"}]",
                "knowledgeDocument": "/enth/application/pdf/639108270782459724639042057274624036Clarinova.pdf",
                "referenceVideo": "",
                "open": false,
                "isManagerEvaluation": false,
                "attempts": [
                    {
                        "attemptId": 577,
                        "attemptNumber": 1,
                        "userId": 9868,
                        "userName": "LMS Admin",
                        "score": 1.9,
                        "attemptDate": "Friday, April 3, 2026 6:10 PM"
                    },
                    {
                        "attemptId": 575,
                        "attemptNumber": 3,
                        "userId": 9868,
                        "userName": "LMS Admin",
                        "score": 0.8,
                        "attemptDate": "Friday, April 3, 2026 5:39 PM"
                    },
                    {
                        "attemptId": 574,
                        "attemptNumber": 2,
                        "userId": 9868,
                        "userName": "LMS Admin",
                        "score": 0.1,
                        "attemptDate": "Friday, April 3, 2026 5:21 PM"
                    },
                    {
                        "attemptId": 573,
                        "attemptNumber": 6,
                        "userId": 9868,
                        "userName": "LMS Admin",
                        "score": 1.1,
                        "attemptDate": "Friday, April 3, 2026 5:15 PM"
                    },
                    {
                        "attemptId": 572,
                        "attemptNumber": 1,
                        "userId": 9868,
                        "userName": "LMS Admin",
                        "score": 1.6,
                        "attemptDate": "Friday, April 3, 2026 4:50 PM"
                    },
                    {
                        "attemptId": 571,
                        "attemptNumber": 1,
                        "userId": 9868,
                        "userName": "LMS Admin",
                        "score": 0.3,
                        "attemptDate": "Friday, April 3, 2026 4:47 PM"
                    },
                    {
                        "attemptId": 570,
                        "attemptNumber": 5,
                        "userId": 9868,
                        "userName": "LMS Admin",
                        "score": 0.2,
                        "attemptDate": "Friday, April 3, 2026 4:30 PM"
                    },
                    {
                        "attemptId": 569,
                        "attemptNumber": 4,
                        "userId": 9868,
                        "userName": "LMS Admin",
                        "score": 0.2,
                        "attemptDate": "Friday, April 3, 2026 3:54 PM"
                    },
                    {
                        "attemptId": 568,
                        "attemptNumber": 3,
                        "userId": 9868,
                        "userName": "LMS Admin",
                        "score": 0.1,
                        "attemptDate": "Friday, April 3, 2026 3:46 PM"
                    },
                    {
                        "attemptId": 567,
                        "attemptNumber": 2,
                        "userId": 9868,
                        "userName": "LMS Admin",
                        "score": 0.6,
                        "attemptDate": "Friday, April 3, 2026 3:39 PM"
                    },
                    {
                        "attemptId": 566,
                        "attemptNumber": 1,
                        "userId": 9868,
                        "userName": "LMS Admin",
                        "score": 0.8,
                        "attemptDate": "Friday, April 3, 2026 3:36 PM"
                    }
                ],
                "keywords": "[\"Multi_Language_Display_Check\"]",
                "maximumAttempts": 20,
                "pendingAttempts": 9,
                "scenarioType": "Objection Handling",
                "successCriteria": "Multi_Language_Display_Check",
                "usageType": "Knowledge Guide",
                "customUsageType": "",
                "usageDescription": "This document is used only as a factual reference. The AI will verify that no incorrect or misleading information is stated in the video. The candidate is not expected to follow this document verbatim or cover all details."
            },
            {
                "scenarioId": 119,
                "scenarioName": "Language_Switching_Validation",
                "scenarioDescription": " A scenario focused on addressing customer concerns or pushbacks effectively, demonstrating problem-solving, persuasion, and alignment with the customer's priorities.",
                "evaluationParameters": "[{\"name\":\"Content Relevance\",\"description\":\"Alignment of what is presented with the intended purpose or topic\",\"weightage\":\"20\"},{\"name\":\"Structure & Organization\",\"description\":\"Effectiveness of verbal expression, vocabulary, and sentence construction\",\"weightage\":\"20\"},{\"name\":\"Intent Clarity\",\"description\":\"How clearly the objective or message comes across.\",\"weightage\":\"20\"},{\"name\":\"Confidence & Presence\",\"description\":\"Poise, assurance, and overall delivery impact\",\"weightage\":\"20\"},{\"name\":\"Closure / Outcome Orientation\",\"description\":\"Strength of conclusion and clarity on key takeaway or next step\",\"weightage\":\"20\"}]",
                "knowledgeDocument": "/enth/application/pdf/639108269715390545639099067923637689639042057274624036Clarinova.pdf",
                "referenceVideo": null,
                "open": false,
                "isManagerEvaluation": true,
                "attempts": [
                    {
                        "attemptId": 583,
                        "attemptNumber": 6,
                        "userId": 9868,
                        "userName": "LMS Admin",
                        "score": 1.1,
                        "attemptDate": "Friday, April 3, 2026 9:40 PM"
                    },
                    {
                        "attemptId": 582,
                        "attemptNumber": 5,
                        "userId": 9868,
                        "userName": "LMS Admin",
                        "score": 1.7,
                        "attemptDate": "Friday, April 3, 2026 9:20 PM"
                    },
                    {
                        "attemptId": 581,
                        "attemptNumber": 4,
                        "userId": 9868,
                        "userName": "LMS Admin",
                        "score": 0.7,
                        "attemptDate": "Friday, April 3, 2026 8:33 PM"
                    },
                    {
                        "attemptId": 580,
                        "attemptNumber": 3,
                        "userId": 9868,
                        "userName": "LMS Admin",
                        "score": 0.7,
                        "attemptDate": "Friday, April 3, 2026 8:31 PM"
                    },
                    {
                        "attemptId": 579,
                        "attemptNumber": 2,
                        "userId": 9868,
                        "userName": "LMS Admin",
                        "score": 0.5,
                        "attemptDate": "Friday, April 3, 2026 6:17 PM"
                    },
                    {
                        "attemptId": 578,
                        "attemptNumber": 1,
                        "userId": 9868,
                        "userName": "LMS Admin",
                        "score": 0.6,
                        "attemptDate": "Friday, April 3, 2026 6:12 PM"
                    },
                    {
                        "attemptId": 576,
                        "attemptNumber": 1,
                        "userId": 9868,
                        "userName": "LMS Admin",
                        "score": 1.0,
                        "attemptDate": "Friday, April 3, 2026 5:55 PM"
                    }
                ],
                "keywords": "[\"Language_Switching_Validation\"]",
                "maximumAttempts": 10,
                "pendingAttempts": 3,
                "scenarioType": "Objection Handling",
                "successCriteria": "Language_Switching_Validation",
                "usageType": "Knowledge Guide",
                "customUsageType": "",
                "usageDescription": "This document is used only as a factual reference. The AI will verify that no incorrect or misleading information is stated in the video. The candidate is not expected to follow this document verbatim or cover all details."
            },
            {
                "scenarioId": 118,
                "scenarioName": "test22",
                "scenarioDescription": " A scenario focused on addressing customer concerns or pushbacks effectively, demonstrating problem-solving, persuasion, and alignment with the customer's priorities.",
                "evaluationParameters": "[{\"name\":\"Clarity\",\"description\":\"How clearly ideas are communicated and understood\",\"weightage\":\"20\"},{\"name\":\"Content Relevance\",\"description\":\"Alignment of what is presented with the intended purpose or topic\",\"weightage\":\"20\"},{\"name\":\"Structure & Organization\",\"description\":\"Effectiveness of verbal expression, vocabulary, and sentence construction\",\"weightage\":\"20\"},{\"name\":\"Intent Clarity\",\"description\":\"How clearly the objective or message comes across.\",\"weightage\":\"20\"},{\"name\":\"Confidence & Presence\",\"description\":\"Poise, assurance, and overall delivery impact\",\"weightage\":\"20\"}]",
                "knowledgeDocument": "/enth/application/pdf/639107336288882978639099067923637689639042057274624036Clarinova.pdf",
                "referenceVideo": null,
                "open": false,
                "isManagerEvaluation": true,
                "attempts": [
                    {
                        "attemptId": 565,
                        "attemptNumber": 9,
                        "userId": 9868,
                        "userName": "LMS Admin",
                        "score": 1.5,
                        "attemptDate": "Friday, April 3, 2026 3:22 PM"
                    },
                    {
                        "attemptId": 564,
                        "attemptNumber": 8,
                        "userId": 9868,
                        "userName": "LMS Admin",
                        "score": 1.3,
                        "attemptDate": "Friday, April 3, 2026 2:55 PM"
                    },
                    {
                        "attemptId": 563,
                        "attemptNumber": 7,
                        "userId": 9868,
                        "userName": "LMS Admin",
                        "score": 1.3,
                        "attemptDate": "Friday, April 3, 2026 2:15 PM"
                    },
                    {
                        "attemptId": 562,
                        "attemptNumber": 6,
                        "userId": 9868,
                        "userName": "LMS Admin",
                        "score": 1.6,
                        "attemptDate": "Friday, April 3, 2026 2:10 PM"
                    },
                    {
                        "attemptId": 561,
                        "attemptNumber": 5,
                        "userId": 9868,
                        "userName": "LMS Admin",
                        "score": 1.2,
                        "attemptDate": "Friday, April 3, 2026 2:02 PM"
                    },
                    {
                        "attemptId": 560,
                        "attemptNumber": 4,
                        "userId": 9868,
                        "userName": "LMS Admin",
                        "score": 1.9,
                        "attemptDate": "Friday, April 3, 2026 1:46 PM"
                    },
                    {
                        "attemptId": 559,
                        "attemptNumber": 3,
                        "userId": 9868,
                        "userName": "LMS Admin",
                        "score": 0.3,
                        "attemptDate": "Friday, April 3, 2026 1:44 PM"
                    },
                    {
                        "attemptId": 558,
                        "attemptNumber": 2,
                        "userId": 9868,
                        "userName": "LMS Admin",
                        "score": 0.6,
                        "attemptDate": "Thursday, April 2, 2026 6:33 PM"
                    },
                    {
                        "attemptId": 557,
                        "attemptNumber": 1,
                        "userId": 9868,
                        "userName": "LMS Admin",
                        "score": 0.6,
                        "attemptDate": "Thursday, April 2, 2026 1:39 PM"
                    }
                ],
                "keywords": "[\"test22\",\"test\"]",
                "maximumAttempts": 4,
                "pendingAttempts": 0,
                "scenarioType": "Objection Handling",
                "successCriteria": "test22",
                "usageType": "Script",
                "customUsageType": "",
                "usageDescription": "This document defines the exact flow and key lines expected in the video. The candidate's response should strictly follow this script, including sequence and required talking points. Deviations or missing sections may be flagged as critical issues."
            }
        ]
        """#
        
        // ✅ Proper error handling with debug output
        do {
            guard let data = mockJSON.data(using: .utf8) else {
                print("❌ PreviewData: Failed to convert JSON string to Data")
                return []
            }
            let decoder = JSONDecoder()
            let decoded = try decoder.decode([AcuityIQReportDataModel.Scenario].self, from: data)
            print("✅ PreviewData: Decoded \(decoded.count) scenarios")
            return decoded
        } catch {
            print("❌ PreviewData: Decoding error - \(error.localizedDescription)")
            // Print first 300 chars of JSON for debugging
            let preview = String(mockJSON.prefix(300))
            print("🔍 JSON preview: \(preview)...")
            return []
        }
    }
}
