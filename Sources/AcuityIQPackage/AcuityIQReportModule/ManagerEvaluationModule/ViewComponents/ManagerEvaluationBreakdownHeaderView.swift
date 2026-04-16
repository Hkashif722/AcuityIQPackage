//
//  ManagerEvaluationBreakdownHeaderView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 13/04/26.
//


//
//  ManagerEvaluationBreakdownHeaderView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 13/04/26.
//

import SwiftUI

struct ManagerEvaluationBreakdownHeaderView: View {

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "list.bullet")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.primary)
            Text("Parameter Breakdown")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.primary)
            Spacer()
        }
    }
}

#Preview {
    ManagerEvaluationBreakdownHeaderView()
        .padding()
}
