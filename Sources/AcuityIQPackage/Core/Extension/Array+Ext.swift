//
//  File.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 31/03/26.
//

import Foundation

internal extension Array where Element == GaugeSegment {
    static func defaultSegments() -> [GaugeSegment] {
        DetailReportDataModel.ScenarioAttemptResponse.ScoreLevel.allCases.map {
            GaugeSegment(
                color: $0.color,
                title: $0.rawValue,
                location: $0.location
            )
        }
    }
}

internal extension Array {
    var nilIfEmpty: [Element]? {
        isEmpty ? nil : self
    }
}
