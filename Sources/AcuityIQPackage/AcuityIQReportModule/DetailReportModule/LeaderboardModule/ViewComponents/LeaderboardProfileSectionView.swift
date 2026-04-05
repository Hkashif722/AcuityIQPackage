//
//  LeaderboardProfileSectionView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 05/04/26.
//

import SwiftUI
import SwiftUIUtilities

struct LeaderboardProfileSectionView: View {
    
    let userName: String
    let overallScore: Double
    let profiePicture: String?
    let onAttemptBadgeSelection: () -> Void
    let onHerculeanEffortSelection: () -> Void
    
    var body: some View {
        HStack {
           
            profileView
            
            Spacer()
            
            badgeView
            
        }
    }
    
    private var profileView: some View {
        HStack {
            profileImageView
            userInfoView
        }
    }
    
    private var profileImageView: some View {
        AsyncImageWithFallback(urlString: profiePicture, defaultImageName: "default_avatar", bundle: .module)
            .aspectRatio(1, contentMode: .fit)
            .frame(width: 45)
            .clipShape(Circle())
            .overlay {
                Circle().stroke(.gray.opacity(0.5), lineWidth: 1)
            }
        
    }
    
    private var userInfoView: some View {
        VStack(alignment: .leading) {
            Text(userName)
                .font(.subheadline.bold())
                .foregroundStyle(.primary)
                .lineLimit(1)
            
            Text("Score: \(String(format: "%.1f", overallScore))")
                .font(.footnote.bold())
                .foregroundStyle(.secondary)
        }
    }
    
    private var badgeView: some View {
        HStack {
            
            Image(systemName: "flame")
                .foregroundStyle(Color(hex: "E24B4A"))
                .padding(10)
                .background(Color(hex: "FCEBEB"))
                .clipShape(Circle())
                .anyButton(.plain, action: onAttemptBadgeSelection)
            
            
            Image(systemName: "shield")
                .foregroundStyle(Color(hex: "D85A30"))
                .padding(10)
                .background(Color(hex: "FAECE7"))
                .clipShape(Circle())
                .anyButton(.plain, action: onHerculeanEffortSelection)
        }
    }
}

#Preview {
    LeaderboardProfileSectionView(
        userName: "LMS Admin",
        overallScore: 1.9,
        profiePicture: "",
        onAttemptBadgeSelection: {
        },
        onHerculeanEffortSelection: {
        })
}
