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
import NetworkService

class AcuityReportUploadViewModel: RoutableViewModel {

    // MARK: - Published Properties

    @Published var selectedFileName: String?
    
    @Published var totalAttempts: Int
    
    @Published var attemptRemaining: Int

    let navModel: NavigationViewModel.AcuityReportUploadNavModel

    // MARK: - Private Properties
    private var scenarioAnalysisResponse: AcuityReportUploadDataModel.ScenarioAnalysisResponse?
    private var speechAnalysisResponse: AcuityReportUploadDataModel.SpeechAnalysisResponse?
    private var currentVideoPath: String?

    // MARK: - Computed Properties

    var hasFileSelected: Bool {
        selectedFileName != nil
    }
    
    var scenarioModel: AcuityIQReportDataModel.Scenario {
        navModel.scenarioModel
    }
    
    var isAttemptExausted: Bool {
        attemptRemaining == 0
    }
  
    
    // MARK: - Initialization

    init(router: AnyRouter, navModel: NavigationViewModel.AcuityReportUploadNavModel) {
        self.navModel = navModel
        _totalAttempts = .init(initialValue: navModel.attempt?.total ?? navModel.scenarioModel.pendingAttempts ?? 0)
        _attemptRemaining = .init(initialValue: navModel.attempt?.left ?? navModel.scenarioModel.pendingAttempts ?? 0)
        super.init(router: router)
    }
}

// MARK: - Actions

extension AcuityReportUploadViewModel {

    func didTapBrowseFiles() {
        
        let navModel = NavigationViewModel.DocumentPickerModel { [weak self] url in
            guard let self = self else { return }
            guard let url else {
                selectedFileName = nil
                return
            }
            
            // Validate file size
            if let fileSize = try? FileManager.default.attributesOfItem(atPath: url.path)[.size] as? Int64,
               fileSize > AcuityReportUploadDataModel.Constants.maxFileSizeBytes {
                toast = .init(style: .error, message: "File size exceeds \(AcuityReportUploadDataModel.Constants.maxFileSizeMB)")
                return
            }
            
            Task {
                self.postVideoFile(fileURL: url)
            }
        }
        NavigationService.shared.navigate(using: router, to: .showVideoPickerView(navModel))
    }

    func didTapAnalyse() {
        guard let _ = selectedFileName else { return }
        // TODO: Implement video upload and analysis
        self.callProctoringEvalautionAndSpeechAPIParallely()
        print("Analyse tapped")
    }

    func didTapEvaluationCriteria() {
        let evaluationParameters = navModel.scenarioModel.evaluationParameters ?? []
        NavigationService.shared.navigate(
            using: router,
            to: AppNavigationDestination.evaluationCriteria(evaluationParameters: evaluationParameters)
        )
    }

    func didTapKeywords() {
        let keywords = navModel.scenarioModel.keywords ?? []
        NavigationService.shared.navigate(
            using: router,
            to: AppNavigationDestination.keywordsView(keywords: keywords)
        )
    }

    func didTapProductKnowledge() {
        guard let knowledgeDocument = navModel.scenarioModel.knowledgeDocument,
              !knowledgeDocument.isEmpty else {
            toast = Toast(style: .info, message: "Product knowledge document is not available.")
            return
        }
        
        guard let documentPathURL: URL =  ResourceUtils.getResourceURLPath(knowledgeDocument) else {
            toast = .init(style: .warning, message: "Something went wrong!")
            return
        }
        
        switch documentPathURL.pathExtension {
        case "pdf":
            let navModel: NavigationViewModel.PdfViewerNavModel = .init(pdfURL: documentPathURL)
            NavigationService.shared.navigate(using: router, to: .pdfViewerNavModel(navModel))
            
        default:
            let navModel = NavigationViewModel.ResourceViewModel(filePath: documentPathURL.absoluteString, isOnlineType: true)
            NavigationService.shared.navigate(using: router, to: .resourceView(navModel))
        }
        // TODO: Navigate to document viewer
        Logger.shared.log(.info, message: "Product Knowledge tapped: \(knowledgeDocument)")
    }

    func didTapReferenceVideo() {
        guard let referenceVideo = navModel.scenarioModel.referenceVideo,
              !referenceVideo.isEmpty else {
            toast = Toast(style: .info, message: "Reference video is not available.")
            return
        }
        
        guard let videoPathURL: URL =  ResourceUtils.getResourceURLPath(referenceVideo) else {
            toast = .init(style: .warning, message: "Something went wrong!")
            return
        }
        
        let navModel = NavigationViewModel.ResourceViewModel(filePath: videoPathURL.absoluteString, isOnlineType: true)
        NavigationService.shared.navigate(using: router, to: .resourceView(navModel))
        
        // TODO: Navigate to video player
        Logger.shared.log(.info, message: "Reference Video tapped: \(referenceVideo)")
    }
}

// MARK: API Call
extension AcuityReportUploadViewModel {
    
    // MARK: Mark Module Attempt
    @discardableResult
    private func callMarkModuleAttempt() async -> Int? {
        guard let projectID = navModel.projectID,
              let courseId = navModel.courseId,
              let moduleId = navModel.moduleId else {
            Logger.shared.log(.error, message: "Missing required parameters for MarkModuleAttempt")
            return nil
        }

        let payload = AcuityReportUploadDataModel.MarkModuleAttemptRequestModel.Payload(
            projectId: projectID,
            courseId: courseId,
            moduleId: moduleId,
            isNewAttempt: true
        )

        let model = AcuityReportUploadDataModel.MarkModuleAttemptRequestModel(payload: payload)

        self.loadingState = .loading(title: "Initializing", message: "Please wait.")

        do {
            let response = try await ApiService.shared.requestPostHeader(
                type: Int.self,
                model: model,
                payload: payload
            )

            Logger.shared.log(.debug, message: "MarkModuleAttempt response: \(response)")
            return response

        } catch {
            self.loadingState = .none
            Logger.shared.log(.error, message: "Error occurred, api: \(model.path), error: \(error.localizedDescription), ref: \(self)")
            self.toast = Toast(style: .error, message: "Failed to initialize module attempt")
            return nil
        }
    }
    
    
    //Post file upload:
    private func postVideoFile(fileURL: URL) {
        
        let uploadGoalTask = Task { [weak self] in
            
            guard let self = self else { return }
            
            await self.callMarkModuleAttempt()
            
            self.loadingState = .loading(title: "uploading", message: "Please wait.")
            
            do {
                let model = AcuityReportUploadDataModel.PostFileUpload()
                
                let payload = try model.getPayLoad()
                
                for try await event in ApiService.shared
                    .uploadFile(
                        type: String.self,
                        model: model,
                        fileURL: fileURL,
                        parameters: payload
                    ) {
                    switch event {
                    case .progress(let progress):
                        
                        self.loadingState = .progressLoading(
                            progress: progress,
                            title: "Uploading",
                            message: "Please wait."
                        )
                        
                    case .response(let filePath):
                        self.selectedFileName = filePath.normalizedFilePath()
                        self.loadingState = .loaded
//                        self.postProctoringData(videoPath: ResourceUtils.getResourcPath(filePath))
                        
                    }
                }
            } catch {
                self.loadingState = .none
                Logger.shared.log(.error, message: "\(error.localizedDescription)")
                self.toast = Toast(style: .error, message: "user_cannot_start_thread".localized)
            }
            
            
        }
        self.tasks.insert(TaskUtility.AnyCancellableTask(uploadGoalTask))
    }
    
    // Call Video Procetoring, Evaluation Parameter & speech analysis parallely
    // MARK: - Parallel API Caller
    private func callProctoringEvalautionAndSpeechAPIParallely() {
        guard let videoPath = ResourceUtils.getResourceURLPath(selectedFileName)?.absoluteString  else {
            self.toast = .init(style: .error, message: "Something went wrong!")
            return
        }
        Task { [weak self] in
            guard let self = self else { return }
            
            self.loadingState = .loading(
                title: "Processing Video Analysis",
                message: "Running proctoring, evaluation & speech analysis..."
            )
            
            do {
                try await withThrowingTaskGroup(of: Void.self) { group in
                    group.addTask { [weak self] in
                        try await self?.postProctoringData(videoPath: videoPath)
                    }
                    group.addTask { [weak self] in
                        try await self?.postVideoParameters(videoPath: videoPath)
                    }
                    group.addTask { [weak self] in
                        try await self?.callSpeechAnalysisAPI(videoPath: videoPath)
                    }
                    for try await _ in group {}
                }
//                self.loadingState = .loaded
                Logger.shared.log(.info, message: "✅ All parallel analyses completed")
                guard let speechAnalysisResponse else {
                    toast = .init(style: .error, message: "Something went wrong!")
                    return
                }
                self.callSpeechInsightsAPI(videoPath: videoPath, speechAnalysisResponse: speechAnalysisResponse)
            } catch {
                self.loadingState = .none
                Logger.shared.log(.error, message: "❌ Parallel execution failed: \(error.localizedDescription)")
            }
        }
    }
    
    
    // MARK: Post Proctoring
    private func postProctoringData(videoPath: String) async throws {
        let model = AcuityReportUploadDataModel.PostVideoProctoring(videoPath: videoPath)
        
        do {
            let responseModel = try await ApiService.shared.postRequestAsyncWithCustomToken(
                model,
                payload: model.payload,
                responseType: AcuityReportUploadDataModel.VideoAnalysisResponse.self,
                token: EnvironmentVariable.ACCESS_TOKEN_AI,
                baseURL: APIConst.AI_Base_Url
            )
            Logger.shared.log(.debug, message: "\(responseModel.self)")
        } catch {
            throw APIError.customError(message: "Proctoring: \(error.localizedDescription)")
        }
    }
    
    private func postVideoParameters(videoPath: String) async throws {
        let model = AcuityReportUploadDataModel.EvaluateVideoParameterRequestModel(
            videoPath: videoPath,
            scenario: self.navModel.scenarioModel
        )
        
        do {
            let responseModel = try await ApiService.shared.postRequestAsyncWithCustomToken(
                model,
                payload: model.getPayload,
                responseType: AcuityReportUploadDataModel.ScenarioAnalysisResponse.self,
                token: EnvironmentVariable.ACCESS_TOKEN_AI,
                baseURL: APIConst.AI_Base_Url
            )
            
            Logger.shared.log(.debug, message: "\(responseModel.self)")
            self.scenarioAnalysisResponse = responseModel
            self.currentVideoPath = videoPath
            self.callPostUsageAPI(
                apiQueried: APIConst.AI_Base_Url + "/" + APIConst.courseBaseUrl + "/" + APIConst.evaluateVideoParameter,
                inputTokens: responseModel.usage?.llmInputTokens ?? 0,
                outputTokens: responseModel.usage?.llmOutputTokens ?? 0,
                totalToken: responseModel.usage?.llmTotalTokens ?? 0,
                sttMinutes: responseModel.usage?.sttMinutes ?? 0
            )
        } catch {
            throw APIError.customError(message: "Parameters: \(error.localizedDescription)")
        }
    }
    
    // MARK: Speech Analysis API
    private func callSpeechAnalysisAPI(videoPath: String) async throws {
        let model = AcuityReportUploadDataModel.SpeechAnalysisRequestModel(videoPath: videoPath)
        
        do {
            let response = try await ApiService.shared.postRequestAsyncWithCustomToken(
                model,
                payload: model.payload,
                responseType: AcuityReportUploadDataModel.SpeechAnalysisResponse.self,
                token: EnvironmentVariable.ACCESS_TOKEN_AI,
                baseURL: APIConst.AI_Base_Url
            )
            
            Logger.shared.log(.debug, message: "\(response.self)")
            self.speechAnalysisResponse = response
//            self.callSpeechInsightsAPI(videoPath: videoPath, speechAnalysisResponse: response)
        } catch {
            throw APIError.customError(message: "Speech: \(error.localizedDescription)")
        }
    }

    
    private func callPostUsageAPI(
        apiQueried: String,
        type: String = "AcuityIQ",
        inputTokens: Int,
        outputTokens: Int,
        contentLength: Int = 0,
        totalToken: Int,
        attemptId: Int = 0,
        sttMinutes: Double
    ) {
//        self.loadingState = .loading(title: "Posting Usage Data", message: "Please wait.")

        let payload = AcuityReportUploadDataModel.PostUsageRequestModel.Payload(
            apiQueried: apiQueried,
            type: type,
            inputTokens: inputTokens,
            outputTokens: outputTokens,
            contentLength: contentLength,
            totalToken: totalToken,
            attemptId: attemptId,
            sttMinutes: sttMinutes
        )

        let model = AcuityReportUploadDataModel.PostUsageRequestModel(payload: payload)

        Task { [weak self] in
            guard let self else { return }
            do {
                let response = try await ApiService.shared.requestPostHeader(
                    type: EmptyResponse.self,
                    model: model,
                    payload: payload
                )

                Logger.shared.log(.debug, message: "\(response.self)")
//                self.loadingState = .loaded

            } catch {
//                self.loadingState = .none
                toast = .init(style: .error, message: "Something went wrong!")
                Logger.shared.log(.error, message: "Error occured, api: \(model.path),\nerror: \(error.localizedDescription)\nref:\(self)")
            }
        }
    }

    // MARK: Speech Insights API
    private func callSpeechInsightsAPI(
        videoPath: String,
        speechAnalysisResponse: AcuityReportUploadDataModel.SpeechAnalysisResponse
    ) {
        guard let scenarioResponse = self.scenarioAnalysisResponse else {
            self.loadingState = .loaded
            return
        }

        self.loadingState = .loading(title: "Generating Insights", message: "Please wait.")

        let model = AcuityReportUploadDataModel.SpeechInsightsRequestModel(
            videoPath: videoPath,
            scenarioResponse: scenarioResponse,
            speechAnalysisResponse: speechAnalysisResponse
        )

        Task { [weak self] in
            guard let self else { return }
            do {
                let response = try await ApiService.shared.postRequestAsyncWithCustomToken(
                    model,
                    payload: model.payload,
                    responseType: AcuityReportUploadDataModel.SpeechInsightsResponse.self,
                    token: EnvironmentVariable.ACCESS_TOKEN_AI,
                    baseURL: APIConst.AI_Base_Url
                )

                Logger.shared.log(.debug, message: "\(response.self)")

                // Call AIData/PostUsage
                self.callPostUsageAPI(
                    apiQueried: APIConst.AI_Base_Url + "/" + APIConst.courseBaseUrl + "/" + APIConst.speechInsights,
                    inputTokens: response.usage?.llmInputTokens ?? 0,
                    outputTokens: response.usage?.llmOutputTokens ?? 0,
                    totalToken: response.usage?.llmTotalTokens ?? 0,
                    sttMinutes: response.usage?.sttMinutes ?? 0
                )

                // Call PostAnalysis API
                self.callPostAnalysisAPI(
                    videoPath: videoPath,
                    speechInsightsResponse: response
                )
            } catch {
                self.loadingState = .none
                Logger.shared.log(.error, message: "Error occured, api: \(model.path),\nerror: \(error.localizedDescription)\nref:\(self)")
            }
        }
    }

    // MARK: Post Analysis API
    private func callPostAnalysisAPI(
        videoPath: String,
        speechInsightsResponse: AcuityReportUploadDataModel.SpeechInsightsResponse
    ) {
        
        Task { [weak self] in
            guard let self else { return }
            
            let moduleAttemptId: Int?
            moduleAttemptId = self.navModel.isFromModule ? await callMarkModuleAttempt() : nil
            
            guard let scenarioResponse = self.scenarioAnalysisResponse,
                  let speechAnalysisResponse = self.speechAnalysisResponse else {
                self.loadingState = .loaded
                return
            }
            
            self.loadingState = .loading(title: "Saving Analysis Report", message: "Please wait.")
            
            let model = AcuityReportUploadDataModel.PostAnalysisRequestModel(
                scenarioResponse: scenarioResponse,
                speechAnalysisResponse: speechAnalysisResponse,
                speechInsightsResponse: speechInsightsResponse,
                videoPath: videoPath,
                scenarioId: navModel.scenarioModel.scenarioId,
                moduleId: navModel.moduleId,
                courseId: navModel.courseId,
                moduleAttemptId: moduleAttemptId
            )
            
            do {
                let response = try await ApiService.shared.requestPostHeader(
                    type: AcuityReportUploadDataModel.PostAnalysisResponse.self,
                    model: model,
                    payload: model.payload
                )
                
                Logger.shared.log(.debug, message: "\(response.self)")
                self.loadingState = .loaded
                self.toast = Toast(style: .success, message: response.message ?? "Analysis saved successfully")
                self.attemptRemaining = max(0, self.attemptRemaining - 1)
                self.selectedFileName = nil
                
            } catch {
                self.loadingState = .none
                Logger.shared.log(.error, message: "Error occured, api: \(model.path),\nerror: \(error.localizedDescription)\nref:\(self)")
            }
        }
    }

}
