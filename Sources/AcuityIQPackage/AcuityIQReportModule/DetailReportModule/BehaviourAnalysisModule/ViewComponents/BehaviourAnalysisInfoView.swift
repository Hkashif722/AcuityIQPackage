//
//  SwiftUIView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 02/04/26.
//

import SwiftUI

struct BehaviourAnalysisInfoView: View {
    
    let feedback: String
    let improvements: [String]
    
    
    var body: some View {
        VStack(spacing: 8) {
            VStack {
                feedbackDetailView
                ImprovementRequiredView(improvements: improvements)
            }
        }
    }
    
    
    private var feedbackDetailView: some View {
        Text(feedback)
            .font(.footnote)
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundStyle(Color(.darkGray))
    }
}

#Preview {
    BehaviourAnalysisInfoView(
        feedback: "The delivery was clear in parts, but consistency can be improved. Focus on maintaining clarity throughout the response and avoiding abrupt transitions.",
        improvements:  [
            "0:05 - Clearly articulate the product names and their components to avoid confusion. For example, instead of 'gravitas mankind present tellmekind ct 40 and 80', say 'I would like to introduce our products, Tellmekind CT 40 and 80.'",
            "0:10 - Break down complex terms into simpler language. Instead of 'stage 2 hypertension with high cb risk', say 'for patients with stage 2 hypertension and high cardiovascular risk.'"
        ]
    )
    .padding(.horizontal)
}
