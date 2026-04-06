//
//  LineChartDataPoint.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 02/04/26.
//


public struct LineChartProtocol {
    
    // Base protocol
    public protocol ChartPlottable: Identifiable {
        var xValue: Double { get }
        var yValue: Double { get }
    }
    
    // Metric
    public protocol LineChartDataPoint: ChartPlottable {
        var xValue: Double { get }
        var yValue: Double { get }
    }
    
    // Section
    public protocol SectionChartDataPoint: LineChartDataPoint {
        var section: String? { get }
    }
}
