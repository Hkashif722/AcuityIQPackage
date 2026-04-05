//
//  ReportScoreGroupView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 01/04/26.
//

import SwiftUI


// MARK: - IntegrityScoreGroupView
struct IntegrityScoreGroupView: View {
    typealias ScoreLevel = DetailReportDataModel.ScenarioAttemptResponse.ScoreLevel

    let level: ScoreLevel 

    var body: some View {
        GroupBox {
            contentView
        } label: {
            labelView
        }
    }

    private var contentView: some View {
        VStack(alignment: .leading, spacing: 12) {

            Text("— \(level.subtitle)")
                .font(.subheadline)
                .italic()
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(alignment: .top, spacing: 0) {
                Rectangle()
                    .fill(level.color)
                    .frame(width: 4)

                VStack(alignment: .leading, spacing: 6) {
                    Label {
                        Text(level.alertTitle)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(level.color)
                    } icon: {
                        Image(systemName: level.alertIcon)
                            .foregroundStyle(level.alertIconColor)
                    }

                    Text(level.alertMessage)
                        .font(.subheadline)
                        .foregroundStyle(level.color.opacity(0.85))
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(level.color.opacity(0.08))
            }
            .clipShape(RoundedRectangle(cornerRadius: 6))
        }
        .padding(.top, 2)
    }

    private var labelView: some View {
        HStack {
            Label {
                Text(level.title)
            } icon: {
                Image(systemName: level.icon)
                    .foregroundStyle(level.iconColor)
            }
            .font(.headline)

            Spacer()

            Image(systemName: level.trailingIcon)
                .foregroundStyle(level.color)
                .font(.title3)
        }
    }
}

// MARK: - Preview

#Preview {
    
    ScrollView {
        VStack(spacing: 16) {
            ForEach(
                DetailReportDataModel.ScenarioAttemptResponse.ScoreLevel.allCases,
                id: \.self
            ) { level in
                IntegrityScoreGroupView(level: level)
            }
        }
        .padding()
    }
}
