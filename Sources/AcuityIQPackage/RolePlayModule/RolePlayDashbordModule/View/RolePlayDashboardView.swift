//
//  RolePlayDashboardView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 28/04/26.
//

import SwiftUI
import SwiftfulRouting
import SwiftUIUtilities

struct RolePlayDashboardView: View {

    @StateObject private var vm: RolePlayDashboardViewModel


    init(router: AnyRouter, navModel: NavigationViewModel.RolePlayDashboardNavModel) {
        _vm = StateObject(
            wrappedValue: RolePlayDashboardViewModel(router: router, navModel: navModel)
        )
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // MARK: - Scenario Info Card
                VStack(alignment: .leading, spacing: 8) {
                    Text(vm.navModel.rolePlayTitle ?? "Role Play Session")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)

                    Text("A structured session where the candidate introduces a product or service, highlights its value, and engages the target audience to create interest or move toward a sale.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))

                // MARK: - Action Chips
                HStack(spacing: 12) {
                    
                    ChipButton(title: "Evaluation Criteria") { vm.didTapEvaluationCriteria() }
                    ChipButton(title: "Keywords") { vm.didTapKeywords() }
                    ChipButton(title: "View Attempts") { vm.didTapViewAttempts() }
                    
                }

                Spacer()

                // MARK: - Start Role Play Button
                Button {
                    vm.didSelectStartRolePlay()
                } label: {
                    Text("Start Role Play")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(Capsule())
                }
            }
            .padding()
        }
        .navigationTitle("Attempt left")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                RolePlayAttemptBadgeView(attempt: vm.navModel.attempt)
            }
        }
    }

    // MARK: - Helpers

    private var attemptText: String {
        guard let left = vm.navModel.attempt?.left, let total = vm.navModel.attempt?.total else {
            return ""
        }
        return "\(left) / \(total)"
    }
}

// MARK: - Attempt Badge

private struct RolePlayAttemptBadgeView: View {
    let attempt: (total: Int?, left: Int?)?

    var body: some View {
        if let left = attempt?.left, let total = attempt?.total {
            HStack(spacing: 4) {
                Image(systemName: "arrow.clockwise.circle")
                Text("\(left) / \(total)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.purple.opacity(0.15))
            .foregroundStyle(.purple)
            .clipShape(Capsule())
        }
    }
}

// MARK: - Chip Button

private struct ChipButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(.blue)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .overlay(
                    Capsule()
                        .stroke(Color.blue, lineWidth: 1.5)
                )
        }
    }
}

// MARK: - Preview

#Preview {
    RouterView { router in
        RolePlayDashboardView(
            router: router,
            navModel: NavigationViewModel.RolePlayDashboardNavModel(
                rolePlayTitle: "",
                projectID: 123,
                moduleStatus: "pending",
                attempt: (total: 50, left: 49),
                evaluationParameters: [["name": "Salesmanship", "percentage": "20"]],
                keywords: ["Training", "Sales", "Simulation"]
            )
        )
    }
}
