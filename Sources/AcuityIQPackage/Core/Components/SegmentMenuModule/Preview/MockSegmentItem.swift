//
//  MockSegmentItem.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 31/03/26.
//

import SwiftUI

// MARK: - Preview Support

struct MockSegmentItem: SegmentItemRepresentable {
    var id: String
    var menuTitle: String
    var icon: SegmentIconType
    var selectedColor: Color
    var unSelectedColor: Color
}

// MARK: - Preview

@available(iOS 17.0, *)
#Preview {
    @Previewable @State var selectedTitle: String = "Home"

    let items: [MockSegmentItem] = [
        MockSegmentItem(id: "home",        menuTitle: "Home",        icon: .system(name: "house.fill"),          selectedColor: .blue.opacity(0.12), unSelectedColor: Color(.systemGray6)),
        MockSegmentItem(id: "courses",     menuTitle: "Courses",     icon: .system(name: "book.fill"),           selectedColor: .blue.opacity(0.12), unSelectedColor: Color(.systemGray6)),
        MockSegmentItem(id: "assessments", menuTitle: "Assessments", icon: .system(name: "checklist"),           selectedColor: .blue.opacity(0.12), unSelectedColor: Color(.systemGray6)),
        MockSegmentItem(id: "reports",     menuTitle: "Reports",     icon: .system(name: "chart.bar.fill"),      selectedColor: .blue.opacity(0.12), unSelectedColor: Color(.systemGray6)),
        MockSegmentItem(id: "leaderboard", menuTitle: "Leaderboard", icon: .system(name: "trophy.fill"),         selectedColor: .blue.opacity(0.12), unSelectedColor: Color(.systemGray6)),
    ]

    VStack(alignment: .leading, spacing: 0) {
        SegmentMenuView(items: items) { selected in
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
