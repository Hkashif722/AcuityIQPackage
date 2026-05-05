//
//  ManagerEvaluationListItemView.swift
//  AcuityIQPackage
//

import SwiftUI

struct ManagerEvaluationListItemView: View {

    let scenario: ManagerEvaluationListDataModel.ScenarioAttempt
    let onTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            titleRow
            infoRow
        }
        .padding(16)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .contentShape(Rectangle())
        .onTapGesture { onTap() }
    }
}

// MARK: - Title Row
private extension ManagerEvaluationListItemView {

    var titleRow: some View {
        HStack(alignment: .top, spacing: 8) {
            HStack(spacing: 8) {
                Text(scenario.scenarioName ?? "")
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                if scenario.hasNewAttempts {
                    newBadge
                }
            }

            statusBadge
        }
    }

    var newBadge: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(Color(hex: "#f87171"))
                .frame(width: 6, height: 6)
            Text("New")
                .font(.caption.bold())
                .foregroundStyle(Color(hex: "#f87171"))
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color(hex: "#fef2f2"))
        .clipShape(Capsule())
    }

    var statusBadge: some View {
        HStack(spacing: 4) {
            Image(systemName: scenario.isSubmitted ? "checkmark.circle.fill" : "clock")
                .font(.caption)
            Text(scenario.status ?? "Pending")
                .font(.caption.bold())
        }
        .foregroundStyle(scenario.isSubmitted ? Color(hex: "#059669") : Color(hex: "#b45309"))
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(scenario.isSubmitted ? Color(hex: "#ecfdf5") : Color(hex: "#fffbeb"))
        .clipShape(Capsule())
    }
}

// MARK: - Info Row
private extension ManagerEvaluationListItemView {

    var infoRow: some View {
        HStack {
            infoText
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }

    var infoText: some View {
        (
            Text("Course: ").bold() + Text(scenario.courseTitle ?? "—")
            + Text(" • ")
            + Text("Type: ").bold() + Text(scenario.type ?? scenario.scenarioType ?? "—")
            + Text(" • ")
            + Text("User: ").bold() + Text(scenario.userName ?? "—")
        )
        .font(.caption)
        .foregroundStyle(.secondary)
    }
}

#Preview {
    VStack(spacing: 12) {
        ManagerEvaluationListItemView(
            scenario: .preview(status: "Submitted", newAttempts: true),
            onTap: {}
        )
        ManagerEvaluationListItemView(
            scenario: .preview(status: "Pending", newAttempts: true),
            onTap: {}
        )
        ManagerEvaluationListItemView(
            scenario: .preview(status: "Pending", newAttempts: false),
            onTap: {}
        )
    }
    .padding()
}
