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
    ///   - scenarioId: The scenario ID for upload
    ///   - onDismiss: Optional callback when the user dismisses the flow
    @MainActor
    public func showReportUpload(
        router: AnyRouter,
        scenarioId: Int,
        onDismiss: (() -> Void)? = nil
    ) {
        AcuityIQNavigationService.shared.showReportUpload(
            router: router,
            scenarioId: scenarioId,
            onDismiss: onDismiss
        )
    }
}
