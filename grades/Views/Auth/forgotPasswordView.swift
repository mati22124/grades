//
//  ForgotPasswordView.swift
//  grades
//
//  Created by Mayank Tiku on 12/13/24.
//


import SwiftUI

struct forgotPasswordView: View {
    @Environment(\.dismiss) private var dismiss
    
    // i aint creating a view model for ts
    @State private var email = ""
    @State private var isPressed = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @State var isvalidemail: Bool = false
    
    var body: some View {
        ZStack {
            Color.primaryCol.ignoresSafeArea()
            
            VStack(spacing: 20) {
                VStack(spacing: 15) {
                    Text("Reset Password")
                        .font(.custom("ProductSans-Bold", size: 24))
                        .foregroundColor(.secCol)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("Enter your email address and we'll send you instructions to reset your password.")
                        .font(.custom("ProductSans-Regular", size: 16))
                        .foregroundColor(.secCol.opacity(0.8))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 10)
                    
                    TextField("", text: $email, prompt: Text("Email").foregroundStyle(.secCol).font(.custom("ProductSans-Regular", size: 16)))
                        .padding()
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(16)
                        .foregroundColor(.white)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                        .font(.custom("ProductSans-Regular", size: 16))
                        .tint(.white)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                        
                    
                    Spacer()
                    
                    Button(action: {
                        if email.isEmail() {
                            authManager.shared.resetPassword(email: email)
                            alertMessage = "Password reset email sent. Please check your inbox."
                            showAlert = true
                        } else {
                            alertMessage = "Email is not valid. Check it and try again."
                            showAlert = true
                        }
                    }) {
                        Text("Reset Password")
                            .font(.custom("ProductSans-Bold", size: 18))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.terCol)
                            .cornerRadius(16)
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                    }
                    .disabled(email.isEmpty)
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Back to Login")
                            .font(.custom("ProductSans-Regular", size: 16))
                            .foregroundColor(.secCol.opacity(0.8))
                            .padding(.top, 10)
                    }
                }
                .padding(.horizontal, 30)
                
                Spacer()
            }
            .padding(.top, 40)
        }
        .alert("Password Reset", isPresented: $showAlert) {
            Button("OK") {
                if alertMessage.contains("sent") {
                    dismiss()
                }
            }
        } message: {
            Text(alertMessage)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    forgotPasswordView()
}