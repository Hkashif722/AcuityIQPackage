//
//  File.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 27/04/26.
//

import Foundation
import RolePlayKit



final class RolePlayKitModuleConfiguration: @unchecked Sendable {
    
    static let shared = RolePlayKitModuleConfiguration()
    
    
    private init() { }
    
    func configureRolePlayEnvironment(config: AcuityIQPackageConfig) {
        
        let rolePlayConfig = RolePlayKitPackageConfig(
            baseURL: APIConst.baseURL,
            lxpOPath: APIConst.lxpOPath,
            lxpBlobPath: APIConst.lxpBlobPath,
            lxpBlobPath1: APIConst.lxpBlobPath1,
            isBlobEnabled: config.isBlobEnabled,
            orgCode: config.orgCode,
            dateConfiguration: config.dateConfiguration,
            rolePlayKitENV: .init(
                uatBlobToken: config.acuityIQEnvironmentConfig.sasToken,
                aiLMSToken: config.acuityIQEnvironmentConfig.aiLMSToken,
                encryptionDecryptionKey: config.acuityIQEnvironmentConfig.encryptionDecryptionKey
            ),
            tokenProvider: { config.tokenProvider() ?? "" },
            isShowWelcome: config.rolePlayModelConfiguration.isShowWelcome,
            welcomePdfURL: config.rolePlayModelConfiguration.welcomePdfURL,
            userName: config.rolePlayModelConfiguration.userName,
            buildPath: config.rolePlayModelConfiguration.buildPath,
            isUAT: AcuityIQAPIManager.shared.isUAT,
            onRequestPortrait: config.rolePlayModelConfiguration.onRequestPortrait,
            onRequestLandscape: config.rolePlayModelConfiguration.onRequestLandscape,
            onResetOrientation: config.rolePlayModelConfiguration.onResetOrientation
        )
        
        RoleplayKitModuleManager.shared.initialize(rolePlayConfig: rolePlayConfig)
    }
}
