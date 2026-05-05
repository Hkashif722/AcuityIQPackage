//
//  View+Ext.swift
//  AcuityIQPackage
//

import SwiftUI

extension View {

    /// Hides the system background of a TextEditor (or any scroll view) on iOS 16+.
    /// On older OS versions the call is a no-op, so the default background remains.
    @ViewBuilder
    func scrollContentBackgroundPkg(_ visibility: Visibility) -> some View {
        if #available(iOS 16.0, *) {
            self.scrollContentBackground(visibility)
        } else {
            self
        }
    }

    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
