//
//  MetricLineChartView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 02/04/26.
//


import SwiftUI
import Charts

// MARK: - Generic Chart View
public struct MetricLineChartView<DataPoint: LineChartDataPoint>: View {

    public let config: MetricLineChartConfig
    public let dataPoints: [DataPoint]

    public init(config: MetricLineChartConfig, dataPoints: [DataPoint]) {
        self.config = config
        self.dataPoints = dataPoints
    }

    // MARK: - Computed
    private var average: Double {
        let valid = dataPoints.filter { $0.score > 0 }
        guard !valid.isEmpty else { return 0 }
        return valid.map(\.score).reduce(0, +) / Double(valid.count)
    }

    private var xDomain: ClosedRange<Double> {
        let times = dataPoints.map(\.time)
        return (times.min() ?? 0)...(times.max() ?? 1)
    }

    private var yAxisValues: [Double] {
        stride(
            from: config.yDomain.lowerBound,
            through: config.yDomain.upperBound,
            by: config.yStep
        ).map { $0 }
    }

    private var xTicks: [Double] {
        dataPoints.map(\.time)
    }

    // MARK: - Body
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            headerView
            chartView
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Subviews
private extension MetricLineChartView {

    var headerView: some View {
        HStack(alignment: .top) {
            Text(config.title)
                .font(.largeTitle.bold())

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text("Average:")
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
                Text(String(format: "%.1f", average) + config.unit)
                    .font(.title2.bold())
            }
        }
    }

    var chartView: some View {
        Chart {
            // Dashed average rule line
            RuleMark(y: .value("Average", average))
                .lineStyle(StrokeStyle(lineWidth: 1.5, dash: [6, 4]))
                .foregroundStyle(.gray.opacity(0.6))

            // Main line
            ForEach(dataPoints) { point in
                LineMark(
                    x: .value("Time", point.time),
                    y: .value("Score", point.score)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(config.accentColor)
                .lineStyle(StrokeStyle(lineWidth: 2))
            }

            // Dot markers
            ForEach(dataPoints) { point in
                PointMark(
                    x: .value("Time", point.time),
                    y: .value("Score", point.score)
                )
                .foregroundStyle(config.accentColor)
                .symbolSize(60)
            }
        }
        .chartYScale(domain: config.yDomain)
        .chartXScale(domain: xDomain)
        .chartYAxis {
            AxisMarks(values: yAxisValues) { _ in
                AxisGridLine()
                AxisTick()
                AxisValueLabel()
            }
        }
        .chartXAxis {
            AxisMarks(values: xTicks) { value in
                AxisGridLine()
                AxisTick()
                AxisValueLabel {
                    if let seconds = value.as(Double.self) {
                        Text(formatTime(seconds)).font(.caption)
                    }
                }
            }
        }
        .frame(height: 260)
    }

    func formatTime(_ seconds: Double) -> String {
        let m = Int(seconds) / 60
        let s = Int(seconds) % 60
        return String(format: "%02d:%02d", m, s)
    }
}

// MARK: - Preview
#Preview {
    ScrollView {
        VStack(spacing: 20) {
            MetricLineChartView(
                config: .init(title: "Clarity", accentColor: .blue, yDomain: 0...7),
                dataPoints: [
                    ClarityPoint(time: 0,  score: 0.0, feedback: nil),
                    ClarityPoint(time: 30, score: 6.8, feedback: "Good pacing"),
                    ClarityPoint(time: 60, score: 6.6, feedback: nil),
                    ClarityPoint(time: 75, score: 6.6, feedback: "Consistent"),
                ]
            )
            MetricLineChartView(
                config: .init(title: "Confidence", accentColor: .green, yDomain: 0...10, unit: "/10"),
                dataPoints: [
                    ConfidencePoint(time: 0,  score: 0.0, isKeyMoment: false),
                    ConfidencePoint(time: 20, score: 5.0, isKeyMoment: false),
                    ConfidencePoint(time: 45, score: 7.5, isKeyMoment: true),
                    ConfidencePoint(time: 75, score: 8.0, isKeyMoment: false),
                ]
            )
            MetricLineChartView(
                config: .init(title: "Pace", accentColor: .orange, yDomain: 0...200, unit: " wpm", yStep: 50),
                dataPoints: [
                    PacePoint(time: 0,  score: 0),
                    PacePoint(time: 15, score: 120),
                    PacePoint(time: 45, score: 160),
                    PacePoint(time: 75, score: 145),
                ]
            )
        }
        .padding()
    }
    .background(Color(.systemGroupedBackground))
}