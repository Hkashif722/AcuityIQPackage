@available(iOS 16.0, *)
struct GaugeExample: View {
    
    @State private var score = 2.8
    
    let segments: [GaugeSegment] = [
        .init(color: .red, title: "Poor", location: 0.0),
        .init(color: .orange, title: "Below Avg", location: 0.25),
        .init(color: .blue, title: "Average", location: 0.5),
        .init(color: .cyan, title: "Good", location: 0.75),
        .init(color: .green, title: "Excellent", location: 1.0),
    ]
    
    var body: some View {
        ReusableGaugeView(
            value: score,
            range: 0...5,
            title: "Overall Score",
            systemImage: "chart.bar.fill",
            segments: segments
        ) { value in
            String(format: "%.1f", Double(value))
        }
        .frame(width: 220)
    }
}