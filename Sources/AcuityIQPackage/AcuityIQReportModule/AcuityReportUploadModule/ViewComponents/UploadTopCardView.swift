//
//  UploadTopCardView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 06/04/26.
//

import SwiftUI

struct UploadTopCardView: View {

    let title: String
    let description: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)

            Text(description)
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    UploadTopCardView(
        title: "Upload New Attempts For: Test",
        description: "A structured session where the candidate introduces a product or service, highlights its value, and engages the target audience to create interest or move toward a sale."
    )
    .padding()
}
