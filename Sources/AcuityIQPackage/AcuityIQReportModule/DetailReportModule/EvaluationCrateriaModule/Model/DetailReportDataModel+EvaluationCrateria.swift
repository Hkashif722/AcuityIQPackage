
//
//  EvaluationCriteriaFilterModel.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 02/04/26.
//


import Foundation
import SwiftUIUtilities

extension DetailReportDataModel.ScenarioAttemptResponse {

    // MARK: - Sort Option

    enum EvaluationCriteriaSortOption: Int, CaseIterable, Identifiable {
        case scoreHighToLow
        case scoreLowToHigh
        case parameterAToZ
        case parameterZToA

        var id: Int { rawValue }

        var title: String {
            switch self {
            case .scoreHighToLow:  return "Score (High → Low)"
            case .scoreLowToHigh: return "Score (Low → High)"
            case .parameterAToZ:  return "Parameter (A → Z)"
            case .parameterZToA:  return "Parameter (Z → A)"
            }
        }

        func sort(
            _ criteria: [DetailReportDataModel.EvaluationCriteria]
        ) -> [DetailReportDataModel.EvaluationCriteria] {
            switch self {
            case .scoreHighToLow:  return criteria.sorted { ($0.score ?? 0) > ($1.score ?? 0) }
            case .scoreLowToHigh: return criteria.sorted { ($0.score ?? 0) < ($1.score ?? 0) }
            case .parameterAToZ:  return criteria.sorted { $0.parameter < $1.parameter }
            case .parameterZToA:  return criteria.sorted { $0.parameter > $1.parameter }
            }
        }
    }

    // MARK: - Dropdown Model

    struct EvaluationCriteriaFilterModel: Identifiable, DropDownMenuProtocolPkg {
        let id: Int
        let sortOption: EvaluationCriteriaSortOption

        var description: String { sortOption.title }

        static var allOptions: [EvaluationCriteriaFilterModel] {
            EvaluationCriteriaSortOption.allCases.map {
                EvaluationCriteriaFilterModel(id: $0.id, sortOption: $0)
            }
        }
    }
}
