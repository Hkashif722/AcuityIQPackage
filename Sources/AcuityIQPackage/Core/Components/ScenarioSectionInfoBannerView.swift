//
//  ScenarioSectionInfoBannerView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 01/04/26.
//


import SwiftUI

struct ScenarioSectionInfoBannerView: View {
    
    let text: String
    
    var body: some View {
        Text(text)
            .font(.subheadline)
            .foregroundColor(Color.blue)
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.blue.opacity(0.08))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.blue.opacity(0.3), lineWidth: 1)
            )
    }
}