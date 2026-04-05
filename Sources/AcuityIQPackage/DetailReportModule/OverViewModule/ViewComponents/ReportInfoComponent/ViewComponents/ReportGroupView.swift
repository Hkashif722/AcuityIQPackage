//
//  SwiftUIView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 01/04/26.
//

import SwiftUI

struct ReportGroupView: View {

    let icon: String
    var iconColor: Color = .accentColor
    let title: String
    let description: String

    var body: some View {
        GroupBox {
            Text(description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        } label: {
            Label {
                Text(title)
            } icon: {
                Image(systemName: icon)
                    .foregroundStyle(iconColor)
            }
            .font(.headline)
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        ReportGroupView(
            icon: "chart.bar.fill",
            iconColor: .blue,
            title: "Monthly Report",
            description: "Summary of activity for the current month."
        )

        ReportGroupView(
            icon: "person.3.fill",
            iconColor: .purple,
            title: "Team Overview",
            description: "12 active learners across 3 departments."
        )
    }
    .padding()
}
