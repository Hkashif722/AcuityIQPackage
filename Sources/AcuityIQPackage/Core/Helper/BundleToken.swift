//
//  Foundation.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 27/04/26.
//


import Foundation
import class Foundation.Bundle

private class BundleToken {}

extension Foundation.Bundle {
    static let acuityBundle: Bundle = {
        #if SWIFT_PACKAGE
        return Bundle.module
        #else
        return Bundle(for: BundleToken.self)
        #endif
    }()
}
