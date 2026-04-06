//
//  KeywordsView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 06/04/26.
//

import SwiftUI
import SwiftfulRouting

struct KeywordsView: View {

    let router: AnyRouter
    let keywords: [String]

    var body: some View {
        VStack(spacing: 0) {
            headerView
            tableView
        }
    }
}

// MARK: - Subviews

extension KeywordsView {

    private var headerView: some View {
        HStack {
            Text("Keywords")
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
                    ForEach(Array(keywords.enumerated()), id: \.offset) { index, keyword in
                        tableRowView(index: index + 1, keyword: keyword)

                        if index != keywords.count - 1 {
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
            Text("#")
                .frame(width: 40, alignment: .leading)

            Text("Keyword")
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .font(.subheadline)
        .foregroundStyle(.secondary)
        .padding(.horizontal, 10)
        .padding(.vertical, 12)
        .background(Color.gray.opacity(0.08))
    }

    private func tableRowView(index: Int, keyword: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(index)")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary)
                .frame(width: 40, alignment: .leading)

            Text(keyword)
                .font(.subheadline)
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 16)
    }
}

#Preview {
    RouterView { router in
        KeywordsView(
            router: router,
            keywords: AcuityIQReportDataModel.Scenario.preview.keywords ?? []
        )
    }
}
