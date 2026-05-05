//
//  File.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 27/04/26.
//

import Foundation
import RolePlayKit


final class RoleplayKitModuleManager: @unchecked Sendable {
    
    static let shared = RoleplayKitModuleManager()
    
    private(set) var rolePlayKit: RolePlayKit?
    
    private init() { }
    
    
    
    func initialize(rolePlayConfig: RolePlayKitPackageConfig) {
        Task { [weak self] in
            let kit = await RolePlayKit(config: rolePlayConfig)
            self?.rolePlayKit = kit
        }
    }
}
