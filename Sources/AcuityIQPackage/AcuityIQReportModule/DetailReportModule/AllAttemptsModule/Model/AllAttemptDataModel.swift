//
//  AllAttemptDataModel.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 03/04/26.
//

import SwiftUI
import NetworkService


// MARK: Request Model
struct AllAttemptDataModel {
    
    struct GetSecnaioOverallReportRequestModel: EndpointModel {
        
        let secnarioID: Int
        let userID: Int

        var path: String {
            [
                APIConst.courseBaseUrl,
                APIConst.versionAPI,
                APIConst.GetScenarioOverallReport,
                String(secnarioID),
                String(userID)
            ].joined(separator: "/")
        }

        var method: NetworkService.HTTPMethod { .get }

        var headers: [String : String]? { nil }
    }
    
    
}

// MARK: Response Model
extension AllAttemptDataModel {
    
    
    enum AllDataTab: String, CaseIterable, SegmentItemRepresentable {
        case overviewAndSections
        case evaluationCriteria
        case behavioralAnalysis

        var id: String { rawValue }

        var menuTitle: String {
            switch self {
            case .overviewAndSections:  return "Overview & Sections"
            case .evaluationCriteria:   return "Evaluation Criteria"
            case .behavioralAnalysis:   return "Behavioral Analysis"
            }
        }

        var icon: SegmentIconType {
            switch self {
            case .overviewAndSections:  return .system(name: "doc.richtext")
            case .evaluationCriteria:   return .system(name: "doc.checkmark")
            case .behavioralAnalysis:   return .system(name: "person.fill")
            }
        }

        var selectedColor: Color { Color.blue.opacity(0.12) }
        var unSelectedColor: Color { Color(.systemGray6) }
    }
    
    struct AllAttemptResponse: Codable {
        let evaluations: [Evaluation]
        let behavioural: [Evaluation]
        
        let overallRatings: [Double]
        let beginning: [Double]
        let middle: [Double]
        let end: [Double]
        let criticalErrors: [Double]
        let attempts: [String]
        
        
        enum CodingKeys: CodingKey {
            case evaluations
            case behavioural
            case overallRatings
            case beginning
            case middle
            case end
            case criticalErrors
            case attempts
        }
        
        
        //Computed Properties
        
        var evaluationInfoTitle: String {
            "Track your progress across evaluation parameters. Click to expand and see detailed scores and feedback for each attempt."
        }
        
        var behaviourInfoTitle: String {
            "Monitor behavioral metric trends across attempts. Click to expand and see average scores and feedback for each attempt."
        }
    }

    // MARK: - Evaluation
    struct Evaluation: Codable, Identifiable {
        let id = UUID()
        let title: String
        let status: String
        let attempts: [Attempt]
        let graph: Graph
        
        enum CodingKeys: CodingKey {
            case title
            case status
            case attempts
            case graph
        }
        
        
        var getStatusColor: Color {
            switch status.lowercased() {
            case "inconsistent":
                Color(hex: "#dc2627")
            case "stagnant":
                Color(hex: "#b5530a")
            default:
                    .orange
            }
        }
    }

    struct Attempt: Codable, Identifiable {
        let id = UUID()
        let attempt: Int
        let feedback: String
        let score: Double
        let whatWentWell: String?
        let improvementsRequired: [String]?
        
        enum CodingKeys: CodingKey {
            case attempt
            case feedback
            case score
            case whatWentWell
            case improvementsRequired
        }
    }

    struct Graph: Codable {
        let average: Double
        let data: [Double]
        let labels: [String]
        let name: String
        let color: String
        
        // MARK: Computed Properties
        var graphData:  (config: LineChartConfiguration.MetricLineChartConfig, model: [LineChartDataModel.LineChartPoint]) {
            
            let config: LineChartConfiguration.MetricLineChartConfig = .init(
                title: name.replace("Progress", replacement: ""),
                accentColor: Color(rgbString: color),
                yDomain: 0...10,
                showRuleMark: true,
                xLabel: "Attempt"
            )
            
            let chartModel: [LineChartDataModel.LineChartPoint] = Array(self.data.enumerated()).map { index, rating in
               LineChartDataModel.LineChartPoint(xValue: Double(index), yValue: rating)
            }
            
            return (config,chartModel)
        }
    }
   
}

extension AllAttemptDataModel.AllAttemptResponse {
    //MARK: Computed `Overall Rating Progress` Graph Model
    var overallRatingGrapghDataModel: (config: LineChartConfiguration.MetricLineChartConfig, model: [LineChartDataModel.LineChartPoint]) {
        
        let config: LineChartConfiguration.MetricLineChartConfig = .init(
            title: "Overall Rating Progress",
            accentColor: .blue,
            yDomain: 0...10,
            showRuleMark: false
        )
        
        let chartModel: [LineChartDataModel.LineChartPoint] = Array(self.overallRatings.enumerated()).map { index, rating in
           LineChartDataModel.LineChartPoint(xValue: Double(index), yValue: rating)
        }
        
        return (config,chartModel)
    }
    
    // MARK: Computed `Section-wise Progress` Graph Model
    var sectionWiseProgressGraphDataModel: (
        config: LineChartConfiguration.MetricLineChartConfig,
        model: [LineChartDataModel.SectionPoint]
    ) {

        let config: LineChartConfiguration.MetricLineChartConfig = .init(
            title: "Section-wise Progress",
            accentColor: .blue,
            yDomain: 0...10,
            chartType: .sectionWise,
            sectionColors: [
                "Beginning": .green,
                "Middle": .purple,
                "End": .orange
            ]
        )

        // Beginning
        let beginningPoints: [LineChartDataModel.SectionPoint] =
        beginning.enumerated().map { index, value in
            LineChartDataModel.SectionPoint(
                xValue: Double(index),
                yValue: value,
                section: "Beginning"
            )
        }

        // Middle
        let middlePoints: [LineChartDataModel.SectionPoint] =
        middle.enumerated().map { index, value in
            LineChartDataModel.SectionPoint(
                xValue: Double(index),
                yValue: value,
                section: "Middle"
            )
        }

        // End
        let endPoints: [LineChartDataModel.SectionPoint] =
        end.enumerated().map { index, value in
            LineChartDataModel.SectionPoint(
                xValue: Double(index),
                yValue: value,
                section: "End"
            )
        }

        // Combine all
        let chartModel = beginningPoints + middlePoints + endPoints

        return (config, chartModel)
    }
    
    //MARK: Computed `Critical Error` Graph Model
    var criticalErrorgGrapghDataModel: (config: LineChartConfiguration.MetricLineChartConfig, model: [LineChartDataModel.LineChartPoint]) {
        
        let config: LineChartConfiguration.MetricLineChartConfig = .init(
            title: "Critical Errors",
            accentColor: .blue,
            yDomain: 0...10,
            showRuleMark: false
        )
        
        let chartModel: [LineChartDataModel.LineChartPoint] = Array(self.overallRatings.enumerated()).map { index, rating in
            LineChartDataModel.LineChartPoint(xValue: Double(index), yValue: rating)
        }
        
        return (config,chartModel)
    }
    
}


#if DEBUG
// MARK: Preview Data
extension AllAttemptDataModel.AllAttemptResponse {
    
    static let preview: AllAttemptDataModel.AllAttemptResponse = .init(
        evaluations: [
            .init(
                title: "Clarity",
                status: "Inconsistent",
                attempts: [
                    .init(
                        attempt: 1,
                        feedback: "The communication lacks clarity, making it difficult to follow the main points.",
                        score: 0.6,
                        whatWentWell: nil,
                        improvementsRequired: nil
                    ),
                    .init(
                        attempt: 2,
                        feedback: "The ideas are communicated with some clarity, but there are instances of jargon that may confuse the audience.",
                        score: 5.1,
                        whatWentWell: nil,
                        improvementsRequired: nil
                    ),
                    .init(
                        attempt: 3,
                        feedback: "The communication is somewhat clear, but there are instances of jargon and complex phrasing that may confuse the listener.",
                        score: 5.4,
                        whatWentWell: nil,
                        improvementsRequired: nil
                    )
                ],
                graph: .init(
                    average: 2.53,
                    data: [0.6, 5.1, 5.4],
                    labels: ["Attempt 1", "Attempt 2", "Attempt 3"],
                    name: "Clarity Progress",
                    color: "rgb(199, 74, 74)"
                )
            ),
            .init(
                title: "Content Relevance",
                status: "Inconsistent",
                attempts: [
                    .init(
                        attempt: 1,
                        feedback: "The content is somewhat relevant but strays from the main topic of discussion.",
                        score: 1.4,
                        whatWentWell: nil,
                        improvementsRequired: nil
                    ),
                    .init(
                        attempt: 2,
                        feedback: "The content is relevant to the discussion about hypertension medications, but it could benefit from a stronger focus on customer concerns.",
                        score: 5.4,
                        whatWentWell: nil,
                        improvementsRequired: nil
                    ),
                    .init(
                        attempt: 3,
                        feedback: "The content presented is relevant to the discussion, focusing on hypertension medications, but lacks a direct connection to customer concerns.",
                        score: 5.0,
                        whatWentWell: nil,
                        improvementsRequired: nil
                    )
                ],
                graph: .init(
                    average: 2.44,
                    data: [1.4, 5.4, 5.0],
                    labels: ["Attempt 1", "Attempt 2", "Attempt 3"],
                    name: "Content Relevance Progress",
                    color: "rgb(199, 74, 74)"
                )
            ),
            .init(
                title: "Structure & Organization",
                status: "Inconsistent",
                attempts: [
                    .init(
                        attempt: 1,
                        feedback: "The ideas are poorly structured, leading to confusion in understanding the message.",
                        score: 0.9,
                        whatWentWell: nil,
                        improvementsRequired: nil
                    ),
                    .init(
                        attempt: 2,
                        feedback: "The presentation lacks a clear structure, making it difficult to follow the flow of information.",
                        score: 5.0,
                        whatWentWell: nil,
                        improvementsRequired: nil
                    ),
                    .init(
                        attempt: 3,
                        feedback: "The structure is somewhat disorganized, with a lack of clear transitions between topics, making it hard to follow.",
                        score: 5.8,
                        whatWentWell: nil,
                        improvementsRequired: nil
                    )
                ],
                graph: .init(
                    average: 2.5,
                    data: [0.9, 5.0, 5.8],
                    labels: ["Attempt 1", "Attempt 2", "Attempt 3"],
                    name: "Structure & Organization Progress",
                    color: "rgb(199, 74, 74)"
                )
            ),
            .init(
                title: "Intent Clarity",
                status: "Inconsistent",
                attempts: [
                    .init(
                        attempt: 1,
                        feedback: "The intent behind the communication is unclear, making it hard to grasp the primary objective.",
                        score: 1.8,
                        whatWentWell: nil,
                        improvementsRequired: nil
                    ),
                    .init(
                        attempt: 2,
                        feedback: "The intent to present medication options is clear, but the overall message could be more focused.",
                        score: 6.1,
                        whatWentWell: nil,
                        improvementsRequired: nil
                    ),
                    .init(
                        attempt: 3,
                        feedback: "The intent is somewhat clear, but the message could be more focused on addressing customer concerns directly.",
                        score: 5.1,
                        whatWentWell: nil,
                        improvementsRequired: nil
                    )
                ],
                graph: .init(
                    average: 2.68,
                    data: [1.8, 6.1, 5.1],
                    labels: ["Attempt 1", "Attempt 2", "Attempt 3"],
                    name: "Intent Clarity Progress",
                    color: "rgb(199, 74, 74)"
                )
            ),
            .init(
                title: "Confidence & Presence",
                status: "Inconsistent",
                attempts: [
                    .init(
                        attempt: 1,
                        feedback: "The delivery lacks confidence, affecting the overall impact of the presentation.",
                        score: 0.6,
                        whatWentWell: nil,
                        improvementsRequired: nil
                    ),
                    .init(
                        attempt: 2,
                        feedback: "The speaker demonstrates some confidence, but the delivery could be more engaging to enhance presence.",
                        score: 6.5,
                        whatWentWell: nil,
                        improvementsRequired: nil
                    ),
                    .init(
                        attempt: 3,
                        feedback: "The delivery shows some confidence, but the overall impact is diminished by the unclear structure and organization.",
                        score: 6.8,
                        whatWentWell: nil,
                        improvementsRequired: nil
                    )
                ],
                graph: .init(
                    average: 2.91,
                    data: [0.6, 6.5, 6.8],
                    labels: ["Attempt 1", "Attempt 2", "Attempt 3"],
                    name: "Confidence & Presence Progress",
                    color: "rgb(199, 74, 74)"
                )
            )
        ],
        
        behavioural: [
            .init(
                title: "Clarity",
                status: "Stagnant",
                attempts: [
                    .init(
                        attempt: 1,
                        feedback: "The clarity was reasonably effective overall, though greater consistency could enhance impact.",
                        score: 6.7,
                        whatWentWell: "The introduction was clear in establishing who you are and the company you represent, which helps in building trust with the listener. The tone was professional and respectful, creating a positive atmosphere for the conversation.",
                        improvementsRequired: [
                            "0:05 - Clearly state the purpose of the call before diving into product details to set expectations.",
                            "0:10 - Use simpler language when introducing medical terms to ensure the listener fully understands.",
                            "0:15 - Break down the product information into bullet points to avoid overwhelming the listener."
                        ]
                    ),
                    .init(
                        attempt: 2,
                        feedback: "The clarity contributed moderately to the delivery and can be developed further.",
                        score: 6.7,
                        whatWentWell: "The introduction was clear in establishing who you are and the company you represent, which helps build trust with the listener. The tone was respectful and professional, creating a positive atmosphere for the conversation.",
                        improvementsRequired: [
                            "At 00:10, simplify the introduction by stating 'I represent Gravitas Mankind, focusing on hypertension management.'",
                            "At 00:20, clearly differentiate between the two products by stating their components."
                        ]
                    ),
                    .init(
                        attempt: 3,
                        feedback: "The clarity remained balanced, but sharper control could improve delivery.",
                        score: 6.7,
                        whatWentWell: "The introduction was clear in establishing who you are and the company you represent, which helps build credibility with the listener. The mention of specific products provides valuable information that can engage the customer.",
                        improvementsRequired: [
                            "0:05 - Clearly state the purpose of the call to set expectations for the listener.",
                            "0:10 - Break down the product names and dosages more distinctly to avoid confusion."
                        ]
                    )
                ],
                graph: .init(
                    average: 6.7,
                    data: [6.7, 6.7, 6.7],
                    labels: ["Attempt 1", "Attempt 2", "Attempt 3"],
                    name: "Clarity Progress",
                    color: "rgb(59, 130, 246)"
                )
            ),
            .init(
                title: "Filler Usage",
                status: "Inconsistent",
                attempts: [
                    .init(
                        attempt: 1,
                        feedback: "As the conversation progressed, controlled pauses can strengthen delivery.",
                        score: 5.5,
                        whatWentWell: "The introduction was clear in establishing who you are and the company you represent, which helps in building trust with the listener.",
                        improvementsRequired: [
                            "0:50 - Reduce the use of fillers like 'sir' to maintain a smoother flow and sound more confident.",
                            "0:55 - Avoid repeating phrases unnecessarily; this can distract from the main message."
                        ]
                    ),
                    .init(
                        attempt: 2,
                        feedback: "As the conversation progressed, reducing filler words can improve fluency.",
                        score: 5.7,
                        whatWentWell: "The tone was respectful and professional, creating a positive atmosphere for the conversation.",
                        improvementsRequired: [
                            "At 00:05, avoid fillers like 'sir' repeatedly; instead, use it once at the beginning.",
                            "At 00:15, eliminate unnecessary pauses or filler words like 'um' to maintain a smooth flow."
                        ]
                    ),
                    .init(
                        attempt: 3,
                        feedback: "During the core part of the discussion, reducing filler words can improve fluency.",
                        score: 6.6,
                        whatWentWell: "The mention of specific products demonstrates knowledge and can engage the listener's interest.",
                        improvementsRequired: [
                            "0:50 - Minimize the use of 'sir' to avoid sounding repetitive; use it strategically.",
                            "0:55 - Reduce filler phrases like 'you know' or 'so' to maintain professionalism."
                        ]
                    )
                ],
                graph: .init(
                    average: 6.0,
                    data: [5.5, 5.7, 6.6],
                    labels: ["Attempt 1", "Attempt 2", "Attempt 3"],
                    name: "Filler Usage Progress",
                    color: "rgb(236, 72, 153)"
                )
            ),
            .init(
                title: "Mood",
                status: "Stagnant",
                attempts: [
                    .init(
                        attempt: 1,
                        feedback: "Towards the end of the conversation, expressive delivery can enhance engagement.",
                        score: 5.6,
                        whatWentWell: "The tone was professional and respectful, creating a positive atmosphere for the conversation.",
                        improvementsRequired: [
                            "1:05 - Infuse more enthusiasm into your delivery to create a more engaging atmosphere.",
                            "1:10 - Use positive language that highlights the benefits of the products to uplift the mood."
                        ]
                    ),
                    .init(
                        attempt: 2,
                        feedback: "In the closing moments, expressive delivery can enhance engagement.",
                        score: 5.6,
                        whatWentWell: "The pitch was informative, providing specific details about the products offered.",
                        improvementsRequired: [
                            "At 00:10, aim for a more positive mood by expressing excitement about the products.",
                            "At 00:25, incorporate phrases that convey assurance."
                        ]
                    ),
                    .init(
                        attempt: 3,
                        feedback: "In the closing moments, expressive delivery can enhance engagement.",
                        score: 5.6,
                        whatWentWell: "The tone was polite and respectful, which is essential in establishing rapport.",
                        improvementsRequired: [
                            "1:05 - Aim for a more positive and upbeat mood to create excitement about the products.",
                            "1:10 - Use affirming language to instill confidence in the listener."
                        ]
                    )
                ],
                graph: .init(
                    average: 5.6,
                    data: [5.6, 5.6, 5.6],
                    labels: ["Attempt 1", "Attempt 2", "Attempt 3"],
                    name: "Mood Progress",
                    color: "rgb(245, 158, 11)"
                )
            ),
            .init(
                title: "Pitch",
                status: "Stagnant",
                attempts: [
                    .init(
                        attempt: 1,
                        feedback: "During the initial moments, greater pitch variation can improve engagement.",
                        score: 3.9,
                        whatWentWell: "The mention of specific products demonstrates knowledge and can engage the listener's interest.",
                        improvementsRequired: [
                            "0:20 - Vary your pitch to emphasize key benefits of the products, making them more memorable.",
                            "0:25 - Avoid a monotonous tone; inflect your voice to convey enthusiasm."
                        ]
                    ),
                    .init(
                        attempt: 2,
                        feedback: "At the beginning of the conversation, strategic emphasis through pitch can enhance expression.",
                        score: 3.9,
                        whatWentWell: "The pitch was informative, providing specific details about the products offered.",
                        improvementsRequired: [
                            "At 00:15, emphasize the benefits of the products to make the pitch more appealing.",
                            "At 00:25, highlight how each ingredient contributes to effectiveness."
                        ]
                    ),
                    .init(
                        attempt: 3,
                        feedback: "At the beginning of the conversation, strategic emphasis through pitch can enhance expression.",
                        score: 3.9,
                        whatWentWell: "The clarity of the product offerings, combined with a respectful tone, positively impacts perception.",
                        improvementsRequired: [
                            "0:20 - Vary your pitch to emphasize key points, such as the benefits of the products.",
                            "0:25 - Avoid a monotone delivery; use a more dynamic pitch."
                        ]
                    )
                ],
                graph: .init(
                    average: 3.9,
                    data: [3.9, 3.9, 3.9],
                    labels: ["Attempt 1", "Attempt 2", "Attempt 3"],
                    name: "Pitch Progress",
                    color: "rgb(139, 92, 246)"
                )
            ),
            .init(
                title: "Pace",
                status: "Inconsistent",
                attempts: [
                    .init(
                        attempt: 1,
                        feedback: "Improving pace would significantly strengthen communication quality.",
                        score: 5.5,
                        whatWentWell: "The tone was professional and respectful, creating a positive atmosphere.",
                        improvementsRequired: [
                            "1:20 - Slow down your pace when introducing complex product details to ensure comprehension.",
                            "1:25 - Use pauses effectively to allow the listener to digest information."
                        ]
                    ),
                    .init(
                        attempt: 2,
                        feedback: "The pace remained balanced, but sharper control could improve delivery.",
                        score: 6.2,
                        whatWentWell: "The pitch was informative, providing specific details about the products offered.",
                        improvementsRequired: [
                            "At 00:10, slow down your delivery slightly to ensure the listener can follow along.",
                            "At 00:20, use pauses effectively after key points."
                        ]
                    ),
                    .init(
                        attempt: 3,
                        feedback: "Limited control over pace affected communication effectiveness.",
                        score: 5.2,
                        whatWentWell: "The tone was polite and respectful, which is essential in establishing rapport.",
                        improvementsRequired: [
                            "1:20 - Slow down your pace slightly to ensure clarity and comprehension.",
                            "1:25 - Use pauses effectively after key points to allow digestion."
                        ]
                    )
                ],
                graph: .init(
                    average: 5.7,
                    data: [5.5, 6.2, 5.2],
                    labels: ["Attempt 1", "Attempt 2", "Attempt 3"],
                    name: "Pace Progress",
                    color: "rgb(16, 185, 129)"
                )
            ),
            .init(
                title: "Tone",
                status: "Stagnant",
                attempts: [
                    .init(
                        attempt: 1,
                        feedback: "The tone showed noticeable inconsistency and needs improvement.",
                        score: 5.2,
                        whatWentWell: "The tone was professional and respectful, creating a positive atmosphere.",
                        improvementsRequired: [
                            "0:35 - Maintain a more conversational tone to foster a connection with the listener.",
                            "0:40 - Avoid overly formal language that may create distance."
                        ]
                    ),
                    .init(
                        attempt: 2,
                        feedback: "The tone showed noticeable inconsistency and needs improvement.",
                        score: 5.2,
                        whatWentWell: "The pitch was informative, providing specific details about the products offered.",
                        improvementsRequired: [
                            "At 00:05, adopt a more engaging tone by smiling while speaking.",
                            "At 00:20, vary your tone to emphasize key points."
                        ]
                    ),
                    .init(
                        attempt: 3,
                        feedback: "Strengthening tone would help create a more confident delivery.",
                        score: 5.2,
                        whatWentWell: "The clarity of the product offerings, combined with a respectful tone, positively impacts perception.",
                        improvementsRequired: [
                            "0:35 - Use a warmer tone to create a more inviting atmosphere.",
                            "0:40 - Avoid sounding overly formal; a conversational tone can help build rapport."
                        ]
                    )
                ],
                graph: .init(
                    average: 5.2,
                    data: [5.2, 5.2, 5.2],
                    labels: ["Attempt 1", "Attempt 2", "Attempt 3"],
                    name: "Tone Progress",
                    color: "rgb(14, 165, 233)"
                )
            )
        ],
        
        overallRatings: [0.6, 0.6, 0.3],
        beginning: [0.7, 1.4, 0.8],
        middle: [1.1, 0.8, 1.9],
        end: [0.5, 1.5, 1.4],
        criticalErrors: [2, 2, 2],
        attempts: ["Attempt 1", "Attempt 2", "Attempt 3"]
    )
}
#endif
