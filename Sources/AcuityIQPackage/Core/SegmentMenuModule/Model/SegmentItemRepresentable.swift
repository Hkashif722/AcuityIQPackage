//
//  SegmentItemRepresentable.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 31/03/26.
//

import SwiftUI

protocol SegmentItemRepresentable: Identifiable {
    var menuTitle: String { get }
    var selectedColor: Color { get }
    var unSelectedColor: Color { get }
}
