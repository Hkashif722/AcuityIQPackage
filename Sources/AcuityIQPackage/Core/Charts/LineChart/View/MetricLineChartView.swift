//
//  MetricLineChartView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 02/04/26.
//

import SwiftUI
import Charts

@available(iOS 16.0, *)
public struct MetricLineChartView<DataPoint: LineChartProtocol.LineChartDataPoint>: View {
    
    public typealias Config = LineChartConfiguration.MetricLineChartConfig

    public let config: Config
    public let dataPoints: [DataPoint]

    public init(config: Config, dataPoints: [DataPoint]) {
        self.config = config
        self.dataPoints = dataPoints
    }

    // MARK: - Computed
    private var average: Double {
        let valid = dataPoints.map(\.yValue).filter { $0 > 0 }
        guard !valid.isEmpty else { return 0 }
        return valid.reduce(0, +) / Double(valid.count)
    }

    private var xDomain: ClosedRange<Double> {
        let values = dataPoints.map(\.xValue)
        let minVal = values.min() ?? 1
        let maxVal = values.max() ?? 1
        let axisMax = xAxisValues.last ?? maxVal
        let step = ceil((maxVal - minVal) / 4.0)
        let leftPadding = max(0.5, step * 0.1)  // 10% of step, minimum 0.5
        return (minVal - leftPadding)...(Swift.max(maxVal, axisMax) + 0.2)
    }
    
    private var yAxisValues: [Double] {
        stride(
            from: config.yDomain.lowerBound,
            through: config.yDomain.upperBound,
            by: config.yStep
        ).map { $0 }
    }
    
    private var xAxisValues: [Double] {
        let sorted = Array(Set(dataPoints.map(\.xValue))).sorted()
        let count = sorted.count
        guard count > 5 else { return sorted }

        let first = sorted.first!
        let last = sorted.last!
        let step = ceil((last - first) / 4.0)

        return (0..<5).map { first + Double($0) * step }
    }

    // MARK: - Body
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            headerView
            chartView
        }
    }
}

// MARK: - Subviews
@available(iOS 16.0, *)
private extension MetricLineChartView {

    var headerView: some View {
        HStack {
            Text(config.title)
                .font(.title3.bold())

            Spacer()

            if config.showRuleMark {
                if config.chartType == .metric {
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("Average:")
                            .foregroundStyle(.secondary)
                            .font(.subheadline)
                        Text(String(format: "%.1f", average) + config.unit)
                            .font(.headline.bold())
                    }
                }
            }
        }
    }

    var chartView: some View {
        Chart {
            switch config.chartType {
            case .metric:
                metricContent
                
            case .sectionWise:
                sectionContent
            }
        }
        .applySectionColors(config.sectionColors)
        .chartXScale(domain: xDomain)
        .chartYScale(domain: config.yDomain)
        .chartYAxis {
            AxisMarks(position: .leading, values: yAxisValues)
        }
        .chartXAxis {
            AxisMarks(position: .bottom, values: xAxisValues) { value in
                AxisGridLine()
                AxisTick()
                
                AxisValueLabel(anchor: .topTrailing) {
                    if let doubleValue = value.as(Double.self) {
                        if let label = config.xLabel {
                            Text("\(label) \(Int(doubleValue))")
                        } else {
                            Text("\(Int(doubleValue))")
                        }
                    }
                }
            }
        }
        .chartLegend(position: .bottom, alignment: .center)
        .frame(height: 260)
    }
}

// MARK: - Chart Content
@available(iOS 16.0, *)
private extension MetricLineChartView {

    // MARK: Metric Chart
    @ChartContentBuilder
    var metricContent: some ChartContent {
        
        if config.showRuleMark {
            RuleMark(y: .value("Average", average))
                .lineStyle(StrokeStyle(lineWidth: 1.5, dash: [6, 4]))
                .foregroundStyle(.gray.opacity(0.6))
        }
        
        ForEach(dataPoints) { point in
            LineMark(
                x: .value("X", point.xValue),
                y: .value("Y", point.yValue)
            )
            .interpolationMethod(.catmullRom)
            .foregroundStyle(config.accentColor)
            
            PointMark(
                x: .value("X", point.xValue),
                y: .value("Y", point.yValue)
            )
            .foregroundStyle(config.accentColor)
        }
    }

    // MARK: Section Chart
    @ChartContentBuilder
    var sectionContent: some ChartContent {
        
        ForEach(dataPoints) { point in
            
            if let item = point as? any LineChartProtocol.SectionChartDataPoint {
                
                LineMark(
                    x: .value("X", item.xValue),
                    y: .value("Y", item.yValue)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(by: .value("Section", item.section ?? ""))
                
                PointMark(
                    x: .value("X", item.xValue),
                    y: .value("Y", item.yValue)
                )
                .foregroundStyle(by: .value("Section", item.section ?? ""))
            }
        }
    }
}
// MARK: - Helpers
private extension View {
    @ViewBuilder
    func applySectionColors(_ colors: [String: Color]) -> some View {
        if colors.isEmpty {
            self
        } else {
            if #available(iOS 16.0, *) {
                let pairs = colors.map { ($0.key, $0.value) }
                
                self.chartForegroundStyleScale(
                    domain: pairs.map { $0.0 },
                    range: pairs.map { $0.1 }
                )
            } else {
                self
            }
        }
    }
}

@available(iOS 16.0, *)
#Preview {
    ScrollView {
        VStack(spacing: 20) {

            // MARK: - Metric Charts

            MetricLineChartView(
                config: .init(title: "Clarity", accentColor: .blue, yDomain: 0...7),
                dataPoints: [
                    LineChartDataModel.ClarityPoint(time: 0,  score: 0.0),
                    LineChartDataModel.ClarityPoint(time: 30, score: 6.8, feedback: "Good pacing"),
                    LineChartDataModel.ClarityPoint(time: 60, score: 6.6),
                    LineChartDataModel.ClarityPoint(time: 75, score: 6.6, feedback: "Consistent"),
                ]
            )
            
            MetricLineChartView(
                config: .init(title: "Clarity", accentColor: .purple, yDomain: 0...7, showRuleMark: false),
                dataPoints: [
                    LineChartDataModel.ClarityPoint(time: 0,  score: 0.9),
                    LineChartDataModel.ClarityPoint(time: 1, score: 0.1, feedback: "Good pacing"),
                    LineChartDataModel.ClarityPoint(time: 2, score: 0.5),
                    LineChartDataModel.ClarityPoint(time: 3, score: 0.4, feedback: "Consistent"),
                ]
            )

            MetricLineChartView(
                config: .init(title: "Confidence", accentColor: .green, yDomain: 0...10, unit: "/10"),
                dataPoints: [
                    LineChartDataModel.ConfidencePoint(time: 0,  score: 0.0),
                    LineChartDataModel.ConfidencePoint(time: 20, score: 5.0),
                    LineChartDataModel.ConfidencePoint(time: 45, score: 7.5, isKeyMoment: true),
                    LineChartDataModel.ConfidencePoint(time: 75, score: 8.0),
                ]
            )

            MetricLineChartView(
                config: .init(title: "Pace", accentColor: .orange, yDomain: 0...200, unit: " wpm", yStep: 50),
                dataPoints: [
                    LineChartDataModel.PacePoint(time: 0,  score: 0),
                    LineChartDataModel.PacePoint(time: 15, score: 120),
                    LineChartDataModel.PacePoint(time: 45, score: 160),
                    LineChartDataModel.PacePoint(time: 75, score: 145),
                ]
            )

           
        }
    }
    .background(Color(.systemGroupedBackground))
    .versionedContentMarginsPkg()
}


// MARK: - Section Chart
@available(iOS 16.0, *)
#Preview {
    VStack {
        MetricLineChartView(
            config: .init(
                title: "Section Progress",
                yDomain: 0...10, chartType: .sectionWise,
                sectionColors: [
                    "Beginning": .green,
                    "Middle": .purple,
                    "End": .orange
                ]
            ),
            dataPoints: [
                // Beginning
                LineChartDataModel.SectionPoint(xValue: 1, yValue: 5.4, section: "Beginning"),
                LineChartDataModel.SectionPoint(xValue: 2, yValue: 5.9, section: "Beginning"),
                LineChartDataModel.SectionPoint(xValue: 3, yValue: 5.6, section: "Beginning"),
                LineChartDataModel.SectionPoint(xValue: 4, yValue: 6.2, section: "Beginning"),
                
                // Middle
                LineChartDataModel.SectionPoint(xValue: 1, yValue: 5.5, section: "Middle"),
                LineChartDataModel.SectionPoint(xValue: 2, yValue: 6.2, section: "Middle"),
                LineChartDataModel.SectionPoint(xValue: 3, yValue: 5.0, section: "Middle"),
                LineChartDataModel.SectionPoint(xValue: 4, yValue: 6.6, section: "Middle"),
                
                // End
                LineChartDataModel.SectionPoint(xValue: 1, yValue: 6.8, section: "End"),
                LineChartDataModel.SectionPoint(xValue: 2, yValue: 5.1, section: "End"),
                LineChartDataModel.SectionPoint(xValue: 3, yValue: 6.0, section: "End"),
                LineChartDataModel.SectionPoint(xValue: 4, yValue: 6.6, section: "End"),
            ]
        )
    }
    .padding(.horizontal)
}
