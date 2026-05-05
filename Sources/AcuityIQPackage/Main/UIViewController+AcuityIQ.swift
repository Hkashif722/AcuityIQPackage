//
//  UIViewController+AcuityIQ.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 05/04/26.
//

import UIKit
import SwiftUIUtilities

// MARK: - AcuityIQPresentable Protocol

/// Protocol that provides AcuityIQ presentation capabilities.
/// UIViewController conforms to this protocol via extension.
@MainActor
public protocol AcuityIQPresentable: AnyObject {

    /// Present AcuityIQ Report List View
    /// - Parameters:
    ///   - animated: Whether to animate the presentation
    ///   - completion: Optional completion handler
    func presentAcuityReportList(animated: Bool, completion: (() -> Void)?)

    /// Present AcuityIQ Report Upload View (from module)
    /// - Parameters:
    ///   - projectID: The project ID (corresponds to scenarioId) - required
    ///   - moduleId: Optional module ID
    ///   - courseId: Optional course ID
    ///   - animated: Whether to animate the presentation
    ///   - completion: Optional completion handler
    func presentAcuityReportUpload(projectID: Int, moduleId: Int?, moduleStatus: String?, courseId: Int?, attempt: (total: Int?, left: Int?)?, moduleAttempts: [[String: Any]]?, animated: Bool, completion: (() -> Void)?)
    
    /// Present Role Play Dashboard View (from module)
    /// - Parameters:
    ///   - projectID: The project ID (corresponds to scenarioId) - required
    ///   - moduleId: Optional module ID
    ///   - moduleStatus: Optional module status
    ///   - courseId: Optional course ID
    ///   - attempt: Optional tuple containing total and remaining attempts
    ///   - moduleAttempts: Optional array of module attempt metadata dictionaries
    ///   - evaluationParameters: Optional array of evaluation parameter dictionaries (name, description, percentage, selected)
    ///   - keywords: Optional array of keyword strings
    ///   - animated: Whether to animate the presentation
    ///   - completion: Optional completion handler
    func presentRolePlayDashboard(rolePlayTitle: String,projectID: Int, moduleId: Int?, moduleStatus: String?, courseId: Int?, attempt: (total: Int?, left: Int?)?, moduleAttempts: [[String: Any]]?, evaluationParameters: [[String: Any]]?, keywords: [String]?, animated: Bool, completion: (() -> Void)?)

    /// Present Manager Evaluation List View
    /// - Parameters:
    ///   - userID: Optional user ID to filter scenario attempts
    ///   - animated: Whether to animate the presentation
    ///   - completion: Optional completion handler
    func presentManagerEvaluationList(userID: Int?, animated: Bool, completion: (() -> Void)?)
}

// MARK: - UIViewController + AcuityIQPresentable

@MainActor
extension UIViewController: AcuityIQPresentable {

    /// Present AcuityIQ Report List View
    /// - If embedded in UINavigationController, pushes the view
    /// - Otherwise, presents modally in full screen
    /// - Parameters:
    ///   - animated: Whether to animate the presentation (default: true)
    ///   - completion: Optional completion handler called after presentation
    public func presentAcuityReportList(animated: Bool = true, completion: (() -> Void)? = nil) {
        AcuityIQ.shared.presentReportList(from: self, animated: animated, completion: completion)
    }

    /// Present AcuityIQ Report Upload View (from module)
    /// This method fetches the scenario from the API using the projectID and presents the upload view.
    /// - If embedded in UINavigationController, pushes the view
    /// - Otherwise, presents modally in full screen
    /// - Parameters:
    ///   - projectID: The project ID (corresponds to scenarioId) - required
    ///   - moduleId: Optional module ID (default: nil)
    ///   - courseId: Optional course ID (default: nil)
    ///   - animated: Whether to animate the presentation (default: true)
    ///   - completion: Optional completion handler called after presentation
    public func presentAcuityReportUpload(projectID: Int, moduleId: Int? = nil, moduleStatus: String? = nil, courseId: Int? = nil, attempt: (total: Int?, left: Int?)?, moduleAttempts: [[String: Any]]? = nil, animated: Bool = true, completion: (() -> Void)? = nil) {
        AcuityIQ.shared.presentReportUpload(
            from: self,
            projectID: projectID,
            moduleId: moduleId,
            moduleStatus: moduleStatus,
            courseId: courseId,
            attempt: attempt,
            moduleAttempts: moduleAttempts,
            animated: animated,
            completion: completion
        )
    }
    
    
    /// Present Role Play Dashboard View (from module)
        /// This method fetches the scenario from the API using the projectID and presents the role play dashboard.
        /// - If embedded in UINavigationController, pushes the view
        /// - Otherwise, presents modally in full screen
        /// - Parameters:
        ///   - projectID: The project ID (corresponds to scenarioId) - required
        ///   - moduleId: Optional module ID (default: nil)
        ///   - moduleStatus: Optional module status (default: nil)
        ///   - courseId: Optional course ID (default: nil)
        ///   - attempt: Optional tuple containing total and remaining attempts
        ///   - moduleAttempts: Optional array of module attempt metadata dictionaries (default: nil)
        ///   - evaluationParameters: Optional array of evaluation parameter dictionaries (default: nil)
        ///   - keywords: Optional array of keyword strings (default: nil)
        ///   - animated: Whether to animate the presentation (default: true)
        ///   - completion: Optional completion handler called after presentation
    public func presentRolePlayDashboard(rolePlayTitle: String,projectID: Int, moduleId: Int? = nil, moduleStatus: String? = nil, courseId: Int? = nil, attempt: (total: Int?, left: Int?)?, moduleAttempts: [[String: Any]]? = nil, evaluationParameters: [[String: Any]]? = nil, keywords: [String]? = nil, animated: Bool = true, completion: (() -> Void)? = nil) {
            AcuityIQ.shared.presentRolePlayDashboard(
                from: self,
                rolePlayTitle: rolePlayTitle,
                projectID: projectID,
                moduleId: moduleId,
                moduleStatus: moduleStatus,
                courseId: courseId,
                attempt: attempt,
                moduleAttempts: moduleAttempts,
                evaluationParameters: evaluationParameters,
                keywords: keywords,
                animated: animated,
                completion: completion
            )
        }

    /// Present Manager Evaluation List View
    /// - If embedded in UINavigationController, pushes the view
    /// - Otherwise, presents modally in full screen
    /// - Parameters:
    ///   - animated: Whether to animate the presentation (default: true)
    ///   - completion: Optional completion handler called after presentation
    public func presentManagerEvaluationList(userID: Int? = nil, animated: Bool = true, completion: (() -> Void)? = nil) {
        AcuityIQ.shared.presentManagerEvaluationList(from: self, userID: userID, animated: animated, completion: completion)
    }
}
