//
//  Legend.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 31/03/26.
//

import SwiftUI

struct GuageLegend: View {
    let color: Color
    let text: String
    
    var body: some View {
        HStack(spacing: 6) {
            Rectangle()
                .fill(color)
                .frame(width: 30, height: 8)
                .cornerRadius(2)
            
            Text(text)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}
