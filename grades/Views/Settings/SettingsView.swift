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
                        NavigationLink {
                            GradingScaleSettingsView()
                        } label: {
                            SettingsButtonView(
                                title: "Grading Scale",
                                icon: "percent"
                            )
                        }
                        
                        Button {
                            try? authManager.shared.signOut()
                            coursesManager.shared.removeListener()
                            settingsManager.shared.removeListener()
                            finalGradesManager.shared.removeListener()
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
                                .font(.custom("ProductSans-Regular", size: 20))
                                .foregroundColor(.secCol)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                            Button {
                                Shake.show(.new)
                            } label: {
                                SettingsButtonView(
                                    title: "Report a Bug",
                                    icon: "ladybug.fill",
                                    foregroundColor: .white
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
                                .font(.custom("ProductSans-Regular", size: 15))
                                .foregroundColor(.secCol)
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
                settingsManager.shared.removeListener()
                finalGradesManager.shared.removeListener()
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
        .background(Color.black.opacity(0.3))
        .cornerRadius(16)
    }
}

#Preview {
    SettingsView(showSignInView: .constant(false))
}
