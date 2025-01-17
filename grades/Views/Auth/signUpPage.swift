//
//  signUpPage.swift
//  grades
//
//  Created by Mayank Tiku on 9/24/24.
//

import SwiftUI
import Firebase


struct SignUpView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    @Binding var showSignUpView: Bool
    @Binding var showLoginView: Bool
    
    @StateObject var viewModel = signUpViewModel()
    
    //error handlign
    @State private var errorMessage: String?
    @State private var showError = false
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            Color.primaryCol.edgesIgnoringSafeArea(.all).opacity(0.95)
            
            VStack(spacing: 15) {
                VStack(spacing: 10) {
                    Image(systemName: "books.vertical.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.terCol)
                    
                    Text("GradePoint")
                        .font(.custom("ProductSans-Bold", size: 40))
                        .foregroundColor(.secCol)
                }
                
                
                VStack(spacing: 15) {
                    TextField("", text: $viewModel.email, prompt: Text("Email").foregroundStyle(.secCol).font(.custom("ProductSans-Regular", size: 16)))
                        .textFieldStyle(ModernTextFieldStyle())
                    SecureField("", text: $viewModel.password, prompt: Text("Password").foregroundStyle(.secCol).font(.custom("ProductSans-Regular", size: 16)))                        .textFieldStyle(ModernTextFieldStyle())
                    SecureField("", text: $viewModel.confirmPassword, prompt: Text("Confirm Password").foregroundStyle(.secCol).font(.custom("ProductSans-Regular", size: 16)))                        .textFieldStyle(ModernTextFieldStyle())
                       
                }
                .padding(.top, 5)
                .padding(.bottom,5)
                VStack(spacing: 15) {
                    Button(action: {
                        Task {
                            do {
                                try await viewModel.signUp()
                                showLoginView = false
                                showSignUpView = false
                            } catch {
                                errorMessage = "An error occurred while signing up: \(error.localizedDescription)"
                                showError = true
                            }
                        }
                    }) {
                        Text("Sign Up")
                            .font(.custom("ProductSans-Bold", size: 18))
                            .foregroundColor(.primaryCol)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.secCol)
                            .clipShape(Capsule())
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                    }
                    HStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(.secCol)
                            .frame(width: 100, height: 1, alignment: .leading)
                        Text("or")
                            .foregroundStyle(.secCol)
                            .font(.custom("ProductSans-Regular", size: 16))
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(.secCol)
                            .frame(width: 100, height: 1, alignment: .leading)
                    }
                    
                    Button(action: {
                        showSignUpView.toggle()
                    }) {
                        Text("Log In")
                            .font(.custom("ProductSans-Bold", size: 18))
                            .foregroundColor(.primaryCol)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.secCol)
                            .clipShape(Capsule())
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                    }
                    //error handlign
                    .alert("Error", isPresented: $showError, actions: {
                        Button("OK") { showError = false }
                    }, message: {
                        Text(errorMessage ?? "An unknown error occurred")
                    })
                }
            }
            .padding(.horizontal, 30)
        }
    }
}


#Preview {
    SignUpView(showSignUpView: .constant(true), showLoginView: .constant(true))
}
