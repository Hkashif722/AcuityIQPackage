//
//  SwiftUIView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 03/04/26.
//

import SwiftUI

struct ImprovementRequiredView: View {
    
    let improvements: [String]
    
    var body: some View {
        improvementRequiredView
    }
    
    
    @ViewBuilder
    private var improvementRequiredView: some View {
        if improvements.count > 0 {
            VStack(spacing: 0) {
                Divider()
                    .background(Color.orange)
                VStack {
                    analysisInfoLabelView
                    ForEach(improvements, id: \.self) { bullet in
                        HStack(alignment: .top, spacing: 8) {
                            Circle()
                                .fill(.orange)
                                .frame(width: 6, height: 6)
                                .padding(.top, 5)
                            Text(bullet)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                .padding(8)
                .background(Color.orange.opacity(0.1))
                .cornerRadiusPkg(10, corners: [.bottomLeft, .bottomRight])
            }
        }
        
    }
    
    private var analysisInfoLabelView: some View {
        HStack {
            Label {
                Text("Improvement Required")
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color(hex: "#b85b18"))
            } icon: {
                Image(systemName: "lightbulb")
                    .foregroundStyle(Color(hex: "#b85b18"))
                    .font(.footnote)
                    .padding(.init(top: 4, leading: 8, bottom: 4, trailing: 8))
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color(hex: "#b85b18").opacity(0.4), lineWidth: 1)
                    )
            }
        }
        .padding(.bottom, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    ImprovementRequiredView(improvements: [
        "0:05 - Clearly articulate the product names and their components to avoid confusion. For example, instead of 'gravitas mankind present tellmekind ct 40 and 80', say 'I would like to introduce our products, Tellmekind CT 40 and 80.'",
        "0:10 - Break down complex terms into simpler language. Instead of 'stage 2 hypertension with high cb risk', say 'for patients with stage 2 hypertension and high cardiovascular risk.'"
    ])
}
