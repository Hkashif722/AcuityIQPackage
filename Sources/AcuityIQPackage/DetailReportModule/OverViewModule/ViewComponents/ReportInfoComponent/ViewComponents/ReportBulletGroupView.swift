//
//  ReportBulletGroupView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 01/04/26.
//


import SwiftUI

struct ReportBulletGroupView: View {

    let icon: String
    var iconColor: Color = .accentColor 
    let title: String
    let bullets: [String]
    var bulletColor: Color = .accentColor

    var body: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 6) {
                ForEach(bullets, id: \.self) { bullet in
                    HStack(alignment: .top, spacing: 8) {
                        Circle()
                            .fill(bulletColor)
                            .frame(width: 6, height: 6)
                            .padding(.top, 5)
                        Text(bullet)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 4)
        } label: {
            Label {
                Text(title)
            } icon: {
                Image(systemName: icon)
                    .foregroundStyle(iconColor)   // ← applied here
            }
            .font(.headline)
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        ReportBulletGroupView(
            icon: "checklist",
            iconColor: .green,
            title: "Key Highlights",
            bullets: [
                "Completed 12 modules this month",
                "Assessment pass rate improved by 18%",
                "3 certifications awarded"
            ]
        )

        ReportBulletGroupView(
            icon: "exclamationmark.triangle.fill",
            iconColor: .orange,
            title: "Action Items",
            bullets: [
                "2 learners have not started mandatory training",
                "Renewal due for LTFS compliance course"
            ],
            bulletColor: .orange
        )
    }
    .padding()
}
