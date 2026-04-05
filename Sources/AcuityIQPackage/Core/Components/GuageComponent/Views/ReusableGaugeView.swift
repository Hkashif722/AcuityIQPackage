@available(iOS 16.0, *)
struct ReusableGaugeView<Value: BinaryFloatingPoint, Segment: GaugeSegmentProtocol>: View {
    
    let value: Value
    let range: ClosedRange<Value>
    let title: String
    let systemImage: String
    let segments: [Segment]
    let valueFormatter: (Value) -> String
    
    var gradient: Gradient {
        Gradient(stops: segments.map {
            .init(color: $0.color, location: $0.location)
        })
    }
    
    var body: some View {
        VStack(spacing: 20) {
            
            // Header
            HStack {
                Image(systemName: systemImage)
                    .foregroundColor(.blue)
                Text(title)
                    .font(.headline)
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
    private var legendView: some View {
        VStack(spacing: 8) {
            ForEach(Array(segments.chunked(into: 2).enumerated()), id: \.offset) { _, row in
                HStack(spacing: 12) {
                    ForEach(Array(row.enumerated()), id: \.offset) { _, item in
                        Legend(color: item.color, text: item.title)
                    }
                }
            }
        }
    }
}