//
//  EvaluationCrateriaTableView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 02/04/26.
//


import SwiftUI

struct EvaluationCrateriaTableView: View {
    
    typealias EvaluationCriteria = DetailReportDataModel.EvaluationCriteria
    
    let evaluationCriteriaModel: [EvaluationCriteria]
    
    var body: some View {
        VStack {
            tableHeaderView
//            ScrollView {
                tableBodyView
//            }
//            .versionedContentMarginsPkg()
        }
    }
}

extension EvaluationCrateriaTableView {
    
    var tableHeaderView: some View {
        HStack {
            Text("Keyword")
                .frame(width: 100, alignment: .leading)
            Spacer()
            Text("Remarks")
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("Score")
                .frame(width: 50, alignment: .leading)
        }
        .font(.body.bold())
        .foregroundStyle(.primary)
        .padding()
        .background(.gray.opacity(0.1))
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(.gray.opacity(0.3), lineWidth: 1)
        }
        .cornerRadiusPkg(4, corners: .allCorners)
    }
    
    
    private var tableBodyView: some View {
        List {
            ForEach(evaluationCriteriaModel) { keyword in
                keywordItemView(keyword)
            }
        }
        .listStyle(.plain)
    }
    
    private func keywordItemView(_ item: EvaluationCriteria) -> some View {
        HStack(alignment: .top) {
            Text(item.parameter)
                .font(.callout)
                .frame(width: 70, alignment: .leading)
                .minimumScaleFactor(0.7)
            
            Spacer()
            
            Text(item.remarks ?? "")
                .font(.callout)
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .minimumScaleFactor(0.7)
            Spacer()
            Text(String(format: "%.1f", item.score ?? 0.0))
                .font(.callout)
                .frame(width: 40)
                .padding(.init(top: 4, leading: 8, bottom: 4, trailing: 8))
                .foregroundStyle(.white)
                .background(Color.blue)
                .cornerRadiusPkg(12, corners: .allCorners)
                .minimumScaleFactor(0.7)
        }
    }
}

#Preview {
    EvaluationCrateriaTableView(
        evaluationCriteriaModel: DetailReportDataModel.ScenarioAttemptResponse.preview.evaluationCriteria ?? []
    )
}
