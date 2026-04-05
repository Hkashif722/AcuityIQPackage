//
//  ClarityPoint.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 02/04/26.
//


import Foundation

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
}