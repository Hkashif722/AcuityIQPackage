//
//  StatVideoView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 31/03/26.
//

import SwiftUI
import SwiftUIUtilities

struct StatVideoView: View {
    let url = URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/master.m3u8")!
    var body: some View {
        VStack {
            UIKitComponentRepresentable.PlayerKitView(videoURL: url)
                .cornerRadiusPkg(10, corners: .allCorners)
        }
        .cardStylePkg(padding: 10)
    }
}

#Preview {
    StatVideoView()
}
