//
//  MockSegmentItem.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 31/03/26.
//

import SwiftUI

// MARK: - Mock Item for Previews
struct MockSegmentItem: SegmentItemRepresentable {
    let id: String
    let menuTitle: String
    let icon: SegmentIconType
    let selectedColor: Color
    let unSelectedColor: Color
    
    // MARK: - CaseIterable Conformance
    static var allCases: [MockSegmentItem] {
        [
            .init(id: "home",        menuTitle: "Home",        icon: .system(name: "house.fill"),          selectedColor: .blue.opacity(0.12), unSelectedColor: Color(.systemGray6)),
            .init(id: "courses",     menuTitle: "Courses",     icon: .system(name: "book.fill"),           selectedColor: .blue.opacity(0.12), unSelectedColor: Color(.systemGray6)),
            .init(id: "assessments", menuTitle: "Assessments", icon: .system(name: "checklist"),           selectedColor: .blue.opacity(0.12), unSelectedColor: Color(.systemGray6)),
            .init(id: "reports",     menuTitle: "Reports",     icon: .system(name: "chart.bar.fill"),      selectedColor: .blue.opacity(0.12), unSelectedColor: Color(.systemGray6)),
            .init(id: "leaderboard", menuTitle: "Leaderboard", icon: .system(name: "trophy.fill"),         selectedColor: .blue.opacity(0.12), unSelectedColor: Color(.systemGray6)),
        ]
    }
}

// MARK: - Equatable Conformance
extension MockSegmentItem: Equatable {
    static func == (lhs: MockSegmentItem, rhs: MockSegmentItem) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Hashable Conformance
extension MockSegmentItem: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Preview Wrapper View (to manage state)
private struct SegmentMenuPreview: View {
    @State private var selectedTitle: String = "Home"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            SegmentMenuView(items: MockSegmentItem.allCases) { selected in
                selectedTitle = selected.menuTitle
            }
            
            // Simulated content area
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
                .frame(maxWidth: .infinity)
                .frame(height: 200)
                .overlay(
                    Text("Content for \"\(selectedTitle)\"")
                        .foregroundStyle(.secondary)
                )
                .padding()
            
            Spacer()
        }
        .padding(.top)
    }
}

// MARK: - Preview
@available(iOS 17.0, *)
#Preview {
    SegmentMenuPreview()
}

// Optional: Static preview without state interaction
@available(iOS 17.0, *)
#Preview("Static") {
    let items: [MockSegmentItem] = [
        .init(id: "home", menuTitle: "Home", icon: .system(name: "house.fill"), selectedColor: .blue.opacity(0.12), unSelectedColor: Color(.systemGray6)),
        .init(id: "courses", menuTitle: "Courses", icon: .system(name: "book.fill"), selectedColor: .blue.opacity(0.12), unSelectedColor: Color(.systemGray6)),
    ]
    
    return VStack {
        SegmentMenuView(items: items) { _ in }
        Spacer()
    }
    .padding()
}
