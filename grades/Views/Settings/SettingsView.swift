//
//  SettingsView.swift
//  grades
//
//  Created by Mayank Tiku on 1/16/25.
//


import SwiftUI
import Shake

struct SettingsView: View {
    @Binding var showSignInView: Bool
    @State private var deleteAcc: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.primaryCol.ignoresSafeArea()
                
                VStack(spacing: 24) {
                    VStack(spacing: 16) {
                        Button {
                            try? authManager.shared.signOut()
                            coursesManager.shared.removeListener()
                            showSignInView = true
                        } label: {
                            SettingsButtonView(
                                title: "Sign Out",
                                icon: "rectangle.portrait.and.arrow.right"
                            )
                        }
                        
                        Button {
                            deleteAcc = true
                        } label: {
                            SettingsButtonView(
                                title: "Delete Account",
                                icon: "trash.fill",
                                foregroundColor: .red
                            )
                        }
                        
                   
                        VStack(spacing: 10) {
                            Text("Bug Reporting")
                                .modifier(textStyle(size: 20))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                            Button {
                                Shake.show(.new)
                            } label: {
                                SettingsButtonView(
                                    title: "Report a Bug",
                                    icon: "trash.fill",
                                    foregroundColor: .red
                                )
                            }
                            Button {
                                Shake.configuration.tags = ["feature"]
                                Shake.show(.new)
                                Shake.configuration.tags = ["bug"]
                            } label: {
                                SettingsButtonView(
                                    title: "Feature Request",
                                    icon: "plus"
                                )
                            }
                            
                            Text("Shake to report a bug!")
                                .modifier(textStyle(size: 15))
                        }
                        .padding(.vertical, 10)
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
                .padding(.top, 20)
            }
            .navigationTitle("Settings")
            .navigationBarTitleTextColor(.secCol)
        }
        .alert("Delete Account", isPresented: $deleteAcc) {
            Button("Delete", role: .destructive) {
                try? authManager.shared.deleteAccount()
                coursesManager.shared.removeListener()
                showSignInView = true
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete your account?")
                .font(.custom("ProductSans-Regular", size: 16))
        }
    }
}

struct SettingsButtonView: View {
    let title: String
    let icon: String
    var foregroundColor: Color = .terCol
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 20))
            
            Text(title)
                .font(.custom("ProductSans-Regular", size: 17))
            
            Spacer()
        }
        .foregroundColor(foregroundColor)
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
        .background(Color.secCol)
        .cornerRadius(16)
    }
}

#Preview {
    SettingsView(showSignInView: .constant(false))
}
