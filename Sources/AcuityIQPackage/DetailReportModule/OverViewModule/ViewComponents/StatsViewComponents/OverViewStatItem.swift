//
// OverViewStatItem.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 31/03/26.
//

import SwiftUI


struct OverViewStatItem: View {
    
    typealias StatCardModel = OverViewDataModel.ScenarioAttemptResponse.StatCardModel
    
    let statModel: StatCardModel
    
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
        switch statModel.icon {
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
        Text(statModel.label)
            .font(.headline)
            .foregroundStyle(.primary)
            .lineLimit(1)
    }
    
    private var subHeadlineView: some View {
        Text(statModel.value)
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .lineLimit(2)
            .fixedSize(horizontal: false, vertical: true)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 12) {
        OverViewStatItem(
            statModel: OverViewDataModel.ScenarioAttemptResponse.preview.statCards[0]
        )
        OverViewStatItem(
            statModel: OverViewDataModel.ScenarioAttemptResponse.preview.statCards[0]
        )
    }
}
