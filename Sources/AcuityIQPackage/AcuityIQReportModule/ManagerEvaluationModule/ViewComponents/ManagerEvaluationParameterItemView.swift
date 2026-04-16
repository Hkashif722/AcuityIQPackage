//
//  ManagerEvaluationParameterItemView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 13/04/26.
//

import SwiftUI

struct ManagerEvaluationParameterItemView: View {

    let index: Int
    let parameter: AcuityIQReportDataModel.Scenario.ManagerEvaluationParameter

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            headerRow
            progressBar
            remarksView
        }
        .padding(16)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color(.systemGray5), lineWidth: 0.8)
        )
    }

    // MARK: - Header Row

    private var headerRow: some View {
        HStack(alignment: .center) {
            indexBadge
            Text(parameter.parameter ?? "—")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.primary)
            Spacer()
            scoreBadge
        }
    }

    private var indexBadge: some View {
        ZStack {
            Circle()
                .fill(Color(red: 0.92, green: 0.90, blue: 0.97))
                .frame(width: 26, height: 26)
            Text("\(index)")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(Color(red: 0.33, green: 0.29, blue: 0.72))
        }
    }

    private var scoreBadge: some View {
        HStack(spacing: 0) {
            Text("\(Int(parameter.score ?? 0))")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(parameter.badgeForegroundColor)
            Text("/20")
                .font(.system(size: 13))
                .foregroundColor(parameter.badgeForegroundColor.opacity(0.6))
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 4)
        .background(parameter.badgeBackgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    // MARK: - Progress Bar

    private var progressBar: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color(.systemGray5))
                    .frame(height: 4)
                RoundedRectangle(cornerRadius: 3)
                    .fill(parameter.progressBarColor)
                    .frame(width: geo.size.width * parameter.progress, height: 4)
            }
        }
        .frame(height: 4)
    }

    // MARK: - Remarks

    @ViewBuilder
    private var remarksView: some View {
        if let remarks = parameter.remarks, !remarks.isEmpty {
            HStack(alignment: .top, spacing: 6) {
                Image(systemName: "quote.opening")
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
                    .padding(.top, 1)
                Text(remarks)
                    .font(.system(size: 13))
                    .italic()
                    .foregroundColor(.secondary)
            }
        }
    }
}


#Preview {
    VStack(spacing: 12) {
        ManagerEvaluationParameterItemView(
            index: 1,
            parameter: .init(parameter: "Clarity", score: 1, remarks: "Ggfgj")
        )
        ManagerEvaluationParameterItemView(
            index: 2,
            parameter: .init(parameter: "Content Relevance", score: 15, remarks: "Excellent relevance")
        )
    }
    .padding()
}
