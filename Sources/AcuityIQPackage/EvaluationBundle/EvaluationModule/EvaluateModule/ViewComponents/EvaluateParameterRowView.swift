//
//  EvaluateParameterRowView.swift
//  AcuityIQPackage
//

import SwiftUI

struct EvaluateParameterRowView: View {

    @Binding var entry: EvaluateModuleDataModel.EvaluationFormEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            parameterHeader
            fieldsRow
        }
        .padding(16)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

// MARK: - Header
private extension EvaluateParameterRowView {

    var parameterHeader: some View {
        Text(entry.parameter)
            .font(.body.weight(.semibold))
            .foregroundStyle(.primary)
    }
}

// MARK: - Fields
private extension EvaluateParameterRowView {

    var fieldsRow: some View {
        HStack(alignment: .top, spacing: 12) {
            scoreColumn
            remarksColumn
        }
    }

    var scoreColumn: some View {
        VStack(alignment: .leading, spacing: 4) {
            TextField("1–\(entry.maxScore)", text: $entry.scoreText)
                .keyboardType(.decimalPad)
                .font(.body)
                .multilineTextAlignment(.center)
                .tint(.blue)
                .padding(.horizontal, 10)
                .padding(.vertical, 10)
                .background(Color(.tertiarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(scoreFieldBorderColor, lineWidth: 1)
                )
                .frame(width: 84)

            Text("Max: \(entry.maxScore)")
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(width: 84, alignment: .trailing)
        }
    }

    var remarksColumn: some View {
        VStack(alignment: .trailing, spacing: 4) {
            ZStack(alignment: .topLeading) {
                if entry.remarks.isEmpty {
                    Text("Add your feedback...")
                        .font(.subheadline)
                        .foregroundStyle(.tertiary)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 8)
                }
                TextEditor(text: $entry.remarks)
                    .font(.subheadline)
                    .tint(.blue)
                    .frame(minHeight: 45)
                    .scrollContentBackgroundPkg(.hidden)
                    .onChange(of: entry.remarks) { newValue in
                        if newValue.count > 1000 {
                            entry.remarks = String(newValue.prefix(1000))
                        }
                    }
            }
            .padding(6)
            .background(Color(.tertiarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(.separator).opacity(0.4), lineWidth: 1)
            )

            Text("\(entry.remarks.count)/1000")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: 70)
    }

    var scoreFieldBorderColor: Color {
        if entry.scoreText.isEmpty {
            return Color(hex: "#ef4444").opacity(0.7)
        }
        if let score = Double(entry.scoreText),
           score >= 1, score <= Double(entry.maxScore) {
            return Color(hex: "#10b981").opacity(0.6)
        }
        return Color(hex: "#ef4444").opacity(0.7)
    }
}

@available(iOS 17.0, *)
#Preview {
    @Previewable @State var entry = EvaluateModuleDataModel.EvaluationFormEntry(parameter: "Clarity", maxScore: 20)
    return EvaluateParameterRowView(entry: $entry)
        .padding()
}
