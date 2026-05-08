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
import NetworkService

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
/// viewController.presentRolePlayDashboard(projectID: 123, attempt: nil)
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
}

// MARK: - SwiftUI Presentation (with Router)

extension AcuityIQ {

    /// Show AcuityIQ Report List using SwiftfulRouting.
    /// Use this when your SwiftUI app already has a router.
    /// - Parameters:
    ///   - router: The AnyRouter instance from SwiftfulRouting
    ///   - onDismiss: Optional callback when the flow is dismissed
    public func showReportList(
        router: AnyRouter,
        onDismiss: (() -> Void)? = nil
    ) {
        guard checkConfigured() else { return }
        AcuityIQNavigationService.shared.showReportList(router: router, onDismiss: onDismiss)
    }

    /// Show AcuityIQ Report Upload using SwiftfulRouting.
    /// Use this when your SwiftUI app already has a router.
    /// - Parameters:
    ///   - router: The AnyRouter instance from SwiftfulRouting
    ///   - projectID: The project ID used to fetch and match the scenario
    ///   - moduleId: Optional module ID
    ///   - moduleStatus: Optional module status
    ///   - courseId: Optional course ID
    ///   - attempt: Optional tuple containing total and remaining attempts
    ///   - moduleAttempts: Optional array of module attempt metadata dictionaries
    ///   - onDismiss: Optional callback when the flow is dismissed
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
        guard checkConfigured() else { return }

        Task { @MainActor in
            do {
                guard let matchedScenario = try await fetchScenario(for: projectID) else { return }

                let navModel = NavigationViewModel.AcuityReportUploadNavModel(
                    scenarioModel: matchedScenario,
                    isFromModule: true,
                    projectID: projectID,
                    moduleId: moduleId,
                    moduleStatus: moduleStatus,
                    courseId: courseId,
                    attempt: attempt,
                    moduleAttempts: moduleAttempts
                )
                AcuityIQNavigationService.shared.showReportUpload(router: router, navModel: navModel, onDismiss: onDismiss)
            } catch {
                Logger.shared.log(.error, message: "Error fetching scenarios: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - SwiftUI Presentation (Manager Evaluation List)

extension AcuityIQ {

    /// Show Manager Evaluation List using SwiftfulRouting.
    /// Use this when your SwiftUI app already has a router.
    /// - Parameters:
    ///   - router: The AnyRouter instance from SwiftfulRouting
    ///   - onDismiss: Optional callback when the flow is dismissed
    public func showManagerEvaluationList(
        router: AnyRouter,
        userID: Int? = nil,
        onDismiss: (() -> Void)? = nil
    ) {
        guard checkConfigured() else { return }
        AcuityIQNavigationService.shared.showManagerEvaluationList(router: router, userID: userID, onDismiss: onDismiss)
    }
}

// MARK: - SwiftUI Presentation (Role Play Dashboard)

extension AcuityIQ {

    /// Show Role Play Dashboard using SwiftfulRouting.
    /// Use this when your SwiftUI app already has a router.
    /// - Parameters:
    ///   - router: The AnyRouter instance from SwiftfulRouting
    ///   - rolePlayTitle: The title for the role play session
    ///   - projectID: The project ID for this role play session
    ///   - onDismiss: Optional callback when the flow is dismissed
    public func showRolePlayDashboard(
        router: AnyRouter,
        rolePlayTitle: String,
        projectID: Int,
        moduleId: Int? = nil,
        moduleStatus: String? = nil,
        courseId: Int? = nil,
        attempt: (total: Int?, left: Int?)? = nil,
        moduleAttempts: [[String: Any]]? = nil,
        evaluationParameters: [[String: Any]]? = nil,
        keywords: [String]? = nil,
        onDismiss: (() -> Void)? = nil
    ) {
        guard checkConfigured() else { return }

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
        AcuityIQNavigationService.shared.showRolePlayDashboard(
            router: router,
            rolePlayTitle: navModel.rolePlayTitle,
            projectID: navModel.projectID,
            moduleId: navModel.moduleId,
            moduleStatus: navModel.moduleStatus,
            courseId: navModel.courseId,
            attempt: navModel.attempt,
            moduleAttempts: navModel.moduleAttempts,
            evaluationParameters: navModel.evaluationParameters,
            keywords: navModel.keywords,
            onDismiss: onDismiss
        )
    }
}

// MARK: - UIKit Presentation (Manager Evaluation List)

extension AcuityIQ {

    /// Present Manager Evaluation List from a UIViewController.
    /// - If embedded in a UINavigationController, pushes the view.
    /// - Otherwise, presents modally in full screen.
    /// - Parameters:
    ///   - viewController: The view controller to present from
    ///   - animated: Whether to animate the presentation (default: true)
    ///   - completion: Optional completion handler called when presentation is complete
    public func presentManagerEvaluationList(
        from viewController: UIViewController,
        userID: Int? = nil,
        hideToolbar: Bool = false,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        guard checkConfigured() else { return }

        let wrapperView = ManagerEvaluationListContainerView(
            userID: userID,
            hideToolbar: hideToolbar,
            onDismiss: dismissHandler(for: viewController, animated: animated, completion: completion)
        )
        pushOrPresent(wrapperView, from: viewController, animated: animated, completion: completion)
    }

    /// Returns a standalone UIViewController containing the Manager Evaluation List.
    /// Use this to embed the list as a child VC inside a page menu or tab layout.
    public func managerEvaluationListViewController(userID: Int? = nil, hideToolbar: Bool = false) -> UIViewController {
        let container = ManagerEvaluationListContainerView(userID: userID, hideToolbar: hideToolbar ,onDismiss: {})
        let hostVC = AcuityHostingController(rootView: container)
        hostVC.shouldHideNavigationBar = false
        return hostVC
    }
}

// MARK: - UIKit Presentation (AcuityIQ Report)

extension AcuityIQ {

    /// Present AcuityIQ Report List from a UIViewController.
    /// - If embedded in a UINavigationController, pushes the view.
    /// - Otherwise, presents modally in full screen.
    /// - Parameters:
    ///   - viewController: The view controller to present from
    ///   - animated: Whether to animate the presentation (default: true)
    ///   - completion: Optional completion handler called when presentation is complete
    public func presentReportList(
        from viewController: UIViewController,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        guard checkConfigured() else { return }

        let wrapperView = AcuityReportListContainerView(
            onDismiss: dismissHandler(for: viewController, animated: animated, completion: completion)
        )
        pushOrPresent(wrapperView, from: viewController, animated: animated, completion: completion)
    }

    /// Present AcuityIQ Report Upload from a UIViewController.
    /// Fetches the matching scenario via API using the projectID, then presents the upload view.
    /// - If embedded in a UINavigationController, pushes the view.
    /// - Otherwise, presents modally in full screen.
    /// - Parameters:
    ///   - viewController: The view controller to present from
    ///   - projectID: The project ID (corresponds to scenarioId) - required
    ///   - moduleId: Optional module ID (default: nil)
    ///   - moduleStatus: Optional module status (default: nil)
    ///   - courseId: Optional course ID (default: nil)
    ///   - attempt: Optional tuple containing total and remaining attempts
    ///   - moduleAttempts: Optional array of module attempt metadata dictionaries (default: nil)
    ///   - animated: Whether to animate the presentation (default: true)
    ///   - completion: Optional completion handler called when presentation is complete
    func presentReportUpload(
        from viewController: UIViewController,
        projectID: Int,
        moduleId: Int? = nil,
        moduleStatus: String? = nil,
        courseId: Int? = nil,
        attempt: (total: Int?, left: Int?)?,
        moduleAttempts: [[String: Any]]? = nil,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        guard checkConfigured() else { return }

        Task { @MainActor in
            do {
                // Fetch and match scenario by projectID
                guard let matchedScenario = try await fetchScenario(for: projectID) else { return }

                // Build navigation model with matched scenario
                let navModel = NavigationViewModel.AcuityReportUploadNavModel(
                    scenarioModel: matchedScenario,
                    isFromModule: true,
                    projectID: projectID,
                    moduleId: moduleId,
                    moduleStatus: moduleStatus,
                    courseId: courseId,
                    attempt: attempt,
                    moduleAttempts: moduleAttempts
                )

                let wrapperView = AcuityReportUploadContainerView(
                    navModel: navModel,
                    onDismiss: self.dismissHandler(for: viewController, animated: animated, completion: completion)
                )
                self.pushOrPresent(wrapperView, from: viewController, animated: animated, completion: completion)
            } catch {
                Logger.shared.log(.error, message: "Error fetching scenarios: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - UIKit Presentation (Role Play Dashboard)

extension AcuityIQ {

    /// Present Role Play Dashboard from a UIViewController.
    /// Fetches the matching scenario via API using the projectID, then presents the dashboard.
    /// - If embedded in a UINavigationController, pushes the view.
    /// - Otherwise, presents modally in full screen.
    /// - Parameters:
    ///   - viewController: The view controller to present from
    ///   - projectID: The project ID (corresponds to scenarioId) - required
    ///   - moduleId: Optional module ID (default: nil)
    ///   - moduleStatus: Optional module status (default: nil)
    ///   - courseId: Optional course ID (default: nil)
    ///   - attempt: Optional tuple containing total and remaining attempts
    ///   - moduleAttempts: Optional array of module attempt metadata dictionaries (default: nil)
    ///   - evaluationParameters: Optional array of evaluation parameter dictionaries (default: nil)
    ///   - keywords: Optional array of keyword strings (default: nil)
    ///   - animated: Whether to animate the presentation (default: true)
    ///   - completion: Optional completion handler called when presentation is complete
    func presentRolePlayDashboard(
        from viewController: UIViewController,
        rolePlayTitle: String,
        projectID: Int,
        moduleId: Int? = nil,
        moduleStatus: String? = nil,
        courseId: Int? = nil,
        attempt: (total: Int?, left: Int?)?,
        moduleAttempts: [[String: Any]]? = nil,
        evaluationParameters: [[String: Any]]? = nil,
        keywords: [String]? = nil,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        guard checkConfigured() else { return }

        Task { @MainActor in
            do {
                // Build navigation model with matched scenario
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

                let wrapperView = RolePlayDashboardContainerView(
                    navModel: navModel,
                    onDismiss: self.dismissHandler(for: viewController, animated: animated, completion: completion)
                )
                self.pushOrPresent(wrapperView, from: viewController, animated: animated, completion: completion)
            } catch {
                Logger.shared.log(.error, message: "Error fetching scenarios: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - Private Helpers

private extension AcuityIQ {

    /// Validates SDK configuration. Triggers an assertion failure in debug if unconfigured.
    /// - Returns: `true` if configured, `false` otherwise
    @discardableResult
    func checkConfigured() -> Bool {
        guard isConfigured else {
            assertionFailure("AcuityIQ not configured. Call AcuityIQ.shared.configure(with:) first.")
            return false
        }
        return true
    }

    /// Builds a dismiss handler that pops or dismisses the given view controller.
    /// - Parameters:
    ///   - viewController: The view controller to dismiss
    ///   - animated: Whether to animate the dismissal
    ///   - completion: Optional completion handler
    /// - Returns: A closure that performs the appropriate dismissal
    func dismissHandler(
        for viewController: UIViewController,
        animated: Bool,
        completion: (() -> Void)?
    ) -> () -> Void {
        { [weak viewController] in
            if let nav = viewController?.navigationController {
                nav.popViewController(animated: animated)
            } else {
                viewController?.dismiss(animated: animated, completion: completion)
            }
        }
    }

    /// Fetches all user scenarios from the API and returns the one matching the given projectID.
    /// - Parameter projectID: The scenario ID to match against
    /// - Returns: The matched `Scenario`, or `nil` if not found
    func fetchScenario(for projectID: Int) async throws -> AcuityIQReportDataModel.Scenario? {
        let requestModel = AcuityIQReportDataModel.GetUserScenarioRequestModel()
        let scenarios = try await ApiService.shared.requestGetHeader(
            type: [AcuityIQReportDataModel.Scenario].self,
            model: requestModel
        )
        guard let matched = scenarios.first(where: { $0.scenarioId == projectID }) else {
            Logger.shared.log(.error, message: "No scenario found for projectID: \(projectID)")
            return nil
        }
        return matched
    }

    /// Wraps a SwiftUI view in an `AcuityHostingController` and either pushes or presents it.
    /// - Parameters:
    ///   - view: The SwiftUI view to host
    ///   - viewController: The view controller to push/present from
    ///   - animated: Whether to animate the transition
    ///   - completion: Optional completion handler called after the transition
    func pushOrPresent<Content: View>(
        _ view: Content,
        from viewController: UIViewController,
        animated: Bool,
        completion: (() -> Void)?
    ) {
        let hasNavigationController = viewController.navigationController != nil

        let hostingController = AcuityHostingController(rootView: view)
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
}

// MARK: - AcuityHostingController

/// Custom hosting controller that hides the UIKit navigation bar
/// to prevent a double navigation bar when embedded in a UINavigationController.
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

    /// Imperatively navigate to AcuityIQ Report List.
    /// Use this when you have access to a router in your SwiftUI view.
    func navigateToAcuityReportList(
        router: AnyRouter,
        onDismiss: (() -> Void)? = nil
    ) {
        AcuityIQ.shared.showReportList(router: router, onDismiss: onDismiss)
    }

    /// Imperatively navigate to AcuityIQ Report Upload.
    /// Use this when you have access to a router in your SwiftUI view.
    func navigateToAcuityReportUpload(
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

    /// Imperatively navigate to Manager Evaluation List.
    /// Use this when you have access to a router in your SwiftUI view.
    func navigateToManagerEvaluationList(
        router: AnyRouter,
        userID: Int? = nil,
        onDismiss: (() -> Void)? = nil
    ) {
        AcuityIQ.shared.showManagerEvaluationList(router: router, userID: userID, onDismiss: onDismiss)
    }

    /// Imperatively navigate to Role Play Dashboard.
    /// Use this when you have access to a router in your SwiftUI view.
    func navigateToRolePlayDashboard(
        router: AnyRouter,
        rolePlayTitle: String,
        projectID: Int,
        moduleId: Int? = nil,
        moduleStatus: String? = nil,
        courseId: Int? = nil,
        attempt: (total: Int?, left: Int?)? = nil,
        moduleAttempts: [[String: Any]]? = nil,
        evaluationParameters: [[String: Any]]? = nil,
        keywords: [String]? = nil,
        onDismiss: (() -> Void)? = nil
    ) {
        AcuityIQ.shared.showRolePlayDashboard(
            router: router,
            rolePlayTitle: rolePlayTitle,
            projectID: projectID,
            moduleId: moduleId,
            moduleStatus: moduleStatus,
            courseId: courseId,
            attempt: attempt,
            moduleAttempts: moduleAttempts,
            evaluationParameters: evaluationParameters,
            keywords: keywords,
            onDismiss: onDismiss
        )
    }
}

// MARK: - Container Views (for UIKit Presentation)
private struct ManagerEvaluationListContainerView: View {
    let userID: Int?
    let hideToolbar: Bool
    let onDismiss: () -> Void

    var body: some View {
        RouterView { router in
            ManagerEvaluationListView(router: router, userID: userID)
                .navigationTitle("Manager Evaluation")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
                .navigationBarHidden(hideToolbar)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        if !hideToolbar {
                            BackButton(action: onDismiss)
                        }
                    }
                }
        }
    }
}

// MARK: - Original Container Views (for UIKit Presentation)

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
            AcuityReportUploadView(router: router, navModel: navModel)
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

private struct RolePlayDashboardContainerView: View {
    let navModel: NavigationViewModel.RolePlayDashboardNavModel
    let onDismiss: () -> Void

    var body: some View {
        RouterView { router in
            RolePlayDashboardView(router: router, navModel: navModel)
                .navigationTitle("Role Play")
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
