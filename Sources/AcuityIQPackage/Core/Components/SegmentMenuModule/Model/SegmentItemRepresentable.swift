//
//  SegmentItemRepresentable.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 31/03/26.
//

import SwiftUI

public enum SegmentIconType {
    case system(name: String)                        // SF Symbol
    case bundle(name: String, bundle: Bundle? = nil) // Asset catalog image
}


protocol SegmentItemRepresentable: Identifiable, CaseIterable, Hashable where ID == String {
    var menuTitle: String { get }
    var icon: SegmentIconType { get }
    var selectedColor: Color { get }
    var unSelectedColor: Color { get }
}
