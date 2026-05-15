//
//  EvaluateModuleView.swift
//  AcuityIQPackage
//

import SwiftUI
import SwiftUIUtilities

struct EvaluateModuleView: View {

    @StateObject private var vm: EvaluateModuleViewModel

    init(router: AnyRouter, navModel: NavigationViewModel.EvaluateModuleNavModel) {
        _vm = StateObject(
            wrappedValue: EvaluateModuleViewModel(router: router, navModel: navModel)
        )
    }

    var body: some View {
        VStack(spacing: 0) {
            formScrollView
            submitBar
        }
        .navigationTitle("Evaluate")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    vm.goBack()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") { hideKeyboard() }
                    .font(.body.weight(.semibold))
                    .foregroundStyle(.blue)
            }
        }
        .loadingOverlayViewPkg(state: vm.loadingState)
        .toastViewPkg(toast: $vm.toast)
    }
}

// MARK: - Form Scroll
private extension EvaluateModuleView {

    var formScrollView: some View {
        ScrollView {
            VStack(spacing: 12) {
                parameterSection
                overallScoreSection
            }
        }
        .versionedContentMarginsPkg()
        .applyScrollBounceBehaviorPkg()
    }
}

// MARK: - Parameter Section
private extension EvaluateModuleView {

    var parameterSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionHeader(icon: "list.bullet.clipboard", title: "Evaluation Criteria")
            ForEach(vm.formEntries.indices, id: \.self) { index in
                EvaluateParameterRowView(entry: $vm.formEntries[index])
            }
        }
    }
}

// MARK: - Overall Score Section
private extension EvaluateModuleView {

    var overallScoreSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(icon: "star.fill", title: "Overall Score", iconColor: Color(hex: "#f59e0b"))
            overallScoreCard
        }
    }

    var overallScoreCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            TextField("Enter overall score (0–10)", text: $vm.overallScoreText)
                .keyboardType(.decimalPad)
                .font(.callout)
                .tint(.blue)
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(Color(.tertiarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(overallScoreBorderColor, lineWidth: 1.2)
                )
                .onChange(of: vm.overallScoreText) { newValue in
                    let filtered = EvaluateModuleViewModel.filterOneDecimalPlace(newValue)
                    if filtered != newValue { vm.overallScoreText = filtered }
                }

            Text("Score out of 10")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.leading, 4)
        }
        .padding(16)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    var overallScoreBorderColor: Color {
        if vm.overallScoreText.isEmpty {
            return Color(hex: "#ef4444").opacity(0.7)
        }
        if let score = Double(vm.overallScoreText), score >= 0, score <= 10 {
            return Color(hex: "#10b981").opacity(0.6)
        }
        return Color(hex: "#ef4444").opacity(0.7)
    }
}

// MARK: - Submit Bar
private extension EvaluateModuleView {

    var submitBar: some View {
        VStack(spacing: 0) {
            Divider()
            SwiftUIUtility
                .RectangularIconButton(
                    title: "Save",
                    font: .headline,
                    backgroundColor: Color(hex: "#5b6afa"),
                    foregroundColor: .white,
                    cornerRadius: 14,
                    height: 50,
                    action: vm.didTapSubmit
                )
                .disabledWithOpacityPkg(!vm.isFormComplete)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(.systemBackground))
        }
    }
}

// MARK: - Helpers
private extension EvaluateModuleView {

    func sectionHeader(icon: String, title: String, iconColor: Color = Color(hex: "#5b6afa")) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.headline.weight(.bold))
                .foregroundStyle(iconColor)
            Text(title)
                .font(.headline.weight(.bold))
                .foregroundStyle(.primary)
        }
        .padding(.leading, 4)
    }
}

#Preview {
    RouterView { router in
        EvaluateModuleView(
            router: router,
            navModel: .init(
                attempt: .init(
                    attemptId: 298,
                    attemptNumber: 1,
                    score: 7.5,
                    attemptDate: "17 Apr 2026",
                    attemptTime: "12:37 PM",
                    evaluationSubmitted: false,
                    overallScore: nil
                ),
                scenario: .preview()
            )
        )
    }
}
