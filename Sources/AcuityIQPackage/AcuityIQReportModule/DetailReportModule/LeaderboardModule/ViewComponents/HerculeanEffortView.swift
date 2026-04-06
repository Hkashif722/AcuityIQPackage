//
//  HerculeanEffortView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 06/04/26.
//

import SwiftUI
import SwiftfulRouting

struct HerculeanEffortView: View {

    let router: AnyRouter
    let strengths: [String]

    var body: some View {
        VStack(spacing: 0) {
            headerView
            contentView
        }
    }
}

// MARK: - Subviews

extension HerculeanEffortView {

    private var headerView: some View {
        HStack(spacing: 12) {
            Image(systemName: "clipboard.fill")
                .foregroundStyle(.white)
                .padding(10)
                .background(Color.orange)
                .clipShape(RoundedRectangle(cornerRadius: 8))

            Text("Herculean\nEffort")
                .font(.headline)
                .foregroundStyle(.primary)
                .lineLimit(2)

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

    private var contentView: some View {
        VStack(alignment: .leading, spacing: 16) {
            strengthsCountView
            identifiedStrengthsHeader
            strengthsListView
        }
        .padding(.horizontal)
        .padding(.bottom)
    }

    private var strengthsCountView: some View {
        HStack(spacing: 4) {
            Text("\(strengths.count)")
                .font(.title.bold())
                .foregroundStyle(.primary)

            Text("strengths identified")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private var identifiedStrengthsHeader: some View {
        Text("Identified Strengths")
            .font(.subheadline.bold())
            .foregroundStyle(Color.orange)
    }

    private var strengthsListView: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 12) {
                ForEach(Array(strengths.enumerated()), id: \.offset) { _, strength in
                    strengthRowView(strength: strength)
                }
            }
        }
    }

    private func strengthRowView(strength: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "checkmark")
                .font(.caption.bold())
                .foregroundStyle(Color.orange)
                .padding(.top, 2)

            Text(strength)
                .font(.subheadline)
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#Preview {
    RouterView { router in
        HerculeanEffortView(
            router: router,
            strengths: [
                "In the beginning, the user introduced themselves confidently, which sets a positive tone for the conversation.",
                "Towards the middle, the user maintained a clear structure while presenting the medications, which is important for clarity.",
                "In the end, the user attempted to provide additional information about the products, indicating a willingness to engage further."
            ]
        )
    }
}
