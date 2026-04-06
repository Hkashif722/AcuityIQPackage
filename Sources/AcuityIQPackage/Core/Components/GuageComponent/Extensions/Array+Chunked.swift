//
//  Array+Chunked.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 31/03/26.
//

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}
