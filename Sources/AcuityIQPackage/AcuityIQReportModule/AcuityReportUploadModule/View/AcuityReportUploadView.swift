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
        .navigationTitle("Attempt left:")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                scenarioAttempBadgeView
            }
        }
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
            attemptExausted: viewModel.isAttemptExausted,
            selectedFileName: viewModel.selectedFileName,
            onBrowseFiles: viewModel.didTapBrowseFiles,
            onAnalyse: viewModel.didTapAnalyse
        )
    }

    private var previewSection: some View {
        UploadPreviewSectionView(
            attemptExausted: viewModel.isAttemptExausted,
            items: AcuityReportUploadDataModel.previewItems(
                refVideo: viewModel.navModel.scenarioModel.referenceVideo,
                onProductKnowledge: viewModel.didTapProductKnowledge,
                onReferenceVideo: viewModel.didTapReferenceVideo
            )
        )
    }
    
    private var scenarioAttempBadgeView: some View {
        HStack {
            Image(systemName: "arrow.triangle.2.circlepath")
                .font(.caption)
                .foregroundStyle(viewModel.scenarioModel.progressBadgeColor)
            
            Text("\(viewModel.attemptRemaining) / \(viewModel.totalAttempts)")
                .font(.caption.bold())
                .foregroundColor(viewModel.scenarioModel.progressBadgeColor)
                
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(viewModel.scenarioModel.progressBadgeColor.opacity(0.15))
        .cornerRadius(12)
    }
}

#Preview {
    RouterView { router in
        AcuityReportUploadView(
            router: router,
            navModel: NavigationViewModel.AcuityReportUploadNavModel(
                scenarioModel: AcuityIQReportDataModel.Scenario.preview,
                isFromModule: true,
                projectID: 120,
                moduleId: nil,
                courseId: nil
            )
        )
    }
}
