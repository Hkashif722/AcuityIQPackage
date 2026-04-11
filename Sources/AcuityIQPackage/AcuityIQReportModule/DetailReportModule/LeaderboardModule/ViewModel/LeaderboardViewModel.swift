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

@MainActor
class LeaderboardViewModel: RoutableViewModel {

    let leaderboardResponseModel: [LeaderboardDataModel.LeaderboardAttempt]

    //MARK: Computed Properties

    var getHeaderGreadient: [Gradient.Stop] {
        LeaderboardDataModel.LeaderboardAttempt.leaderBoardHeaderGradientStop
    }

    // MARK: - Init
    init(router: AnyRouter, leaderboardResponse: [LeaderboardDataModel.LeaderboardAttempt]) {
        self.leaderboardResponseModel = leaderboardResponse
        super.init(router: router)
    }
}

//MARK: Handle Action
extension LeaderboardViewModel {
    func onAttemptBadgeSelection(_ attempt: LeaderboardDataModel.LeaderboardAttempt) {
        NavigationService.shared.navigate(
            using: router,
            to: AppNavigationDestination.attemptBadgeView(
                attemptNumber: attempt.attemptNumber ?? 0,
                totalAttempts: attempt.totalAttempts ?? 0,
                attemptsUsed: attempt.attemptsUsed ?? 0
            )
        )
    }

    func onHerculeanEffortSelection(_ attempt: LeaderboardDataModel.LeaderboardAttempt) {
        NavigationService.shared.navigate(
            using: router,
            to: AppNavigationDestination.herculeanEffortView(strengths: attempt.strengths ?? [])
        )
    }

    func onWatchRecordingPressed(_ attempt: LeaderboardDataModel.LeaderboardAttempt) {
        let navModel = NavigationViewModel.ResourceViewModel(filePath: attempt.fullVideoPath, isOnlineType: true)
        NavigationService.shared.navigate(using: router, to: .resourceView(navModel))
    }
}
