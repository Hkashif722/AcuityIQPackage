//
//  LeaderboardView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 05/04/26.
//

import SwiftUI
import SwiftUIUtilities

struct LeaderboardView: View {

    @StateObject private var vm: LeaderboardViewModel

    init(router: AnyRouter, leaderboardResponse: [LeaderboardDataModel.LeaderboardAttempt]) {
        _vm = StateObject(
            wrappedValue: LeaderboardViewModel(router: router, leaderboardResponse: leaderboardResponse)
        )
    }
    
    var body: some View {
        ScrollView {
            leaderboardListView
        }
        .versionedHorizontalContentMarginsPkg()
    }
    
    
    private var leaderboardListView: some View {
        LazyVStack(spacing: 16) {
            ForEach(Array(vm.leaderboardResponseModel.enumerated()), id: \.element.id) { index, leaderboard in
                LeaderboardRandCardView(
                    rank: index + 1,
                    leaderboardAttempt: leaderboard,
                    initiallyExpanded: index == 0,
                    onAttemptBadgeSelection: vm.onAttemptBadgeSelection,
                    onHerculeanEffortSelection: vm.onHerculeanEffortSelection,
                    onWatchRecordingPressed: vm.onWatchRecordingPressed
                )
            }
        }
    }
    
   
    
}

#if Debug
#Preview {
    RouterView { router in
        LeaderboardView(router: router, leaderboardResponse: LeaderboardDataModel.LeaderboardAttempt.previewArray)
    }
}
#endif


struct LeaderboardRandCardView: View {

    @State private var isExpanded: Bool

    let rank: Int
    let leaderboardAttempt: LeaderboardDataModel.LeaderboardAttempt
    let headerGradientStop: [Gradient.Stop] = LeaderboardDataModel.LeaderboardAttempt.leaderBoardHeaderGradientStop

    let onAttemptBadgeSelection: (LeaderboardDataModel.LeaderboardAttempt) -> Void
    let onHerculeanEffortSelection: (LeaderboardDataModel.LeaderboardAttempt) -> Void
    let onWatchRecordingPressed: (LeaderboardDataModel.LeaderboardAttempt) -> Void

    init(
        rank: Int,
        leaderboardAttempt: LeaderboardDataModel.LeaderboardAttempt,
        initiallyExpanded: Bool = false,
        onAttemptBadgeSelection: @escaping (LeaderboardDataModel.LeaderboardAttempt) -> Void,
        onHerculeanEffortSelection: @escaping (LeaderboardDataModel.LeaderboardAttempt) -> Void,
        onWatchRecordingPressed: @escaping (LeaderboardDataModel.LeaderboardAttempt) -> Void
    ) {
        self.rank = rank
        self.leaderboardAttempt = leaderboardAttempt
        self._isExpanded = State(initialValue: initiallyExpanded)
        self.onAttemptBadgeSelection = onAttemptBadgeSelection
        self.onHerculeanEffortSelection = onHerculeanEffortSelection
        self.onWatchRecordingPressed = onWatchRecordingPressed
    }
    
    //MARK: Computed Properties
    var getForeGroundColor: Color {
        Color.dynamicTextColor(for: headerGradientStop)
    }
    
    var body: some View {
        
        VStack(spacing: 8) {
            LeaderboardProfileHeaderView(
                isExpanded: isExpanded,
                userName: leaderboardAttempt.userName ?? "Unknown",
                overallScore: leaderboardAttempt.overallScore ?? 0.0,
                rank: rank,
                profilePicturePath: leaderboardAttempt.profilePicture,
                headerGradientStop: headerGradientStop,
                onHeaderPressed: {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8, blendDuration: 0.1)) {
                        isExpanded.toggle()
                    }
                },
                onAttemptBadgeSelection: { onAttemptBadgeSelection(leaderboardAttempt) },
                onHerculeanEffortSelection: { onHerculeanEffortSelection(leaderboardAttempt) }
            )
            
            if isExpanded {
                LeaderboardStarQuatilyFeedbackView(
                    isExpanded: isExpanded,
                    userName: leaderboardAttempt.userName ?? "Unknown",
                    overallScore: leaderboardAttempt.overallScore ?? 0.0,
                    profilePicturePath: leaderboardAttempt.profilePicture,
                    feedbackEntries: leaderboardAttempt.strengths ?? [],
                    onAttemptBadgeSelection: { onAttemptBadgeSelection(leaderboardAttempt) },
                    onHerculeanEffortSelection: { onHerculeanEffortSelection(leaderboardAttempt) }
                )
                .padding(.horizontal)
                .transition(
                    .asymmetric(
                        insertion: .opacity
                            .combined(with: .scale(scale: 0.95, anchor: .top))
                            .combined(with: .move(edge: .top)),
                        removal: .opacity
                            .combined(with: .scale(scale: 0.95, anchor: .top))
                    )
                )
                
                watchRecordingButton
                    .padding(.horizontal)
                    .padding(.bottom)
            }
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6).opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(.gray.opacity(0.3), lineWidth: 1)
        }
        
    }
    
    private var watchRecordingButton: some View {
        LeaderboardWatchRecordingButton(
            gradientStops: headerGradientStop,
            onPressed: {
                onWatchRecordingPressed(leaderboardAttempt)
            }
        )
    }
}
