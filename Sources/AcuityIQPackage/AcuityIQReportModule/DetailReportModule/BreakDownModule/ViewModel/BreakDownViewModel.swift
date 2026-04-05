//
//  BreakDownViewModel.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 01/04/26.
//

import Foundation
import SwiftUIUtilities
import SwiftfulRouting

class BreakDownViewModel: RoutableViewModel {

    
    let scenarioAttemptResponseModel: DetailReportDataModel.ScenarioAttemptResponse = .preview
    
    //MARK: Computed Properties
    var chartModel: SpiderChartDataModel.ViewModel {
        scenarioAttemptResponseModel.sectionSpiderChartViewModel()
    }
    
    var getEvaluationSectionModel: [DetailReportDataModel.SectionEvaluation] {
        scenarioAttemptResponseModel.sections ?? []
    }
    
    var getHeaderTitle: String {
        scenarioAttemptResponseModel.breakDownModuleTitle
    }
    
    var legendsSpiderChartValue: [(String, Double)] {
       Array(zip(chartModel.labels, chartModel.dataSets.first?.values ?? []))
   }
    
    init(router: AnyRouter) {
        super.init(router: router)
    }
}

//MARK: Handle Action
extension BreakDownViewModel {
    
}

