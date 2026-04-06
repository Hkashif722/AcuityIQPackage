//
//  AcuityReportUploadView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 05/04/26.
//

import SwiftUI
import SwiftUIUtilities

public struct AcuityReportUploadView: View {

    @StateObject private var viewModel: AcuityReportUploadViewModel

    public init(router: AnyRouter, scenario: AcuityIQReportDataModel.Scenario) {
        _viewModel = StateObject(wrappedValue: AcuityReportUploadViewModel(router: router, scenario: scenario))
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                topCardView
                actionButtonsView
                videoUploadSection
                previewSection
                Spacer()
            }
            .padding()
        }
        .sheet(isPresented: $viewModel.showVideoPicker) {
            VideoPicker { url in
                viewModel.didSelectVideo(url: url)
            }
        }
        .toastView(toast: $viewModel.toast)
    }
}

// MARK: - Subviews

extension AcuityReportUploadView {

    private var topCardView: some View {
        UploadTopCardView(
            title: viewModel.scenarioTitle,
            description: viewModel.scenarioDescription
        )
    }

    private var actionButtonsView: some View {
        UploadActionButtonsView(
            buttons: AcuityReportUploadDataModel.actionButtons(
                onEvaluationCriteria: viewModel.didTapEvaluationCriteria,
                onKeywords: viewModel.didTapKeywords
            )
        )
    }

    private var videoUploadSection: some View {
        VideoUploadSectionView(
            selectedFileURL: viewModel.selectedFileURL,
            onBrowseFiles: viewModel.didTapBrowseFiles,
            onAnalyse: viewModel.didTapAnalyse
        )
    }

    private var previewSection: some View {
        UploadPreviewSectionView(
            items: AcuityReportUploadDataModel.previewItems(
                onProductKnowledge: viewModel.didTapProductKnowledge,
                onReferenceVideo: viewModel.didTapReferenceVideo
            )
        )
    }
}

#Preview {
    RouterView { router in
        AcuityReportUploadView(
            router: router,
            scenario: AcuityReportUploadDataModel.previewScenario
        )
    }
}
