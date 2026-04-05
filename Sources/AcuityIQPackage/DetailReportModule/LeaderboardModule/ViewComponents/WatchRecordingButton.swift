//
//  WatchRecordingButton.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 05/04/26.
//

import SwiftUI
import SwiftUIUtilities

struct WatchRecordingButton: View {
    
    let gradientStops: [Gradient.Stop]
    let onPressed: () -> Void
    
    var foregroundColor: Color {
        Color.dynamicTextColor(for: gradientStops)
    }
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "play.fill")
                .font(.subheadline)
            Text("Watch recording")
                .font(.subheadline.bold())
        }
        .foregroundStyle(foregroundColor)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .reusableGradientBackgroundPkg(
            stops: gradientStops,
            startPoint: .leading,
            endPoint: .trailing
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .anyButton(.plain, action: onPressed)
    }
}

#Preview {
    WatchRecordingButton(
        gradientStops: LeaderboardDataModel.LeaderboardAttempt.leaderBoardHeaderGradientStop,
        onPressed: {}
    )
    .padding()
}
