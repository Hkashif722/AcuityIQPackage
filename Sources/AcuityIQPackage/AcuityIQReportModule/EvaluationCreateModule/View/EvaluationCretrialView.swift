//
//  EvaluationCretrialView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 06/04/26.
//

import SwiftUI

struct EvaluationCretrialView: View {

    typealias EvaluationCriteria = DetailReportDataModel.EvaluationCriteria

    let evaluationCriteriaList: [EvaluationCriteria]
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            // Header
            headerView

            // Table
            tableView
        }
        .background(Color(.systemBackground))
    }
}

// MARK: - Subviews

extension EvaluationCretrialView {

    private var headerView: some View {
        VStack(spacing: 16) {
            // Drag indicator
            Capsule()
                .fill(Color.gray.opacity(0.4))
                .frame(width: 36, height: 5)
                .padding(.top, 12)

            HStack {
                Text("Evaluation criteria")
                    .font(.title2.bold())
                    .foregroundStyle(.primary)

                Spacer()

                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.body.weight(.medium))
                        .foregroundStyle(.secondary)
                        .frame(width: 28, height: 28)
                        .background(Color.gray.opacity(0.15))
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
    }

    private var tableView: some View {
        VStack(spacing: 0) {
            // Table Header
            tableHeaderView

            // Table Body
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(evaluationCriteriaList) { item in
                        tableRowView(item)

                        if item.id != evaluationCriteriaList.last?.id {
                            Divider()
                                .padding(.horizontal)
                        }
                    }
                }
            }
        }
    }

    private var tableHeaderView: some View {
        HStack {
            Text("Criteria")
                .frame(width: 120, alignment: .leading)

            Text("Description")
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .font(.subheadline)
        .foregroundStyle(.secondary)
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background(Color.gray.opacity(0.08))
    }

    private func tableRowView(_ item: EvaluationCriteria) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text(item.parameter)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary)
                .frame(width: 120, alignment: .leading)

            Text(item.remarks ?? "")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal)
        .padding(.vertical, 16)
    }
}

#Preview {
    EvaluationCretrialView(
        evaluationCriteriaList: DetailReportDataModel.ScenarioAttemptResponse.preview.evaluationCriteria ?? []
    )
}
