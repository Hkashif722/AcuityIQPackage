//
//  AcuityIQPackageConfig.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 05/04/26.
//

import Foundation

public struct AcuityIQPackageConfig: Sendable {

    public let orgCode: String
    public let isBlobEnabled: Bool
    public let dateConfiguration: String
    public let acuityIQEnvironmentConfig: AcuityIQENV
    public let rolePlayModelConfiguration: RolePlayModelConfiguration
    public let tokenProvider: @Sendable () -> String?

    public init(
        baseURL: String,
        lxpOPath: String,
        lxpBlobPath: String,
        lxpBlobPath1: String,
        isBlobEnabled: Bool,
        orgCode: String,
        dateConfiguration: String,
        acuityIQENV: AcuityIQENV,
        rolePlayModelConfiguration: RolePlayModelConfiguration,
        tokenProvider: @escaping @Sendable () -> String?
    ) {
        APIConst.baseURL = baseURL
        APIConst.lxpOPath = lxpOPath
        APIConst.lxpBlobPath = lxpBlobPath
        APIConst.lxpBlobPath1 = lxpBlobPath1
        self.isBlobEnabled = isBlobEnabled
        self.orgCode = orgCode
        self.dateConfiguration = dateConfiguration
        self.acuityIQEnvironmentConfig = acuityIQENV
        self.rolePlayModelConfiguration = rolePlayModelConfiguration
        self.tokenProvider = tokenProvider
    }
}

// MARK: - Environment Configuration

public struct AcuityIQENV: Sendable {
    public let sasToken: String
    public let aiLMSToken: String
    public let encryptionDecryptionKey: String
    public let OrgID: String
    
    public init(sasToken: String, aiLMSToken: String, encryptionDecryptionKey: String, OrgID: String) {
        self.sasToken = sasToken
        self.aiLMSToken = aiLMSToken
        self.encryptionDecryptionKey = encryptionDecryptionKey
        self.OrgID = OrgID
    }
    
}


// Model for Role Play
public struct RolePlayModelConfiguration : Sendable{
    public let isShowWelcome: Bool
    public let welcomePdfURL: URL?
    public let userName: String
    public let buildPath: String

    // Orientation callbacks
    public let onRequestPortrait: (@Sendable () -> Void)?
    public let onRequestLandscape: (@Sendable () -> Void)?
    public let onResetOrientation: (@Sendable () -> Void)?
    
    
    public init(
        isShowWelcome: Bool,
        welcomePdfURL: URL?,
        userName: String,
        buildPath: String,
        onRequestPortrait: (@Sendable() -> Void)?,
        onRequestLandscape: (@Sendable() -> Void)?,
        onResetOrientation: (@Sendable() -> Void)?
    ) {
        self.isShowWelcome = isShowWelcome
        self.welcomePdfURL = welcomePdfURL
        self.userName = userName
        self.buildPath = buildPath
        self.onRequestPortrait = onRequestPortrait
        self.onRequestLandscape = onRequestLandscape
        self.onResetOrientation = onResetOrientation
    }
}
