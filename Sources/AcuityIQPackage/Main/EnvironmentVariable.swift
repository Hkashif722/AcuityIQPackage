//
//  EnvironmentVariable.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 06/04/26.
//

import Foundation

struct EnvironmentVariable {
    static let acuityManager = AcuityIQAPIManager.shared
    static let SAS_TOKEN = acuityManager.ENV?.sasToken ?? ""
    static let ACCESS_TOKEN_AI = acuityManager.ENV?.aiLMSToken ?? ""
    static let ORG_ID = acuityManager.ENV?.OrgID ?? ""
}
