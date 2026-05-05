//
//  AcuityIQAPIManager.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 05/04/26.
//

import Foundation
import NetworkService
import SwiftUIUtilities
import RolePlayKit

public actor AcuityIQAPIManager {

    public static let shared = AcuityIQAPIManager()

    nonisolated(unsafe) internal var config: AcuityIQPackageConfig?

    nonisolated internal var getOrgCode: String {
        config?.orgCode ?? ""
    }

    nonisolated internal var isBlobEnabled: Bool {
        config?.isBlobEnabled ?? true
    }

    nonisolated internal var getConfiguaredDate: String {
        config?.dateConfiguration ?? ""
    }
    
    nonisolated internal var ENV: AcuityIQENV? {
        config?.acuityIQEnvironmentConfig
    }

    nonisolated public var getAuthToken: @Sendable () -> String {
        guard let provider = config?.tokenProvider else { return { "" } }
        return { provider() ?? "" }
    }
    
    nonisolated public var isUAT: Bool {
        APIConst.baseURL.contains("uat") ?? false
    }
    

    private init() {}

    // Call this once from the host app
    public func configure(_ config: AcuityIQPackageConfig) {
        self.config = config

        // Configure ApiService with token provider
        ApiService.shared.setAuthToken(config.tokenProvider)
        APIConfiguration.shared.baseURL = APIConst.baseURL
        self.configureSwiftUIUtilityEnvironment(config)
        self.configureRolePlayEnvironment(config: config)
    }

    // Shared accessor
    public var baseURL: String {
        APIConst.baseURL
    }

    private func configureSwiftUIUtilityEnvironment(_ config: AcuityIQPackageConfig) {
        
        let baseURL = isUAT ? APIConst.baseURL : APIConst.ContentPath
        let modelConfiguration = SwiftUtilityConfig(
            encryptionDecryptionKey: config.acuityIQEnvironmentConfig.encryptionDecryptionKey,
            isBlobEnabled: config.isBlobEnabled,
            orgCode: config.orgCode,
            configurableDate: config.dateConfiguration,
            baseURL: baseURL,
            lxpOPath: APIConst.lxpOPath,
            lxpBlobPath: APIConst.lxpBlobPath,
            lxpBlobPath1: APIConst.lxpBlobPath1
        )
        SwiftUtilityEnvironment.configure(modelConfiguration)
    }
    
    
    //MARK: Configure Role Play environment
    
    private func configureRolePlayEnvironment(config: AcuityIQPackageConfig) {
        RolePlayKitModuleConfiguration.shared.configureRolePlayEnvironment(config: config)
    }
}
