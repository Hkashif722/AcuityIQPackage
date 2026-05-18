//
//  AcuityIQAPIManager.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 05/04/26.
//

import Foundation
import NetworkService
import SwiftUIUtilities

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

    nonisolated internal var sasToken: String {
        config?.sas_token ?? ""
    }
    
    nonisolated internal var ENV: AcuityIQENV? {
        config?.acuityIQEnvironmentConfig
    }

    nonisolated public var getAuthToken: @Sendable () -> String {
        guard let provider = config?.tokenProvider else { return { "" } }
        return { provider() ?? "" }
    }

    private init() {}

    // Call this once from the host app
    public func configure(_ config: AcuityIQPackageConfig) {
        self.config = config

        // Configure ApiService with token provider
        ApiService.shared.setAuthToken(config.tokenProvider)
        APIConfiguration.shared.baseURL = APIConst.baseURL
        self.configureSwiftUIUtilityEnvironment(config)
    }

    // Shared accessor
    public var baseURL: String {
        APIConst.baseURL
    }

    private func configureSwiftUIUtilityEnvironment(_ config: AcuityIQPackageConfig) {
        let modelConfiguration = SwiftUtilityConfig(
            encryptionDecryptionKey: config.acuityIQEnvironmentConfig.encryptionDecryptionKey,
            isBlobEnabled: config.isBlobEnabled,
            orgCode: config.orgCode,
            configurableDate: config.dateConfiguration,
            baseURL: APIConst.baseURL,
            lxpOPath: APIConst.lxpOPath,
            lxpBlobPath: APIConst.lxpBlobPath,
            lxpBlobPath1: APIConst.lxpBlobPath1
        )
        SwiftUtilityEnvironment.configure(modelConfiguration)
    }
}
