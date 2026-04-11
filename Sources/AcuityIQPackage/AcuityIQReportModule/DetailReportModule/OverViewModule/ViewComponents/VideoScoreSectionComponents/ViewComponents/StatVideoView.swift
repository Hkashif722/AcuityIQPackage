//
//  StatVideoView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 31/03/26.
//

import SwiftUI
import SwiftUIUtilities

struct StatVideoView: View {
    let videoPathURL: URL
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            headerView
            UIKitComponentRepresentable.PlayerKitView(videoURL: videoPathURL)
                .cornerRadiusPkg(10, corners: .allCorners)
        }
        .frame(maxWidth: .infinity)
        .layoutPriority(1)
        .cardStylePkg(padding: 10)
    }
    
    var headerView: some View {
        HStack(spacing: 8) {
            Image(systemName: "video.fill")
                .foregroundColor(Color.blue)
                .font(.system(size: 15))
            
            Text("Video")
                .font(.caption.bold())
                .foregroundColor(.primary)
                
        }
    }
}

#Preview {
    StatVideoView(videoPathURL: URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/master.m3u8")! )
}
