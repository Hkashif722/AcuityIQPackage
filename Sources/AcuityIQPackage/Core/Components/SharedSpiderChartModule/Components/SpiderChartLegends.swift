//
//  SpiderChartLegends.swift
//  Ujjivan
//
//  Created by Kashif Hussain on 22/01/26.
//  Copyright © 2026 EnthrallTech. All rights reserved.
//

import SwiftUI

struct SpiderChartLegends: View {
    
    let items: [LegendItem]
    let onTap: (Int) -> Void
    
    var body: some View {
        HStack(spacing: 20) {
            ForEach(items.indices, id: \.self) { index in
                Button {
                    onTap(index)
                } label: {
                    HStack(spacing: 8) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color(items[index].color))
                            .frame(width: 30, height: 12)
                            .opacity(items[index].isVisible ? 1 : 0.3)
                        
                        Text(items[index].label)
                            .font(.caption)
                            .foregroundStyle(items[index].isVisible ? .primary : .secondary)
                            .versionedStrikethrough(!items[index].isVisible)
                    }
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    // Legends items model
    struct LegendItem {
        let label: String
        let color: UIColor
        let isVisible: Bool
    }
}
