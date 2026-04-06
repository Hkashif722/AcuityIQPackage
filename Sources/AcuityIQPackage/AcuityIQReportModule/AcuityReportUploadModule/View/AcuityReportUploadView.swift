//
//  AcuityReportUploadView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 05/04/26.
//

import SwiftUI
import SwiftUIUtilities

public struct AcuityReportUploadView: View {

    private let router: AnyRouter
    private let scenarioId: Int

    public init(router: AnyRouter, scenarioId: Int) {
        self.router = router
        self.scenarioId = scenarioId
    }

    public var body: some View {
        VStack {
            Text("Upload Report")
                .font(.title)
            Text("Scenario ID: \(scenarioId)")
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    RouterView { router in
        AcuityReportUploadView(router: router, scenarioId: 1)
    }
}
