//
//  LineChartDataModel.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 02/04/26.
//

import Foundation

// MARK: - Namespace
public struct LineChartDataModel {
    
    typealias LineChartDataPoint = LineChartProtocol.LineChartDataPoint
    
    private init() {}

    // MARK: - Base Point
    public struct LineChartPoint: LineChartDataPoint {
        public let id = UUID()
        public let xValue: Double
        public let yValue: Double
        public let feedback: String?

        public init(xValue: Double, yValue: Double, feedback: String? = nil) {
            self.xValue = xValue
            self.yValue = yValue
            self.feedback = feedback
        }
    }

    // MARK: - ClarityPoint
    public struct ClarityPoint: LineChartDataPoint {
        public let id = UUID()
        public let time: Double
        public let score: Double
        public let feedback: String?

        public init(time: Double, score: Double, feedback: String? = nil) {
            self.time = time
            self.score = score
            self.feedback = feedback
        }
        
        public var xValue: Double { time }
        public var yValue: Double { score }
    }

    // MARK: - ConfidencePoint
    public struct ConfidencePoint: LineChartDataPoint {
        public let id = UUID()
        public let time: Double
        public let score: Double
        public let isKeyMoment: Bool

        public init(time: Double, score: Double, isKeyMoment: Bool = false) {
            self.time = time
            self.score = score
            self.isKeyMoment = isKeyMoment
        }
        
        public var xValue: Double { time }
        public var yValue: Double { score }
    }

    // MARK: - PacePoint
    public struct PacePoint: LineChartDataPoint {
        public let id = UUID()
        public let time: Double
        public let score: Double

        public init(time: Double, score: Double) {
            self.time = time
            self.score = score
        }
        
        public var xValue: Double { time }
        public var yValue: Double { score }
    }
}
extension LineChartDataModel {
    
    public struct SectionPoint: LineChartProtocol.SectionChartDataPoint {
        
        public let id = UUID()
        public let xValue: Double
        public let yValue: Double
        public let section: String?
        
        public init(xValue: Double, yValue: Double, section: String?) {
            self.xValue = xValue
            self.yValue = yValue
            self.section = section
        }
    }
}
