//
//  EvaluateModuleViewModel.swift
//  AcuityIQPackage
//

import Foundation
import SwiftUIUtilities
import SwiftfulRouting
import NetworkService

class EvaluateModuleViewModel: RoutableViewModel {

    // MARK: - Navigation Model
    let navModel: NavigationViewModel.EvaluateModuleNavModel

    // MARK: - Published State
    @Published var formEntries: [EvaluateModuleDataModel.EvaluationFormEntry] = []
    @Published var overallScoreText: String = "" {
        didSet {
            let filtered = Self.filterOneDecimalPlace(overallScoreText)
            if filtered != overallScoreText { overallScoreText = filtered }
        }
    }

    private var attempt: ManagerEvaluationListDataModel.ScenarioAttempt.Attempt { navModel.attempt }
    private var scenario: ManagerEvaluationListDataModel.ScenarioAttempt { navModel.scenario }

    // MARK: - Init
    init(router: AnyRouter, navModel: NavigationViewModel.EvaluateModuleNavModel) {
        self.navModel = navModel
        super.init(router: router)
        buildFormEntries()
    }
}

// MARK: - Setup
extension EvaluateModuleViewModel {

    private func buildFormEntries() {
        let parameters = scenario.evaluationParameters ?? []
        formEntries = parameters.map { param in
            let maxScore = Int(param.weightage ?? "") ?? 10
            return EvaluateModuleDataModel.EvaluationFormEntry(
                parameter: param.name ?? "—",
                maxScore: maxScore
            )
        }
    }
}

// MARK: - Actions
extension EvaluateModuleViewModel {

    func didTapSubmit() {
        guard validate() else { return }
        Task { [weak self] in
            await self?.submitEvaluation()
        }
    }
}

// MARK: - Validation
private extension EvaluateModuleViewModel {

    func validate() -> Bool {
        for entry in formEntries {
            guard let score = Double(entry.scoreText), !entry.scoreText.isEmpty else {
                toast = Toast(style: .warning, message: "Please enter a score for \"\(entry.parameter)\".")
                return false
            }
            if score < 1 || score > Double(entry.maxScore) {
                toast = Toast(style: .warning, message: "Score for \"\(entry.parameter)\" must be between 1 and \(entry.maxScore).")
                return false
            }
        }
        guard let overall = Double(overallScoreText), !overallScoreText.isEmpty else {
            toast = Toast(style: .warning, message: "Please enter an overall score.")
            return false
        }
        if overall < 0 || overall > 10 {
            toast = Toast(style: .warning, message: "Overall score must be between 0 and 10.")
            return false
        }
        return true
    }
}

// MARK: - Input Filtering
private extension EvaluateModuleViewModel {

    static func filterOneDecimalPlace(_ input: String) -> String {
        var result = input.filter { $0.isNumber || $0 == "." }
        if let dotIndex = result.firstIndex(of: ".") {
            let afterDot = result.index(after: dotIndex)
            let decimals = result[afterDot...].filter { $0.isNumber }
            result = String(result[..<dotIndex]) + "." + String(decimals.prefix(1))
        }
        return result
    }
}

// MARK: - API
private extension EvaluateModuleViewModel {

    func submitEvaluation() async {
        loadingState = .loading(message: "Submitting evaluation...")
        do {
            let evaluationData = formEntries.map {
                EvaluateModuleDataModel.PostManagerEvaluationRequest.EvaluationEntry(
                    parameter: $0.parameter,
                    score: Double($0.scoreText) ?? 0,
                    remarks: $0.remarks
                )
            }
            let payload = EvaluateModuleDataModel.PostManagerEvaluationRequest.Payload(
                attemptId: attempt.attemptId,
                evaluationData: evaluationData,
                scenarioType: scenario.scenarioType ?? "acuityiq",
                overallScore: Double(overallScoreText) ?? 0
            )
            let model = EvaluateModuleDataModel.PostManagerEvaluationRequest(payload: payload)
            _ = try await ApiService.shared.requestPostHeader(
                type: EvaluateModuleDataModel.PostManagerEvaluationResponse.self,
                model: model,
                payload: model.payload
            )
            loadingState = .none
            toast = Toast(style: .success, message: "Evaluation submitted successfully.")
            NotificationCenter.default.post(
                name: .managerEvaluationSubmitted,
                object: nil,
                userInfo: [
                    "attemptId": attempt.attemptId,
                    "overallScore": Double(overallScoreText) ?? 0
                ]
            )
            try? await Task.sleep(nanoseconds: 1_500_000_000)
            await MainActor.run { goBack() }
        } catch let error as APIError {
            handleAPIError(error.toUIError(), resetLoadingState: true, showToast: true)
        } catch {
            handleAPIError(error, resetLoadingState: true, showToast: true)
        }
    }
}
