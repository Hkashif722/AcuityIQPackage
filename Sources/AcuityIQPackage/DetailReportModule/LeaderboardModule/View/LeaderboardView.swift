//
//  LeaderboardView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 05/04/26.
//

import SwiftUI
import SwiftUIUtilities

struct LeaderboardView: View {
    
    var body: some View {
        LeaderboardRandCardView()
    }
    
    
   
    
}

#Preview {
    LeaderboardView()
}


struct LeaderboardRandCardView: View {
    
    @State private var isExpanded: Bool = false
    
//    let headerGradientColor: [Color]
    
    let headerGradientStop: [Gradient.Stop] = [
        Gradient.Stop(color: Color(hex: "5B6AFA"), location: 0.0),
        Gradient.Stop(color: Color(hex: "7B8AFE"), location: 0.5),
        Gradient.Stop(color: Color(hex: "9B8AFF"), location: 1.0)
    ]
    
    var getForeGroundColor: Color {
        Color.dynamicTextColor(for: headerGradientStop)
    }
    
    var body: some View {
        
        VStack {
            
            if isExpanded {
                expandedCardHeaderView
            } else {
                collapedCardHeaderView
            }
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        
    }
    
   
}

//MARK: Expanded Header View
extension LeaderboardRandCardView {
    
    private var expandedCardHeaderView: some View {
        HStack {
            
            rankView
            
            Spacer()
            
            scoreTagView
           
        }
        .padding()
        .reusableGradientBackgroundPkg(
            stops: [
                Gradient.Stop(color: Color(hex: "5B6AFA"), location: 0.0),
                Gradient.Stop(color: Color(hex: "7B8AFE"), location: 0.5),
                Gradient.Stop(color: Color(hex: "9B8AFF"), location: 1.0)
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
        .anyButton(.press, action: {isExpanded.toggle() })
    }
    
   
    
    
    private var scoreTagView: some View {
        Text("Score: 1.9")
            .font(.subheadline.bold())
            .foregroundStyle(getForeGroundColor)
            .padding(.init(top: 8, leading: 16, bottom: 8, trailing: 16))
            .clipShape(Capsule())
            .background(getForeGroundColor.opacity(0.2))
            .cornerRadiusPkg(16, corners: .allCorners)
    }
}


//MARK: Collasped Header View
extension LeaderboardRandCardView {
    
    private var collapedCardHeaderView: some View {
        HStack(spacing: 16) {
            rankView
            LeaderboardProfileSectionView()
        }
        .anyButton(.press, action: {isExpanded.toggle() })
    }
    
}


extension LeaderboardRandCardView {
    
    private var rankView: some View {
        HStack {
            if isExpanded {
                Image(systemName: "trophy.fill")
                    .foregroundStyle(Color(hex: "#E5A100"))
            }
            Text("Rank #1")
                .font(.headline.bold())
                .foregroundStyle(isExpanded ? getForeGroundColor : .primary)
        }
    }
    
    
}
