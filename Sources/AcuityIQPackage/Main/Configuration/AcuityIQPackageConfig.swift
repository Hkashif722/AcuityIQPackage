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
    public let sas_token: String
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
        sas_token: String,
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
        self.sas_token = sas_token
        self.tokenProvider = tokenProvider
    }
}

// MARK: - Environment Configuration

public struct AcuityIQENV: Sendable {
    public let encryptionDecryptionKey: String

    public init(encryptionDecryptionKey: String) {
        self.encryptionDecryptionKey = encryptionDecryptionKey
    }
}
