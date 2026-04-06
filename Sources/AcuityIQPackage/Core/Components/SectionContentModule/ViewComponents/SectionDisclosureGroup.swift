//
//  SectionDisclosureGroup.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 03/04/26.
//

import SwiftUI
import SwiftUIUtilities

struct SectionDisclosureGroup<Content: View>: View {
    
  
    let sectionTitle: String
    let sectionStatus: String
    let tagColor: Color
    @ViewBuilder var content: Content
    
    @State private var isExpanded = false
    
    var body: some View {
        VStack(spacing: 0) {
            headerView
            
            if isExpanded {
                VStack {
                    content
                }
                .padding(8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.lightGray).opacity(0.1))
                .cornerRadiusPkg(10, corners: [.bottomLeft, .bottomRight])
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text(sectionTitle)
                .font(.subheadline.bold())
                
            Spacer()
            
            HStack(spacing: 8) {
                statusTagView
                cheveronIcon
            }
        }
        .padding(12)
        .background(tagColor.opacity(0.1))
        .cornerRadiusPkg(10, corners: [.topLeft, .topRight])
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.2)) {
                isExpanded.toggle()
            }
        }
        
    }
    
    private var statusTagView: some View {
        Text("Stagnant")
            .font(.caption)
            .foregroundStyle(tagColor)
            .padding(.init(top: 4, leading: 8, bottom: 4, trailing: 8))
            .background(tagColor.opacity(0.01))
            .clipShape(Capsule())
            .overlay {
                Capsule().stroke(tagColor, lineWidth: 1)
            }
    }
    
    private var cheveronIcon: some View {
        Image(systemName: "chevron.right")
            .font(.subheadline.bold())
            .foregroundStyle(.gray)
            .rotationEffect(.degrees(isExpanded ? 90 : 0))
            .animation(.easeInOut(duration: 0.2), value: isExpanded)
    }
}

#Preview {
    SectionDisclosureGroup(
        sectionTitle: "Clarity",
        sectionStatus: "Consistent",
        tagColor: .green
    ) {
        Text(
            "Detailed insights go here..."
        )
        .font(.subheadline)
        .foregroundStyle(.secondary)
    }
    .padding(
            .horizontal
        )
}
