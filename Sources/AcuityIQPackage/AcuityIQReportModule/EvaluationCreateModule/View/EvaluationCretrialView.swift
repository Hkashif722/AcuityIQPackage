//
//  EvaluationCretrialView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 06/04/26.
//

import SwiftUI
import SwiftfulRouting

struct EvaluationCretrialView: View {

    typealias EvaluationParameter = AcuityIQReportDataModel.Scenario.EvaluationParameter

    let router: AnyRouter
    let evaluationCriteriaList: [EvaluationParameter]

    var body: some View {
        VStack(spacing: 0) {
            headerView
            tableView
        }
    }
}

// MARK: - Subviews

extension EvaluationCretrialView {

    private var headerView: some View {
        HStack {
            Text("Evaluation criteria")
                .font(.title2.bold())

            Spacer()

            SwiftUIUtility
                .CircleCloseButton(
                    size: 35,
                    action: router.dismissScreen
                )
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
    }

    private var tableView: some View {
        VStack(spacing: 0) {
            tableHeaderView

            // Table Body
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(Array(evaluationCriteriaList.enumerated()), id: \.offset) { index, item in
                        tableRowView(item)

                        if index != evaluationCriteriaList.count - 1 {
                            Divider()
                                .padding(.horizontal)
                        }
                    }
                }
            }
            .versionedHorizontalContentMarginsPkg()
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
        .padding(.horizontal, 10)
        .padding(.vertical, 12)
        .background(Color.gray.opacity(0.08))
    }

    private func tableRowView(_ item: EvaluationParameter) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text(item.name ?? "")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary)
                .frame(width: 120, alignment: .leading)

            Text(item.description ?? "")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 16)
    }
}

#Preview {
    RouterView { router in
        EvaluationCretrialView(
            router: router,
            evaluationCriteriaList: AcuityIQReportDataModel.Scenario.preview.evaluationParameters ?? []
        )
    }
}
