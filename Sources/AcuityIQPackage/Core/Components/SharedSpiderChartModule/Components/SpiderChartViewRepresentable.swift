//
//  SpiderChartViewRepresentable.swift
//  Ujjivan
//
//  Created on 22/01/2026.
//

import SwiftUI
import DGCharts

struct SpiderChartViewRepresentable: UIViewRepresentable {
    
    let dataSets: [SpiderChartDataModel.ChartDataSet]
    let config: SpiderChartDataModel.ChartConfig
    let onLegendTap: ((Int) -> Void)?
    
    init(
        dataSets: [SpiderChartDataModel.ChartDataSet],
        config: SpiderChartDataModel.ChartConfig,
        onLegendTap: ((Int) -> Void)? = nil
    ) {
        self.dataSets = dataSets
        self.config = config
        self.onLegendTap = onLegendTap
    }
    
    func makeUIView(context: Context) -> RadarChartView {
        let chart = RadarChartView()
        chart.delegate = context.coordinator
        setupChart(chart)
        return chart
    }
    
    func updateUIView(_ uiView: RadarChartView, context: Context) {
        updateData(uiView)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(labels: config.labels, enableLegendTap: config.enableLegendTap, onLegendTap: onLegendTap)
    }
    
    // MARK: - Setup
    
    private func setupChart(_ chart: RadarChartView) {
        chart.chartDescription.enabled = false
        chart.webLineWidth = 1
        chart.innerWebLineWidth = 1
        chart.webColor = .lightGray
        chart.innerWebColor = .lightGray
        chart.rotationEnabled = config.enableRotation
        
        // X-Axis
        chart.xAxis.labelFont = .systemFont(ofSize: 8, weight: .regular)
        chart.xAxis.labelTextColor = .label
        
        // Y-Axis
        chart.yAxis.labelFont = .systemFont(ofSize: 11, weight: .medium)
        chart.yAxis.labelTextColor = .label
        chart.yAxis.axisMinimum = 1
        chart.yAxis.axisMaximum = config.maxValue
        chart.yAxis.labelCount = config.yAxisLabelCount
        chart.yAxis.drawLabelsEnabled = config.showYAxisLabels
        chart.xAxis.drawLabelsEnabled = config.showXAxisLabels
//        chart.yAxis.valueFormatter = YAxisValueFormatter()
        
        // Set granularity for proportional spacing
        chart.yAxis.granularityEnabled = true
        chart.yAxis.granularity = (config.maxValue - 1) / Double(config.yAxisLabelCount - 1)
        chart.yAxis.forceLabelsEnabled = true
        
        // Legend
        chart.legend.enabled = config.showLegend
        chart.legend.horizontalAlignment = .center
        chart.legend.verticalAlignment = .top
        chart.legend.font = .systemFont(ofSize: 11, weight: .medium)
        chart.legend.textColor = .label
    }
    
    private func updateData(_ chart: RadarChartView) {
        var chartDataSets: [RadarChartDataSet] = []
        
        for dataSet in dataSets {
            let entries = dataSet.values.map { RadarChartDataEntry(value: $0) }
            let chartDataSet = RadarChartDataSet(entries: entries, label: dataSet.label)
            
            chartDataSet.setColor(dataSet.color)
            chartDataSet.fillColor = dataSet.color
            chartDataSet.drawFilledEnabled = true
            chartDataSet.fillAlpha = 0.7
            chartDataSet.lineWidth = 2
            chartDataSet.visible = dataSet.isVisible
            
            // Value styling
            chartDataSet.valueFont = .systemFont(ofSize: 10, weight: .medium)
            chartDataSet.valueTextColor = dataSet.color
            
            chartDataSets.append(chartDataSet)
        }
        
        let data = RadarChartData(dataSets: chartDataSets)
        data.setDrawValues(config.showValues)
        data.setValueFont(.systemFont(ofSize: 10, weight: .medium))
        
        chart.data = data
        chart.xAxis.valueFormatter = makeCoordinator()
        chart.animate(xAxisDuration: 1.4, yAxisDuration: 1.4, easingOption: .easeOutBack)
    }
    
    // MARK: - Coordinator
    
    class Coordinator: NSObject, AxisValueFormatter, ChartViewDelegate {
        let labels: [String]
        let enableLegendTap: Bool
        let onLegendTap: ((Int) -> Void)?
        
        init(labels: [String], enableLegendTap: Bool, onLegendTap: ((Int) -> Void)?) {
            self.labels = labels
            self.enableLegendTap = enableLegendTap
            self.onLegendTap = onLegendTap
        }
        
        func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            let index = Int(value) % labels.count
            return labels[index]
        }
        
        @MainActor
        func chartView(_ chartView: ChartViewBase, didSelectLegendEntry legend: LegendEntry) {
            guard enableLegendTap,
                  let chart = chartView as? RadarChartView,
                  let data = chart.data,
                  let index = data.dataSets.firstIndex(where: { $0.label == legend.label }) else {
                return
            }
            
            data.dataSets[index].visible.toggle()
            data.notifyDataChanged()
            chart.notifyDataSetChanged()
            onLegendTap?(index)
        }
    }
    
    // MARK: - Y-Axis Formatter
    
    class YAxisValueFormatter: NSObject, AxisValueFormatter {
        func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            // Format without decimals if it's a whole number
            if value.truncatingRemainder(dividingBy: 1) == 0 {
                return String(format: "%.0f", value)
            } else {
                return String(format: "%.1f", value)
            }
        }
    }
}
