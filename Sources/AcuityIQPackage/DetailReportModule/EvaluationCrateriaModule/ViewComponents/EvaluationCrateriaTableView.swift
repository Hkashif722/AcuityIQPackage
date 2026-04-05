//
//  KeywordCoverageTableView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 02/04/26.
//


//
//  SwiftUIView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 01/04/26.
//

import SwiftUI

struct KeywordCoverageTableView: View {
    
    typealias KeywordCoverage = DetailReportDataModel.KeywordCoverage
    
    let keywordCoverageDataModel: [KeywordCoverage]
    
    var body: some View {
        VStack {
            tableHeaderView
            ScrollView {
                tableBodyView
            }
            .versionedContentMarginsPkg()
        }
    }
}

extension KeywordCoverageTableView {
    
    var tableHeaderView: some View {
        HStack {
            Text("Keyword")
            Spacer()
            Text("Status")
        }
        .font(.body.bold())
        .foregroundStyle(.primary)
        .padding()
        .background(.gray.opacity(0.2))
        .cornerRadiusPkg(4, corners: .allCorners)
    }
    
    
    private var tableBodyView: some View {
        LazyVStack {
            ForEach(Array(keywordCoverageDataModel.enumerated()), id: \.element.id) { index, keyword in
                keywordItemView(keyword)
                
                if index < keywordCoverageDataModel.count - 1 {
                    Divider()
                }
            }
        }
    }
    
    private func keywordItemView(_ item: KeywordCoverage) -> some View {
        HStack {
            Text(item.keyword)
            Spacer()
            Text(item.status?.rawValue ?? "")
                .foregroundStyle(item.status?.color ?? .brown)
                .padding(.init(top: 4, leading: 16, bottom: 4, trailing: 16))
                .background(item.status?.color.opacity(0.2) ?? .brown.opacity(0.2))
                .cornerRadiusPkg(16, corners: .allCorners)
        }
    }
}

#Preview {
    KeywordCoverageTableView(
        keywordCoverageDataModel: DetailReportDataModel.ScenarioAttemptResponse.preview.keywordCoverage ?? []
    )
}
