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
                self.loadingState = .loaded
                
            } catch {
                self.loadingState = .none
                Logger.shared.log(.error, message: "Error occured, api: \(model.path),\nerror: \(error.localizedDescription)\nrefL\(self)")
            }
        }
    }
}
