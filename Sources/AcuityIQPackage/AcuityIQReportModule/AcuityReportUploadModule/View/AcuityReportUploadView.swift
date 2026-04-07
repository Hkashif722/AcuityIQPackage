//
//  AcuityReportUploadView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 05/04/26.
//

import SwiftUI
import SwiftUIUtilities
import SwiftfulRouting

struct AcuityReportUploadView: View {

    @StateObject private var viewModel: AcuityReportUploadViewModel

    init(router: AnyRouter, navModel: NavigationViewModel.AcuityReportUploadNavModel) {
        _viewModel = StateObject(wrappedValue: AcuityReportUploadViewModel(router: router, navModel: navModel))
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
        .loadingOverlayViewPkg(state: viewModel.loadingState)
        .toastViewPkg(toast: $viewModel.toast)
    }
}

// MARK: - Subviews

extension AcuityReportUploadView {

    private var topCardView: some View {
        UploadTopCardView(
            title: viewModel.navModel.scenarioModel.scenarioName ?? "",
            description: viewModel.navModel.scenarioModel.scenarioDescription ?? ""
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
            selectedFileName: viewModel.selectedFileName,
            onBrowseFiles: viewModel.didTapBrowseFiles,
            onAnalyse: viewModel.didTapAnalyse
        )
    }

    private var previewSection: some View {
        UploadPreviewSectionView(
            items: AcuityReportUploadDataModel.previewItems(
                refVideo: viewModel.navModel.scenarioModel.referenceVideo,
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
            navModel: NavigationViewModel.AcuityReportUploadNavModel(
                scenarioModel: AcuityIQReportDataModel.Scenario.preview,
                moduleId: nil,
                courseId: nil,
                moduleAttemptId: nil
            )
        )
    }
}
