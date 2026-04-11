//
//  VideoUploadSectionView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 06/04/26.
//

import SwiftUI

struct VideoUploadSectionView: View {
    
    let attemptExausted: Bool
    let selectedFileName: String?
    let onBrowseFiles: () -> Void
    let onAnalyse: () -> Void

    var body: some View {
        ZStack {
            dashedBorder

            VStack(spacing: 12) {
                cloudIcon
                uploadText
                browseButton
                fileStatusView
                analyseButton
            }
            .padding()
        }
    }
}

// MARK: - Subviews

extension VideoUploadSectionView {

    private var dashedBorder: some View {
        RoundedRectangle(cornerRadius: 20)
            .stroke(style: StrokeStyle(lineWidth: 2, dash: [6]))
            .foregroundStyle(Color.gray.opacity(0.5))
    }

    private var cloudIcon: some View {
        ZStack {
            Image(systemName: "cloud.fill")
                .resizable()
                .scaledToFit()
                .foregroundStyle(.white)

            Image(systemName: "arrow.up")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.blue)
                .offset(y: 4)
        }
        .frame(width: 50, height: 50)
        .padding()
        .background(Color.blue)
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }

    private var uploadText: some View {
        VStack(spacing: 4) {
            Text("Upload your video")
                .font(.title3)
                .fontWeight(.semibold)

            Text("Max file size: \(AcuityReportUploadDataModel.Constants.maxFileSizeMB) MB")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private var browseButton: some View {
        Button(action: onBrowseFiles) {
            Text("Browse files")
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Color.blue.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .disabled(attemptExausted)
    }

    private var fileStatusView: some View {
        VStack(spacing: 4) {
            if let file = selectedFileName {
                Text("File uploaded")
                    .font(.caption)
                    .foregroundStyle(.green)

                Text(file)
                    .font(.caption)
                    .fontWeight(.medium)
                    .lineLimit(1)
                    .truncationMode(.middle)
            } else {
                Text(" ")
                    .hidden()
            }
        }
        .frame(height: 35)
        .animation(.easeInOut, value: selectedFileName)
    }

    private var analyseButton: some View {
        Button(action: onAnalyse) {
            Text("Analyse")
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    LinearGradient(
                        colors: AcuityReportUploadDataModel.Constants.gradientColors,
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 25))
        }
        .disabled(!(selectedFileName != nil))
        .opacity(selectedFileName != nil ? 1 : 0.5)
    }
}

#Preview {
    VStack(spacing: 20) {
        VideoUploadSectionView(
            attemptExausted: true,
            selectedFileName: "file",
            onBrowseFiles: {},
            onAnalyse: {}
        )

        VideoUploadSectionView(
            attemptExausted: false,
            selectedFileName: "file",
            onBrowseFiles: {},
            onAnalyse: {}
        )
    }
    .padding()
}
