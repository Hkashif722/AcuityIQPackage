//
//  AcuityReportUploadViewModel.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 06/04/26.
//

import Foundation
import SwiftUI
import SwiftUIUtilities
import SwiftfulRouting

class AcuityReportUploadViewModel: RoutableViewModel {

    // MARK: - Published Properties

    @Published var showVideoPicker: Bool = false
    @Published var selectedFileURL: URL?
    @Published var uploadState: AcuityReportUploadDataModel.UploadState = .idle

    // MARK: - Properties

    let scenarioId: Int
    @Published var scenario: AcuityIQReportDataModel.Scenario?

    // MARK: - Computed Properties

    var scenarioTitle: String {
        "Upload New Attempts For: \(scenario?.scenarioName ?? "Unknown")"
    }

    var scenarioDescription: String {
        scenario?.scenarioDescription ?? ""
    }

    var hasFileSelected: Bool {
        selectedFileURL != nil
    }

    var selectedFileName: String? {
        selectedFileURL?.lastPathComponent
    }

    // MARK: - Initialization

    init(router: AnyRouter, scenarioId: Int) {
        self.scenarioId = scenarioId
        super.init(router: router)
    }
}

// MARK: - Actions

extension AcuityReportUploadViewModel {

    func didTapBrowseFiles() {
        showVideoPicker = true
    }

    func didSelectVideo(url: URL?) {
        guard let url else {
            selectedFileURL = nil
            uploadState = .idle
            return
        }

        // Validate file size
        if let fileSize = try? FileManager.default.attributesOfItem(atPath: url.path)[.size] as? Int64,
           fileSize > AcuityReportUploadDataModel.Constants.maxFileSizeBytes {
            uploadState = .error("File size exceeds \(AcuityReportUploadDataModel.Constants.maxFileSizeMB) MB limit")
            return
        }

        selectedFileURL = url
        uploadState = .fileSelected(url)
    }

    func didTapAnalyse() {
        guard let _ = selectedFileURL else { return }
        // TODO: Implement video upload and analysis
        print("Analyse tapped")
    }

    func didTapEvaluationCriteria() {
        let evaluationParameters = scenario?.evaluationParameters ?? []
        NavigationService.shared.navigate(
            using: router,
            to: AppNavigationDestination.evaluationCriteria(evaluationParameters: evaluationParameters)
        )
    }

    func didTapKeywords() {
        let keywords = scenario?.keywords ?? []
        NavigationService.shared.navigate(
            using: router,
            to: AppNavigationDestination.keywordsView(keywords: keywords)
        )
    }

    func didTapProductKnowledge() {
        guard let knowledgeDocument = scenario?.knowledgeDocument,
              !knowledgeDocument.isEmpty else {
            toast = Toast(style: .info, message: "Product knowledge document is not available.")
            return
        }
        // TODO: Navigate to document viewer
        print("Product Knowledge tapped: \(knowledgeDocument)")
    }

    func didTapReferenceVideo() {
        guard let referenceVideo = scenario?.referenceVideo,
              !referenceVideo.isEmpty else {
            toast = Toast(style: .info, message: "Reference video is not available.")
            return
        }
        // TODO: Navigate to video player
        print("Reference Video tapped: \(referenceVideo)")
    }
}
