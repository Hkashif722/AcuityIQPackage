//
// OverViewStatItem.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 31/03/26.
//

import SwiftUI
import SwiftUIUtilities


struct OverViewStatItem: View {
    
    typealias StatCardModel = DetailReportDataModel.ScenarioAttemptResponse.StatCardModel
    
    let statModel: StatCardModel
    
    var body: some View {
        VStack(spacing: 4) {
            iconView
            headlineView
            subHeadlineView
        }
        .frame(maxWidth: .infinity)
        .cardStylePkg(padding: 8)
    }
    
    // MARK: - Subviews
    
    private var iconView: some View {
        Group {
            switch statModel.icon {
            case .system(let name):
                Image(systemName: name)
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.blue)
            case .bundle(let name, let bundle):
                Image(name, bundle: bundle)
                    .resizable()
                    .scaledToFit()
            }
        }
        .frame(width: 20, height: 15)
    }
    
    private var headlineView: some View {
        Text(statModel.label)
            .font(.body)
            .foregroundStyle(.primary)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
    }
    
    private var subHeadlineView: some View {
        Text(statModel.value)
            .font(.headline)
            .foregroundStyle(.secondary)
            .lineLimit(2)
            .minimumScaleFactor(0.8)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 12) {
        OverViewStatItem(
            statModel: DetailReportDataModel.ScenarioAttemptResponse.preview.statCards[0]
        )
        OverViewStatItem(
            statModel: DetailReportDataModel.ScenarioAttemptResponse.preview.statCards[0]
        )
    }
}
