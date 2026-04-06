//
//  File.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 02/04/26.
//

import Foundation

extension String {
    func toSeconds() -> Double {
        let components = self
            .split(separator: ":")
            .compactMap { Double($0) }

        guard components.count == 2 else { return 0 }
        return components[0] * 60 + components[1]
    }
}
