//
//  UploadActionButtonsView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 06/04/26.
//

import SwiftUI

struct UploadActionButtonsView: View {

    let buttons: [AcuityReportUploadDataModel.ActionButton]

    var body: some View {
        HStack(spacing: 16) {
            ForEach(buttons) { button in
                actionButton(title: button.title, action: button.action)
            }
        }
    }

    private func actionButton(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, minHeight: 50)
                .foregroundStyle(.blue)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.blue, lineWidth: 2)
                )
        }
    }
}

#Preview {
    UploadActionButtonsView(
        buttons: AcuityReportUploadDataModel.actionButtons(
            onEvaluationCriteria: { print("Evaluation") },
            onKeywords: { print("Keywords") },
            onViewAllAttempts: { print("attempts") }
        )
    )
    .padding()
}
