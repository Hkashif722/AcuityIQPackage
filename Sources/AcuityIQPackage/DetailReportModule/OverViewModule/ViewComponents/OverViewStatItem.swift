//
// OverViewHeaderInfoMenuView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 31/03/26.
//

import SwiftUI


struct OverViewHeaderInfoMenuView: View {
    
    let icon: Icon
    let headline: String
    let subHeadline: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            iconView
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                headlineView
                subHeadlineView
            }
            
            Spacer()
        }
        .padding(16)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal, 16)
    }
    
    // MARK: - Subviews
    
    @ViewBuilder
    private var iconView: some View {
        switch icon {
        case .system(let name):
            Image(systemName: name)
                .resizable()
                .scaledToFit()
                .foregroundStyle(.primary)
        case .bundle(let name, let bundle):
            Image(name, bundle: bundle)
                .resizable()
                .scaledToFit()
        }
    }
    
    private var headlineView: some View {
        Text(headline)
            .font(.headline)
            .foregroundStyle(.primary)
            .lineLimit(1)
    }
    
    private var subHeadlineView: some View {
        Text(subHeadline)
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .lineLimit(2)
            .fixedSize(horizontal: false, vertical: true)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 12) {
        OverViewHeaderInfoMenuView(
            icon: .system(name: "brain.head.profile"),
            headline: "Acuity IQ",
            subHeadline: "Track your cognitive performance over time."
        )
        OverViewHeaderInfoMenuView(
            icon: .system(name: "chart.bar.fill"),
            headline: "Weekly Report",
            subHeadline: "Your score improved by 12% this week."
        )
    }
}
