//
//  ManagerEvaluationViewModel.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 13/04/26.
//

import Foundation
import SwiftUIUtilities
import SwiftfulRouting

class ManagerEvaluationViewModel: RoutableViewModel {

    let navModel:  NavigationViewModel.ManagerEvaluationNavModel

    init(router: AnyRouter, navModel: NavigationViewModel.ManagerEvaluationNavModel) {
        self.navModel = navModel
        super.init(router: router)
    }
}

// MARK: - Handle Actions
extension ManagerEvaluationViewModel {

}
