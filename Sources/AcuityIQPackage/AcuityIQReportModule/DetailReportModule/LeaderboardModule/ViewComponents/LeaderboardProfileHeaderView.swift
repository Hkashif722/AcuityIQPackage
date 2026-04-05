//
//  LeaderboardProfileHeaderView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 05/04/26.
//

import SwiftUI
import SwiftUIUtilities

struct LeaderboardProfileHeaderView: View {
    
    let isExpanded: Bool
    
    let userName: String
    let overallScore: Double
    let rank: Int
    let profilePicturePath: String?
    let headerGradientStop: [Gradient.Stop]
    let onHeaderPressed: () -> Void
    let onAttemptBadgeSelection: () -> Void
    let onHerculeanEffortSelection: () -> Void
    
    var getForeGroundColor: Color {
        Color.dynamicTextColor(for: headerGradientStop)
    }
    
    var body: some View {
        VStack {
            if isExpanded {
                expandedCardHeaderView
                    .transition(.asymmetric(
                        insertion: .opacity.combined(with: .scale(scale: 0.95)),
                        removal: .opacity
                    ))
            } else {
                collapedCardHeaderView
                    .transition(.asymmetric(
                        insertion: .opacity.combined(with: .scale(scale: 0.95)),
                        removal: .opacity
                    ))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .animation(.easeInOut(duration: 0.3), value: isExpanded)
    }
    
  

}

//MARK: Expanded Header View
extension LeaderboardProfileHeaderView {
    
    private var expandedCardHeaderView: some View {
        HStack {
            rankView
            Spacer()
            scoreTagView
        }
        .padding()
        .reusableGradientBackgroundPkg(
            stops: headerGradientStop,
            startPoint: .leading,
            endPoint: .trailing
        )
        .anyButton(.press, action: onHeaderPressed)
    }
    
   
    
    
    private var scoreTagView: some View {
        Text("Score: \(String(format: "%.1f", overallScore))")
            .font(.subheadline.bold())
            .foregroundStyle(getForeGroundColor)
            .padding(.init(top: 8, leading: 16, bottom: 8, trailing: 16))
            .clipShape(Capsule())
            .background(getForeGroundColor.opacity(0.2))
            .cornerRadiusPkg(16, corners: .allCorners)
    }
}


//MARK: Collasped Header View
extension LeaderboardProfileHeaderView {
    
    private var collapedCardHeaderView: some View {
        HStack(spacing: 16) {
            rankView
            LeaderboardProfileSectionView(
                userName: userName,
                overallScore: overallScore,
                profiePicture: profilePicturePath,
                onAttemptBadgeSelection: onAttemptBadgeSelection,
                onHerculeanEffortSelection: onHerculeanEffortSelection
            )
            
            disclosureIcon
        }
        .padding()
        .anyButton(.press, action: onHeaderPressed )
    }
    
    private var disclosureIcon: some View {
        Image(systemName: "chevron.right")
            .foregroundStyle(.gray)
    }
    
}


extension LeaderboardProfileHeaderView {
    
    private var rankView: some View {
        HStack {
            if isExpanded && rank == 1 {
                Image(systemName: "trophy.fill")
                    .foregroundStyle(Color(hex: "#E5A100"))
            }
            Text(isExpanded ? "Rank #\(rank)" : "#\(rank)")
                .font(.headline.bold())
                .foregroundStyle(isExpanded ? getForeGroundColor : .primary)
        }
    }
    
    
}

@available(iOS 17.0, *)
#Preview {
    @Previewable @State var isExpanded: Bool = false
    LeaderboardProfileHeaderView(
        isExpanded: isExpanded,
        userName: "LMS Admin",
        overallScore: 1.9,
        rank: 1,
        profilePicturePath: "https://uat.gogetempoered.com/enth/639092864775167395.png",
        headerGradientStop: LeaderboardDataModel.LeaderboardAttempt.leaderBoardHeaderGradientStop,
        onHeaderPressed: {
            isExpanded.toggle()
        },
        onAttemptBadgeSelection: {},
        onHerculeanEffortSelection: {}
    )
}
