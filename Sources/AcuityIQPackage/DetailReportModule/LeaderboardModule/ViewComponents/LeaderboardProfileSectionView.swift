//
//  SwiftUIView.swift
//  AcuityIQPackage
//
//  Created by Kashif Hussain on 05/04/26.
//

import SwiftUI
import SwiftUIUtilities

struct SwiftUIView: View {
    
    var body: some View {
        HStack {
           
            userInfoView
            
            Spacer()
            
            badgeView
            
        }
    }
    
    private var profileImageView: some View {
        AsyncImageWithFallback(urlString: "", defaultImageName: "default_avatar", bundle: .module)
            .aspectRatio(1, contentMode: .fit)
            .frame(width: 45)
            .clipShape(Circle())
            .overlay {
                Circle().stroke(.gray.opacity(0.5), lineWidth: 1)
            }
        
    }
    
    private var userInfoView: some View {
        VStack(alignment: .leading) {
            Text("Ravi Sharma")
                .font(.headline.bold())
                .foregroundStyle(.primary)
            
            Text("Score: 1.5")
                .foregroundStyle(.secondary)
        }
    }
    
    private var badgeView: some View {
        HStack {
            
            Image(systemName: "flame")
                .foregroundStyle(Color(hex: "E24B4A"))
                .padding(10)
                .background(Color(hex: "FCEBEB"))
                .clipShape(Circle())
            
            
            Image(systemName: "shield")
                .foregroundStyle(Color(hex: "D85A30"))
                .padding(10)
                .background(Color(hex: "FAECE7"))
                .clipShape(Circle())
        }
    }
}

#Preview {
    SwiftUIView()
}
