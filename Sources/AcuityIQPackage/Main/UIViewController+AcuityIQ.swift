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
    func presentAcuityReportUpload(projectID: Int, moduleId: Int?, courseId: Int?, animated: Bool, completion: (() -> Void)?)
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
    public func presentAcuityReportUpload(projectID: Int, moduleId: Int? = nil, courseId: Int? = nil, animated: Bool = true, completion: (() -> Void)? = nil) {
        AcuityIQ.shared.presentReportUpload(
            from: self,
            projectID: projectID,
            moduleId: moduleId,
            courseId: courseId,
            animated: animated,
            completion: completion
        )
    }
}
