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
    ///   - scenarioId: The scenario ID for upload
    ///   - onDismiss: Optional callback when the user dismisses the flow
    public func showReportUpload(
        router: AnyRouter,
        scenarioId: Int,
        onDismiss: (() -> Void)? = nil
    ) {
        self.currentRouter = router
        self.onDismissCallback = onDismiss

        router.showScreen(.push) { router in
//            AcuityReportUploadView(router: router, scenarioId: scenarioId)
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
