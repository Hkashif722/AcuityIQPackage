//
//  LeaderboardViewModel.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 05/04/26.
//

import Foundation
import SwiftUIUtilities
import SwiftfulRouting
import SwiftUI

class LeaderboardViewModel: RoutableViewModel {

    
    let leaderboardResponseModel: [LeaderboardDataModel.LeaderboardAttempt] = LeaderboardDataModel.LeaderboardAttempt.previewArray
    
    //MARK: Computed Properties
    
    var getHeaderGreadient: [Gradient.Stop] {
        LeaderboardDataModel.LeaderboardAttempt.leaderBoardHeaderGradientStop
    }
    

    //MARK: Computed Properties
    init(router: AnyRouter) {
        super.init(router: router)
    }
    
}

//MARK: Handle Action
extension LeaderboardViewModel {
    func onAttemptBadgeSelection() {
        
    }
    
    func onHerculeanEffortSelection() {
        
    }
    
    func onWatchRecordingPressed(_ attempt: LeaderboardDataModel.LeaderboardAttempt) {
        
    }
}
