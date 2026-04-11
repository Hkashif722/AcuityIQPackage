//
//  UploadPreviewSectionView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 06/04/26.
//

import SwiftUI

struct UploadPreviewSectionView: View {

    let attemptExausted: Bool
    let items: [AcuityReportUploadDataModel.PreviewItem]

    var body: some View {
        HStack(spacing: 16) {
            ForEach(items) { item in
                previewItemButton(item: item)
            }
        }
    }

    private func previewItemButton(item: AcuityReportUploadDataModel.PreviewItem) -> some View {
        Button(action: item.action) {
            HStack(spacing: 8) {
                Image(systemName: item.icon)
                    .foregroundStyle(.primary)

                Text(item.title)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
            }
            .frame(maxWidth: .infinity, minHeight: 50)
            .background(Color(.systemGray5))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .disabled(attemptExausted)
    }
}

#Preview {
    UploadPreviewSectionView(
        attemptExausted: false,
        items: AcuityReportUploadDataModel.previewItems(
            refVideo: nil,
            onProductKnowledge: { print("Product Knowledge") },
            onReferenceVideo: { print("Reference Video") }
        )
    )
    .padding()
}
