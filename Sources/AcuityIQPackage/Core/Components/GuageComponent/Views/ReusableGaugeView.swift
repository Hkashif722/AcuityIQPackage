//
//  ReusableGaugeView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 31/03/26.
//

import SwiftUI

@available(iOS 16.0, *)
struct ReusableGaugeView<Value: BinaryFloatingPoint, Segment: GaugeSegmentProtocol>: View {
    
    let value: Value
    let range: ClosedRange<Value>
    let title: String
    let systemImage: String
    let segments: [Segment]
    let showLegend: Bool
    let valueFormatter: (Value) -> String
    
    init(value: Value, range: ClosedRange<Value>, title: String, systemImage: String, segments: [Segment], showLegend: Bool = false, valueFormatter: @escaping (Value) -> String) {
        self.value = value
        self.range = range
        self.title = title
        self.systemImage = systemImage
        self.segments = segments
        self.showLegend = showLegend
        self.valueFormatter = valueFormatter
    }
    
    var gradient: Gradient {
        Gradient(stops: segments.map {
            .init(color: $0.color, location: $0.location)
        })
    }
    
    var body: some View {
        VStack(spacing: 30) {
            
            // Header
            HStack {
                Image(systemName: systemImage)
                    .foregroundColor(.blue)
                    .font(.system(size: 15))
                Text(title)
                    .font(.caption.bold())
                Spacer()
            }
            
            // Gauge
            Gauge(value: Double(value), in: Double(range.lowerBound)...Double(range.upperBound)) {
                
            } currentValueLabel: {
                Text(valueFormatter(value))
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundColor(.cyan)
            }
            .gaugeStyle(.accessoryCircular)
            .tint(gradient)
            .scaleEffect(1.5)
            
            // Legend
            legendView
        }
    }
    
    // MARK: - Legend
    @ViewBuilder
    private var legendView: some View {
        if showLegend {
            VStack(spacing: 8) {
                ForEach(Array(segments.chunked(into: 2).enumerated()), id: \.offset) { _, row in
                    HStack(spacing: 12) {
                        ForEach(Array(row.enumerated()), id: \.offset) { _, item in
                            GuageLegend(color: item.color, text: item.title)
                        }
                    }
                }
            }
        }
    }
}
