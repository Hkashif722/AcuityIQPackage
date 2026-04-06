//
//  File.swift
//  OJT_Package
//
//  Created by Kashif Hussain on 13/01/26.
//

import SwiftUI
import SwiftfulRouting
import SwiftUIUtilities

// MARK: - Navigation Destination
@MainActor
enum AppNavigationDestination {
    // Package destinations
    case packageDestination(NavigationDestination)

    // App-specific destinations
    case attemptList(navModel: NavigationViewModel.AcuityAttemptNavModel)
    case detailReportView(navModel: NavigationViewModel.DetailReoportNavModel)

}

// MARK: - Navigation Protocol Conformance
extension AppNavigationDestination: NavigationProtocol {
    
    public func navigate(using router: AnyRouter) {
        
        switch self {
            
        case .packageDestination(let destination):
            destination.navigate(using: router)
            
        case .attemptList(let navModel):
            router.showScreen(.push) { router in
                AcuityAttemptListView(router: router, navModel: navModel)
            }
            
        case .detailReportView(let navModel):
            router.showScreen(.push) { router in
                DetailReportView(router: router, navModel: navModel)
            }
            
        }
    
    }
    
    
}

