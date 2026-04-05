//
//  SwiftUIView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 02/04/26.
//

import SwiftUI

struct WhatWentWellInfoView: View {
    
    let whatWentWellInfo: String
    
    var body: some View {
        VStack {
            whatWentWellLabelView
            infoView
        }
    }
    
    
    private var whatWentWellLabelView: some View {
        HStack {
            Label {
                Text("What Went Well")
                    .font(.headline)
                    .fontWeight(.semibold)
            } icon: {
                Image(systemName: "hand.thumbsup")
                    .foregroundStyle(.blue)
                    .padding(4)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.blue.opacity(0.4), lineWidth: 1)
                    )
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var infoView: some View {
        Text(whatWentWellInfo)
            .font(.footnote)
            .foregroundStyle(Color(.darkGray))
    }
}

#Preview {
    WhatWentWellInfoView(
        whatWentWellInfo: "Step function graphs showing how each behavioral metric progressed throughout your audio presentation. Each data point represents the score at that specific time interval."
    )
}
