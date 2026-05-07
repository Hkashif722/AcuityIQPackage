//
//  RolePlayKitService.swift
//  Ujjivan
//
//  Created by Kashif Hussain on 20/02/26.
//  Copyright © 2026 EnthrallTech. All rights reserved.
//


//
//  RolePlayKitService.swift
//

import Foundation
import SwiftfulRouting
import RolePlayKit

@MainActor
class RolePlayKitService {

    // MARK: - Singleton

    static let shared = RolePlayKitService()

    private init() {}
    
    // MARK: - Public Methods

    /// Starts the RolePlay flow by initializing the kit and navigating to the appropriate view.
    func startRolePlay(
        router: AnyRouter,
        projectID: Int,
        courseID: Int,
        moduleID: Int,
        moduleStatus: String? = nil,
        onDismiss: (() -> Void)? = nil,
        onSubmit: (() -> Void)? = nil
    ) {
        Task {
            if let kit = await RoleplayKitModuleManager.shared.rolePlayKit {
                kit.startRolePlay(
                    router: router,
                    projectID: projectID,
                    courseID: courseID,
                    moduleID: moduleID,
                    moduleStatus: moduleStatus,
                    onDismiss: onDismiss,
                    onSubmit: onSubmit
                )
            } else {
                assertionFailure("RolePlayKit is not initialized. Ensure RoleplayKitModuleManager is configured before calling startRolePlay.")
            }
        }
    }
}
