//
//  SearchTextField.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 05/04/26.
//


//
//  SearchTextField.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 05/04/26.
//

import SwiftUI

/// A reusable, customizable search text field with capsule styling
public struct SearchTextField: View {
    
    // MARK: - Properties
    
    @Binding private var text: String
    private let displayText: String?  // For read-only mode when no binding provided
    private let isEditable: Bool
    
    private let placeholder: String
    private let onChange: ((String) -> Void)?
    private let onCommit: (() -> Void)?
    private let font: Font
    private let textColor: Color
    private let placeholderColor: Color
    private let borderColor: Color
    private let borderWidth: CGFloat
    private let backgroundColor: Color?
    private let height: CGFloat
    private let horizontalPadding: CGFloat
    private let leadingIcon: String?
    private let trailingIcon: String?
    private let showsClearButton: Bool
    
    // MARK: - Initializers
    
    /// Editable mode: requires a Binding<String> for two-way data flow
    public init(
        text: Binding<String>,
        placeholder: String = "Search...",
        onChange: ((String) -> Void)? = nil,
        onCommit: (() -> Void)? = nil,
        font: Font = .caption,
        textColor: Color = .primary,
        placeholderColor: Color = .gray.opacity(0.7),
        borderColor: Color = .blue,
        borderWidth: CGFloat = 1,
        backgroundColor: Color? = nil,
        height: CGFloat = 40,
        horizontalPadding: CGFloat = 12,
        leadingIcon: String? = "magnifyingglass",
        trailingIcon: String? = nil,
        showsClearButton: Bool = true
    ) {
        self._text = text
        self.displayText = nil
        self.isEditable = true
        self.placeholder = placeholder
        self.onChange = onChange
        self.onCommit = onCommit
        self.font = font
        self.textColor = textColor
        self.placeholderColor = placeholderColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.backgroundColor = backgroundColor
        self.height = height
        self.horizontalPadding = horizontalPadding
        self.leadingIcon = leadingIcon
        self.trailingIcon = trailingIcon
        self.showsClearButton = showsClearButton
    }
    
    /// Read-only/Display mode: accepts a plain String, no binding required
    public init(
        text: String,
        placeholder: String = "Search...",
        font: Font = .caption,
        textColor: Color = .primary,
        placeholderColor: Color = .gray.opacity(0.7),
        borderColor: Color = .blue,
        borderWidth: CGFloat = 1,
        backgroundColor: Color? = nil,
        height: CGFloat = 40,
        horizontalPadding: CGFloat = 12,
        leadingIcon: String? = "magnifyingglass",
        trailingIcon: String? = nil
    ) {
        self._text = .constant(text)  // Dummy binding for read-only
        self.displayText = text
        self.isEditable = false
        self.placeholder = placeholder
        self.onChange = nil
        self.onCommit = nil
        self.font = font
        self.textColor = textColor
        self.placeholderColor = placeholderColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.backgroundColor = backgroundColor
        self.height = height
        self.horizontalPadding = horizontalPadding
        self.leadingIcon = leadingIcon
        self.trailingIcon = trailingIcon
        self.showsClearButton = false  // No clear button in read-only mode
    }
    
    // MARK: - Body
    
    public var body: some View {
        HStack(spacing: 8) {
            // Leading Icon
            if let iconName = leadingIcon {
                Image(systemName: iconName)
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .frame(width: 16)
            }
            
            // TextField or Text (based on editable mode)
            if isEditable {
                TextField(placeholder, text: $text)
                    .onChange(of: text) { newValue in
                        onChange?(newValue)
                    }
                    .onSubmit {
                        onCommit?()
                    }
                    .font(font)
                    .foregroundStyle(textColor)
                    // ✅ Remove the .placeholder() modifier
                    .minimumScaleFactor(0.7)
            }else {
                Text(displayText ?? placeholder)
                    .font(font)
                    .foregroundStyle(textColor.opacity(0.6))  // Dimmed for read-only
                    .minimumScaleFactor(0.7)
            }
            
            // Clear Button (only in editable mode)
            if isEditable && showsClearButton && !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
                .buttonStyle(.plain)
            }
            
            // Trailing Icon
            if let iconName = trailingIcon {
                Image(systemName: iconName)
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .frame(width: 16)
            }
        }
        .padding(.horizontal, horizontalPadding)
        .frame(height: height)
        .background {
            backgroundView
        }
        .clipShape(Capsule())
        .contentShape(Capsule())
        // Disable interaction in read-only mode
        .allowsHitTesting(isEditable)
    }
    
    // MARK: - Background View
    
    @ViewBuilder
    private var backgroundView: some View {
        if let bgColor = backgroundColor {
            Capsule().fill(bgColor)
                .overlay {
                    Capsule().stroke(borderColor, lineWidth: borderWidth)
                }
        } else {
            Capsule().stroke(borderColor, lineWidth: borderWidth)
        }
    }
}

// MARK: - Placeholder Modifier
extension View {
    @ViewBuilder
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

// MARK: - Preview
@available(iOS 17.0, *)
#Preview {
    @Previewable @State var editableText = ""
    
    VStack(spacing: 16) {
        // Editable with binding - ✅ Explicitly cast the binding
        SearchTextField(
            text: $editableText as Binding<String>,
            placeholder: "Search Parameters...",
            borderColor: .blue
        )
        
        // Read-only display mode (no binding)
        SearchTextField(
            text: "Pre-filled search term",
            placeholder: "Search...",
            borderColor: .gray,
            backgroundColor: .gray.opacity(0.1)
        )
        
        // Custom styled editable
        SearchTextField(
            text: $editableText as Binding<String>,
            placeholder: "Custom Search",
            textColor: .indigo,
            borderColor: .indigo,
            backgroundColor: .indigo.opacity(0.1),
            height: 44
        )
    }
    .padding()
}
