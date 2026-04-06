//
//  AcuityReportUploadDataModel.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 06/04/26.
//

import SwiftUI

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

    // MARK: - Upload State

    enum UploadState: Equatable {
        case idle
        case fileSelected(URL)
        case uploading(progress: Double)
        case success
        case error(String)

        static func == (lhs: UploadState, rhs: UploadState) -> Bool {
            switch (lhs, rhs) {
            case (.idle, .idle):
                return true
            case let (.fileSelected(lhsURL), .fileSelected(rhsURL)):
                return lhsURL == rhsURL
            case let (.uploading(lhsProgress), .uploading(rhsProgress)):
                return lhsProgress == rhsProgress
            case (.success, .success):
                return true
            case let (.error(lhsMsg), .error(rhsMsg)):
                return lhsMsg == rhsMsg
            default:
                return false
            }
        }
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
        onProductKnowledge: @escaping () -> Void,
        onReferenceVideo: @escaping () -> Void
    ) -> [PreviewItem] {
        [
            PreviewItem(icon: "doc.text.fill", title: "Product Knowledge", action: onProductKnowledge),
            PreviewItem(icon: "play.circle.fill", title: "Reference Video", action: onReferenceVideo)
        ]
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
