//
//  ExampleView.swift
//  SpiderChart
//
//  Created on 22/01/2026.
//

import SwiftUI

// MARK: - Simple Example

struct SimpleExample: View {
    
    @State private var dataSets = [
        SpiderChartDataModel.ChartDataSet(
            label: "Expected",
            values: [3.0, 4.5, 5.0, 5.5, 5.5, 5.5, 4.5, 3.5, 3.5],
            color: UIColor(red: 239/255, green: 83/255, blue: 80/255, alpha: 1)
        ),
        SpiderChartDataModel.ChartDataSet(
            label: "Current",
            values: [4.5, 2.5, 3.5, 5.0, 5.5, 3.5, 3.5, 2.5, 4.0],
            color: UIColor(red: 66/255, green: 165/255, blue: 245/255, alpha: 1)
        )
    ]
    
    var body: some View {
        VStack(spacing: 20) {
           
            
            SpiderChartLegends(
                items: dataSets.map {
                    SpiderChartLegends.LegendItem(label: $0.label, color: $0.color, isVisible: $0.isVisible)
                },
                onTap: { index in
                    dataSets[index].isVisible.toggle()
                }
            )
            
            SpiderChartViewRepresentable(
                dataSets: dataSets,
                config: SpiderChartDataModel.ChartConfig(
                    labels: [
                        "Adaptability",
                        "Attention to Detail",
                        "Communication",
                        "Job Knowledge",
                        "Learning",
                        "Problem Solving",
                        "Teamwork",
                        "Technology",
                        "Time Management"
                    ],
                    showValues: false,        // Data point values
                    showYAxisLabels: true,    // Y-axis scale labels
                    yAxisLabelCount: 6 ,       // Number of Y-axis labels
                    showLegend: false
                )
            )
            .frame(height: 480)
            .padding()
        }
    }
}


// MARK: - Previews

#Preview("Simple") {
    SimpleExample()
}
