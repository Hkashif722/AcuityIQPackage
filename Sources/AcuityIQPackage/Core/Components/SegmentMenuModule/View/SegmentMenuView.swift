//
//  SwiftUIView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 31/03/26.
//

import SwiftUI
import SwiftUIUtilities

// MARK: - Component

struct SegmentMenuView<Item: SegmentItemRepresentable>: View {

    let items: [Item]
    var onSelect: ((Item) -> Void)?

    @State private var selectedID: Item.ID

    init(items: [Item], onSelect: ((Item) -> Void)? = nil) {
        self.items = items
        self.onSelect = onSelect
        _selectedID = State(initialValue: items[0].id)
    }

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(items) { item in
                        menuButton(for: item)
                            .id(item.id)
                            .onTapGesture { select(item, proxy: proxy) }
                    }
                }
            }
            .versionedHorizontalContentMarginsPkg()
            .onChange(of: selectedID) { newID in
                withAnimation(.easeInOut(duration: 0.3)) {
                    proxy.scrollTo(newID, anchor: .center)
                }
            }
        }
    }

    private func menuButton(for item: Item) -> some View {
        let isSelected = item.id == selectedID
        return HStack(spacing: 6) {
            iconView(for: item.icon, isSelected: isSelected)
            Text(item.menuTitle)
                .foregroundStyle(isSelected ? ColorUtility.primaryColor : Color(.label))
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(isSelected ? item.selectedColor : item.unSelectedColor)
        .clipShape(CustomViewModifier.RoundedCorner(radius: 15, corners: [.topLeft, .topRight]))
        .overlay(
            CustomViewModifier.RoundedCorner(radius: 15, corners: [.topLeft, .topRight])
                .stroke(Color(.lightGray), lineWidth: 0.5)
        )
    }

    @ViewBuilder
    private func iconView(for icon: SegmentIconType, isSelected: Bool) -> some View {
        switch icon {
        case .system(let name):
            Image(systemName: name)
                .foregroundStyle(isSelected ? ColorUtility.primaryColor : Color(.secondaryLabel))
        case .bundle(let name, let bundle):
            Image(name, bundle: bundle)
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
        }
    }

    private func select(_ item: Item, proxy: ScrollViewProxy) {
        selectedID = item.id
        withAnimation(.easeInOut(duration: 0.3)) {
            proxy.scrollTo(item.id, anchor: .center)
        }
        onSelect?(item)
    }
}
