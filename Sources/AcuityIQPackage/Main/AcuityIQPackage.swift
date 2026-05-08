// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
import SwiftfulRouting
import SwiftUIUtilities

public struct AcuityIQKit: Sendable {

    public init(config: AcuityIQPackageConfig) async {
        await AcuityIQAPIManager.shared.configure(config)
    }

    /// Shows the AcuityIQ Report List view
    /// - Parameters:
    ///   - router: The router to use for navigation
    ///   - onDismiss: Optional callback when the user dismisses the flow
    @MainActor
    public func showReportList(
        router: AnyRouter,
        onDismiss: (() -> Void)? = nil
    ) {
        AcuityIQNavigationService.shared.showReportList(
            router: router,
            onDismiss: onDismiss
        )
    }

    /// Shows the AcuityIQ Report Upload view
    /// - Parameters:
    ///   - router: The router to use for navigation
    ///   - projectID: The project ID (corresponds to scenarioId)
    ///   - moduleId: Optional module ID
    ///   - moduleStatus: Optional module status
    ///   - courseId: Optional course ID
    ///   - attempt: Optional tuple containing total and remaining attempts
    ///   - moduleAttempts: Optional array of module attempt metadata dictionaries
    ///   - onDismiss: Optional callback when the user dismisses the flow
    @MainActor
    public func showReportUpload(
        router: AnyRouter,
        projectID: Int,
        moduleId: Int? = nil,
        moduleStatus: String? = nil,
        courseId: Int? = nil,
        attempt: (total: Int?, left: Int?)? = nil,
        moduleAttempts: [[String: Any]]? = nil,
        onDismiss: (() -> Void)? = nil
    ) {
        AcuityIQ.shared.showReportUpload(
            router: router,
            projectID: projectID,
            moduleId: moduleId,
            moduleStatus: moduleStatus,
            courseId: courseId,
            attempt: attempt,
            moduleAttempts: moduleAttempts,
            onDismiss: onDismiss
        )
    }
}
