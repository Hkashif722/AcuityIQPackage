//
//  LeaderboardStarQuatilyFeedbackView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 05/04/26.
//

import SwiftUI

struct LeaderboardStarQuatilyFeedbackView: View {
    
    let isExpanded: Bool
    let userName: String
    let overallScore: Double
    let profilePicturePath: String?
    let feedbackEntries: [String]
    
    let onAttemptBadgeSelection: () -> Void
    let onHerculeanEffortSelection: () -> Void
    
    var body: some View {
        VStack {
            profileView
            headerView
            feedbackEntryListView
        }
    }
    
    @ViewBuilder
    private var profileView: some View {
        if isExpanded {
            LeaderboardProfileSectionView(
                userName: userName,
                overallScore: overallScore,
                profiePicture: profilePicturePath,
                onAttemptBadgeSelection: onAttemptBadgeSelection,
                onHerculeanEffortSelection: onHerculeanEffortSelection
            )
        }
    }
    
    private var headerView: some View {
        Text("STAR QUALITY FEEDBACK")
            .font(.subheadline.bold())
            .foregroundStyle(.gray)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    
    private var feedbackEntryListView: some View {
        VStack {
            ForEach(feedbackEntries, id: \.self) { feedback in
                feedbackEntryItemView(feedback: feedback)
            }
        }
    }
    
    private func feedbackEntryItemView(feedback: String) -> some View {
        HStack {
            bulletIcon
            feedbackInfoView(feedback: feedback)
        }
    }
    private var bulletIcon: some View {
        Circle()
            .fill(.brown.opacity(0.3))
            .frame(width: 22, height: 22)
            .overlay(
                Circle()
                    .fill(.brown)
                    .frame(width: 6, height: 6)
            )
    }
    
    private func feedbackInfoView( feedback: String) -> some View {
        Text(feedback)
            .font(.footnote)
            .foregroundStyle(Color(.darkGray))
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
}

#Preview {
    LeaderboardStarQuatilyFeedbackView(
        isExpanded: true,
        userName: "LMS Admin",
        overallScore: 1.9,
        profilePicturePath: nil,
        feedbackEntries: [
        "In the beginning, the user introduced themselves confidently, which sets a positive tone.",
        "Towards the middle, the user maintained a steady flow while discussing the products, indicating familiarity with the topic.",
        "In the end, the user attempted to provide additional product information, which shows an effort to engage."
        ],
        onAttemptBadgeSelection: {}, onHerculeanEffortSelection: {}
    )
    .padding(.horizontal)
}
