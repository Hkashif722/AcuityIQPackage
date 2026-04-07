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

    let navModel: NavigationViewModel.AcuityReportUploadNavModel

    // MARK: - Private Properties
    private var scenarioAnalysisResponse: AcuityReportUploadDataModel.ScenarioAnalysisResponse?
    private var speechAnalysisResponse: AcuityReportUploadDataModel.SpeechAnalysisResponse?
    private var currentVideoPath: String?

    // MARK: - Computed Properties

    var hasFileSelected: Bool {
        selectedFileName != nil
    }

    // MARK: - Initialization

    init(router: AnyRouter, navModel: NavigationViewModel.AcuityReportUploadNavModel) {
        self.navModel = navModel
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
            
            self.postOJTFile(fileURL: url)
        }
        NavigationService.shared.navigate(using: router, to: .showVideoPickerView(navModel))
    }

    func didTapAnalyse() {
        guard let _ = selectedFileName else { return }
        // TODO: Implement video upload and analysis
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
        // TODO: Navigate to document viewer
        print("Product Knowledge tapped: \(knowledgeDocument)")
    }

    func didTapReferenceVideo() {
        guard let referenceVideo = navModel.scenarioModel.referenceVideo,
              !referenceVideo.isEmpty else {
            toast = Toast(style: .info, message: "Reference video is not available.")
            return
        }
        // TODO: Navigate to video player
        print("Reference Video tapped: \(referenceVideo)")
    }
}

// MARK: API Call
extension AcuityReportUploadViewModel {
    //Post file upload:
    private func postOJTFile(fileURL: URL) {
        
        let uploadGoalTask = Task { [weak self] in
            
            guard let self = self else { return }
            
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
                        self.postProctoringData(videoPath: ResourceUtils.getResourcPath(filePath))
                        
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
    
    // MARK: Post Proctoring
    private func postProctoringData(videoPath: String)  {
        
        self.loadingState = .loading(title: "Fetching Video Analysis", message: "Please wait.")
        let model = AcuityReportUploadDataModel.PostVideoProctoring(videoPath: videoPath)
        Task { [weak self] in
            guard let self else { return }
            do {
                
                let responseModel = try await ApiService.shared.postRequestAsyncWithCustomToken(
                    model,
                    payload: model.payload,
                    responseType: AcuityReportUploadDataModel.VideoAnalysisResponse.self,
                    token: EnvironmentVariable.ACCESS_TOKEN_AI,
                    baseURL: APIConst.AI_Base_Url
                )
                
                Logger.shared.log(.debug, message: "\(responseModel.self)")
                self.postVideoParameters(videoPath: videoPath)
                
            } catch {
                self.loadingState = .none
                Logger.shared.log(.error, message: "Error occured, api: \(model.path),\nerror: \(error.localizedDescription)\nrefL\(self)")
            }
        }
    }
    
    private func postVideoParameters(videoPath: String) {
        self.loadingState = .loading(title: "Evaluating Video Parameters", message: "Please wait.")
        let model = AcuityReportUploadDataModel.EvaluateVideoParameterRequestModel(videoPath: videoPath, scenario: self.navModel.scenarioModel)
        
        Task { [weak self] in
            guard let self else { return }
            
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
                self.callSpeechAnalysisAPI(videoPath: videoPath)
                
            } catch {
                self.loadingState = .none
                Logger.shared.log(.error, message: "Error occured, api: \(model.path),\nerror: \(error.localizedDescription)\nrefL\(self)")
            }
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
        self.loadingState = .loading(title: "Posting Usage Data", message: "Please wait.")

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
                self.loadingState = .loaded

            } catch {
                self.loadingState = .none
                Logger.shared.log(.error, message: "Error occured, api: \(model.path),\nerror: \(error.localizedDescription)\nref:\(self)")
            }
        }
    }

    // MARK: Speech Analysis API
    private func callSpeechAnalysisAPI(videoPath: String) {
        self.loadingState = .loading(title: "Analyzing Speech", message: "Please wait.")

        let model = AcuityReportUploadDataModel.SpeechAnalysisRequestModel(videoPath: videoPath)

        Task { [weak self] in
            guard let self else { return }
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
                self.callSpeechInsightsAPI(videoPath: videoPath, speechAnalysisResponse: response)

            } catch {
                self.loadingState = .none
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
            scenarioId: navModel.scenarioModel.scenarioId ?? 0,
            moduleId: navModel.moduleId,
            courseId: navModel.courseId,
            moduleAttemptId: navModel.moduleAttemptId
        )

        Task { [weak self] in
            guard let self else { return }
            do {
                let response = try await ApiService.shared.requestPostHeader(
                    type: AcuityReportUploadDataModel.PostAnalysisResponse.self,
                    model: model,
                    payload: model.payload
                )

                Logger.shared.log(.debug, message: "\(response.self)")
                self.loadingState = .loaded
                self.toast = Toast(style: .success, message: response.message ?? "Analysis saved successfully")

            } catch {
                self.loadingState = .none
                Logger.shared.log(.error, message: "Error occured, api: \(model.path),\nerror: \(error.localizedDescription)\nref:\(self)")
            }
        }
    }

}
