//
//  File.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 31/03/26.
//

import Foundation
import SwiftUIUtilities
import SwiftfulRouting

class DetailResportViewModel: RoutableViewModel {

    
    let segmentItems: [DetailReportDataModel.AnalyticsTab] = DetailReportDataModel.AnalyticsTab.allCases
    
    @Published private(set) var selectedSegment: DetailReportDataModel.AnalyticsTab = .overview
    
    init(router: AnyRouter) {
        super.init(router: router)
    }
}

//MARK: Handle Action
extension DetailResportViewModel {
    
    func onSegmentSelect(_ segment: DetailReportDataModel.AnalyticsTab) {
        self.selectedSegment = segment
    }
}
