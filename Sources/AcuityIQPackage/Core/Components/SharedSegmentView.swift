//
//  DetailReportSegmentView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 31/03/26.
//

import SwiftUI

struct SharedSegmentView<T: SegmentItemRepresentable>: View {
    
    let items: [T]
    let onSegmentSelect: (T) -> Void
    
    var body: some View {
        VStack {
            SegmentMenuView(items: items, onSelect: onSegmentSelect)
            Spacer()
        }
    }
}

// MARK: - Previews
#Preview("Analytics Tab") {
    SharedSegmentView<DetailReportDataModel.AnalyticsTab>(
        items: DetailReportDataModel.AnalyticsTab.allCases,
        onSegmentSelect: { _ in }
    )
}
