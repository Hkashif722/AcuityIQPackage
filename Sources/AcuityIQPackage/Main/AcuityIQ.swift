//
//  AcuityIQ.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 05/04/26.
//

import UIKit
import SwiftUI
import SwiftfulRouting
import SwiftUIUtilities

// MARK: - AcuityIQ (Main Entry Point)

/// Main entry point for AcuityIQ SDK.
/// Use `AcuityIQ.shared` to configure and present AcuityIQ views.
///
/// Example usage (UIKit):
/// ```swift
/// // 1. Configure once at app launch
/// await AcuityIQ.shared.configure(with: config)
///
/// // 2. Present from any UIViewController
/// viewController.presentAcuityReportList()
/// ```
///
/// Example usage (SwiftUI with Router):
/// ```swift
/// // In your SwiftUI view with router
/// Button("Open Reports") {
///     AcuityIQ.shared.showReportList(router: router)
/// }
/// ```
@MainActor
public final class AcuityIQ {

    // MARK: - Singleton

    public static let shared = AcuityIQ()

    private init() {}

    // MARK: - Properties

    private var acuityIQKit: AcuityIQKit?
    private(set) public var isConfigured: Bool = false

    // MARK: - Configuration

    /// Configure AcuityIQ SDK. Must be called before presenting any views.
    /// - Parameter config: The configuration containing API URLs, credentials, and token provider
    public func configure(with config: AcuityIQPackageConfig) async {
        acuityIQKit = await AcuityIQKit(config: config)
        isConfigured = true
    }

    // MARK: - SwiftUI Presentation (with Router)

    /// Show AcuityIQ Report List using SwiftfulRouting
    /// Use this when your SwiftUI app already has a router
    /// - Parameters:
    ///   - router: The AnyRouter instance from SwiftfulRouting
    ///   - onDismiss: Optional callback when the flow is dismissed
    public func showReportList(
        router: AnyRouter,
        onDismiss: (() -> Void)? = nil
    ) {
        guard isConfigured else {
            assertionFailure("AcuityIQ not configured. Call AcuityIQ.shared.configure(with:) first.")
            return
        }

        AcuityIQNavigationService.shared.showReportList(
            router: router,
            onDismiss: onDismiss
        )
    }

    /// Show AcuityIQ Report Upload using SwiftfulRouting
    /// Use this when your SwiftUI app already has a router
    /// - Parameters:
    ///   - router: The AnyRouter instance from SwiftfulRouting
    ///   - scenarioId: The scenario ID for upload
    ///   - onDismiss: Optional callback when the flow is dismissed
    public func showReportUpload(
        router: AnyRouter,
        scenarioId: Int,
        onDismiss: (() -> Void)? = nil
    ) {
        guard isConfigured else {
            assertionFailure("AcuityIQ not configured. Call AcuityIQ.shared.configure(with:) first.")
            return
        }

        AcuityIQNavigationService.shared.showReportUpload(
            router: router,
            scenarioId: scenarioId,
            onDismiss: onDismiss
        )
    }

    // MARK: - UIKit Presentation (from UIViewController)

    /// Present AcuityIQ Report List from a UIViewController
    /// - Parameters:
    ///   - viewController: The view controller to present from
    ///   - animated: Whether to animate the presentation (default: true)
    ///   - completion: Optional completion handler called when presentation is complete
    public func presentReportList(
        from viewController: UIViewController,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        guard isConfigured else {
            assertionFailure("AcuityIQ not configured. Call AcuityIQ.shared.configure(with:) first.")
            return
        }

        let hasNavigationController = viewController.navigationController != nil

        let wrapperView = AcuityReportListContainerView(
            onDismiss: { [weak viewController] in
                if let nav = viewController?.navigationController {
                    nav.popViewController(animated: animated)
                } else {
                    viewController?.dismiss(animated: animated, completion: completion)
                }
            }
        )

        let hostingController = AcuityHostingController(rootView: wrapperView)
        hostingController.hidesBottomBarWhenPushed = true
        hostingController.shouldHideNavigationBar = hasNavigationController
        hostingController.view.tintColor = .label

        if let navigationController = viewController.navigationController {
            navigationController.pushViewController(hostingController, animated: animated)
            completion?()
        } else {
            hostingController.modalPresentationStyle = .fullScreen
            viewController.present(hostingController, animated: animated, completion: completion)
        }
    }

    /// Present AcuityIQ Report Upload from a UIViewController
    /// - Parameters:
    ///   - viewController: The view controller to present from
    ///   - scenarioId: The scenario ID for upload
    ///   - animated: Whether to animate the presentation (default: true)
    ///   - completion: Optional completion handler called when presentation is complete
    public func presentReportUpload(
        from viewController: UIViewController,
        model: NavigationViewModel.AcuityReportUploadNavModel,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        guard isConfigured else {
            assertionFailure("AcuityIQ not configured. Call AcuityIQ.shared.configure(with:) first.")
            return
        }

        let hasNavigationController = viewController.navigationController != nil

        let wrapperView = AcuityReportUploadContainerView(
            navModel: model,
            onDismiss: { [weak viewController] in
                if let nav = viewController?.navigationController {
                    nav.popViewController(animated: animated)
                } else {
                    viewController?.dismiss(animated: animated, completion: completion)
                }
            }
        )

        let hostingController = AcuityHostingController(rootView: wrapperView)
        hostingController.hidesBottomBarWhenPushed = true
        hostingController.shouldHideNavigationBar = hasNavigationController

        if let navigationController = viewController.navigationController {
            navigationController.pushViewController(hostingController, animated: animated)
            completion?()
        } else {
            hostingController.modalPresentationStyle = .fullScreen
            viewController.present(hostingController, animated: animated, completion: completion)
        }
    }
}

// MARK: - AcuityHostingController

/// Custom hosting controller that hides UIKit navigation bar to avoid double navigation
private final class AcuityHostingController<Content: View>: UIHostingController<Content> {

    var shouldHideNavigationBar: Bool = false

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if shouldHideNavigationBar {
            navigationController?.setNavigationBarHidden(true, animated: animated)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if shouldHideNavigationBar {
            navigationController?.setNavigationBarHidden(false, animated: animated)
        }
    }
}

// MARK: - SwiftUI View Extension

public extension View {

    /// Navigate to AcuityIQ Report List
    /// Use this modifier when you have access to a router in your SwiftUI view
    /// - Parameters:
    ///   - router: The AnyRouter instance
    ///   - onDismiss: Optional callback when dismissed
    func navigateToAcuityReportList(
        router: AnyRouter,
        onDismiss: (() -> Void)? = nil
    ) {
        AcuityIQ.shared.showReportList(router: router, onDismiss: onDismiss)
    }

    /// Navigate to AcuityIQ Report Upload
    /// Use this modifier when you have access to a router in your SwiftUI view
    /// - Parameters:
    ///   - router: The AnyRouter instance
    ///   - scenarioId: The scenario ID for upload
    ///   - onDismiss: Optional callback when dismissed
    func navigateToAcuityReportUpload(
        router: AnyRouter,
        scenarioId: Int,
        onDismiss: (() -> Void)? = nil
    ) {
        AcuityIQ.shared.showReportUpload(router: router, scenarioId: scenarioId, onDismiss: onDismiss)
    }
}

// MARK: - Container Views (for UIKit presentation)

private struct AcuityReportListContainerView: View {
    let onDismiss: () -> Void

    var body: some View {
        RouterView { router in
            AcuityReportListView(router: router)
                .navigationTitle("Reports")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        BackButton(action: onDismiss)
                    }
                }
        }
    }
}

private struct AcuityReportUploadContainerView: View {
    let navModel: NavigationViewModel.AcuityReportUploadNavModel
    let onDismiss: () -> Void

    var body: some View {
        RouterView { router in
            AcuityReportUploadView(
                router: router,
                navModel: navModel
            )
            .navigationTitle("Upload Report")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    BackButton(action: onDismiss)
                }
            }
        }
    }
}

private struct BackButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: "chevron.left")
                Text("Back")
            }
        }
    }
}
