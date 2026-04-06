//
//  GaugeSegmentProtocol.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 31/03/26.
//

import SwiftUI

protocol GaugeSegmentProtocol {
    var color: Color { get }
    var title: String { get }
    var location: Double { get } // 0...1
}

struct GaugeSegment: GaugeSegmentProtocol {
    let color: Color
    let title: String
    let location: Double
}
