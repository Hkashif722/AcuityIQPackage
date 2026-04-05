// MARK: - Protocol
/// Any data point that can be plotted on MetricLineChartView
/// must conform to this protocol.
public protocol LineChartDataPoint: Identifiable {
    var time: Double { get }   // x-axis in seconds
    var score: Double { get }  // y-axis value
}
