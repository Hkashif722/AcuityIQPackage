//
//  MockSegmentItem.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 31/03/26.
//


// MARK: - Preview Support

struct MockSegmentItem: SegmentItemRepresentable {
    var id: String
    var menuTitle: String
    var selectedColor: Color
    var unSelectedColor: Color
}

// MARK: - Preview

#Preview {
    @Previewable @State var items: [MockSegmentItem] = [
        MockSegmentItem(
            id: "home",
            menuTitle: "Home",
            selectedColor: Color.blue.opacity(0.12),
            unSelectedColor: Color(.systemGray6)
        ),
        MockSegmentItem(
            id: "courses",
            menuTitle: "Courses",
            selectedColor: Color.blue.opacity(0.12),
            unSelectedColor: Color(.systemGray6)
        ),
        MockSegmentItem(
            id: "assessments",
            menuTitle: "Assessments",
            selectedColor: Color.blue.opacity(0.12),
            unSelectedColor: Color(.systemGray6)
        ),
        MockSegmentItem(
            id: "reports",
            menuTitle: "Reports",
            selectedColor: Color.blue.opacity(0.12),
            unSelectedColor: Color(.systemGray6)
        ),
    ]
    @Previewable @State var selectedID: String = "home"

    VStack(alignment: .leading, spacing: 0) {
        SegmentMenuView(
            items: $items,
            selectedID: $selectedID
        ) { selected in
            print("Selected: \(selected.menuTitle)")
        }

        // Simulated content area below the tabs
        RoundedRectangle(cornerRadius: 12)
            .fill(Color(.systemGray6))
            .frame(maxWidth: .infinity)
            .overlay(
                Text("Content for \"\(items.first(where: { $0.id == selectedID })?.menuTitle ?? "")\"")
                    .foregroundStyle(.secondary)
            )
            .padding()

        Spacer()
    }
    .padding(.top)
}