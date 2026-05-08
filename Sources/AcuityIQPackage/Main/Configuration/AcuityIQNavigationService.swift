//
//  AcuityIQNavigationService.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 05/04/26.
//

import Foundation
import SwiftUI
import SwiftfulRouting
import SwiftUIUtilities

// MARK: - AcuityIQNavigationService

@MainActor
public class AcuityIQNavigationService {

    // MARK: - Singleton

    public static let shared = AcuityIQNavigationService()

    private init() {}

    // MARK: - Properties

    private var currentRouter: AnyRouter?
    private var onDismissCallback: (() -> Void)?

    // MARK: - Public Methods - Report List Entry Point

    /// Navigates to the AcuityReportListView
    /// - Parameters:
    ///   - router: The router to use for navigation
    ///   - onDismiss: Optional callback when the user dismisses the flow
    public func showReportList(
        router: AnyRouter,
        onDismiss: (() -> Void)? = nil
    ) {
        self.currentRouter = router
        self.onDismissCallback = onDismiss

        router.showScreen(.push) { router in
            AcuityReportListView(router: router)
        }
    }

    // MARK: - Public Methods - Report Upload Entry Point

    /// Navigates to the AcuityReportUploadView
    /// - Parameters:
    ///   - router: The router to use for navigation
    ///   - navModel: The navigation model containing scenario and upload context
    ///   - onDismiss: Optional callback when the user dismisses the flow
    func showReportUpload(
        router: AnyRouter,
        navModel: NavigationViewModel.AcuityReportUploadNavModel,
        onDismiss: (() -> Void)? = nil
    ) {
        self.currentRouter = router
        self.onDismissCallback = onDismiss

        router.showScreen(.push) { router in
            AcuityReportUploadView(router: router, navModel: navModel)
        }
    }

    // MARK: - Public Methods - Manager Evaluation List Entry Point

    /// Navigates to the ManagerEvaluationListView
    /// - Parameters:
    ///   - router: The router to use for navigation
    ///   - onDismiss: Optional callback when the user dismisses the flow
    public func showManagerEvaluationList(
        router: AnyRouter,
        userID: Int? = nil,
        onDismiss: (() -> Void)? = nil
    ) {
        self.currentRouter = router
        self.onDismissCallback = onDismiss

        router.showScreen(.push) { router in
            ManagerEvaluationListView(router: router, userID: userID)
        }
    }

    // MARK: - Public Methods - Role Play Dashboard Entry Point

    /// Navigates to the RolePlayDashboardView
    /// - Parameters:
    ///   - router: The router to use for navigation
    ///   - navModel: The navigation model containing role play context
    ///   - onDismiss: Optional callback when the user dismisses the flow
    public func showRolePlayDashboard(
        router: AnyRouter,
        rolePlayTitle: String,
        projectID: Int? = nil,
        moduleId: Int? = nil,
        moduleStatus: String? = nil,
        courseId: Int? = nil,
        attempt: (total: Int?, left: Int?)? = nil,
        moduleAttempts: [[String: Any]]? = nil,
        evaluationParameters: [[String: Any]]? = nil,
        keywords: [String]? = nil,
        onDismiss: (() -> Void)? = nil
    ) {
        self.currentRouter = router
        self.onDismissCallback = onDismiss
        let navModel = NavigationViewModel.RolePlayDashboardNavModel(
            rolePlayTitle: rolePlayTitle,
            projectID: projectID,
            moduleId: moduleId,
            moduleStatus: moduleStatus,
            courseId: courseId,
            attempt: attempt,
            moduleAttempts: moduleAttempts,
            evaluationParameters: evaluationParameters,
            keywords: keywords
        )
        router.showScreen(.push) { router in
            RolePlayDashboardView(router: router, navModel: navModel)
        }
    }

    // MARK: - Helper Methods

    private func showErrorAlert(message: String) {
        guard let router = currentRouter else { return }

        router.showAlert(
            .alert,
            title: "Error",
            subtitle: message
        ) {
            Button("OK") {
                router.dismissAlert()
            }
        }
    }

    /// Dismisses the current flow and calls the dismiss callback
    public func dismissFlow() {
        onDismissCallback?()
        resetState()
    }

    private func resetState() {
        currentRouter = nil
        onDismissCallback = nil
    }
}
