//
//  UIViewController+AcuityIQ.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 05/04/26.
//

import UIKit

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

    /// Present AcuityIQ Report Upload View
    /// - Parameters:
    ///   - scenarioId: The scenario ID for upload
    ///   - animated: Whether to animate the presentation
    ///   - completion: Optional completion handler
    func presentAcuityReportUpload(scenarioId: Int, animated: Bool, completion: (() -> Void)?)
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

    /// Present AcuityIQ Report Upload View
    /// - If embedded in UINavigationController, pushes the view
    /// - Otherwise, presents modally in full screen
    /// - Parameters:
    ///   - scenarioId: The scenario ID for upload
    ///   - animated: Whether to animate the presentation (default: true)
    ///   - completion: Optional completion handler called after presentation
    public func presentAcuityReportUpload(scenarioId: Int, animated: Bool = true, completion: (() -> Void)? = nil) {
        AcuityIQ.shared.presentReportUpload(from: self, scenarioId: scenarioId, animated: animated, completion: completion)
    }
}
