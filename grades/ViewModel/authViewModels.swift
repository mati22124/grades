//
//  authViewModel.swift
//  grades
//
//  Created by Mayank Tiku on 9/25/24.
//

import Foundation
import Firebase
import GoogleSignIn

@MainActor
final class signInViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("email or password empty")
            throw authError.noEmailOrPassword
        }
        
        let _ = try await authManager.shared.signIn(email: email, password: password)
    }
    
    func signInGoogle() async throws {
        guard let topVC = UIApplication.topViewController() else {
            print("cant find topvc")
            throw URLError(.badURL)
        }
        let gidsigninresult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
        
        let accessToken = gidsigninresult.user.accessToken.tokenString
        
        guard let idToken = gidsigninresult.user.idToken?.tokenString else {
            print("no id token")
            throw URLError(.badURL)
        }
        
        let _ = try await authManager.shared.signInWithCredential(idToken: idToken, accessToken: accessToken)
    }
    
}

@MainActor
final class signUpViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""

    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            print("email or password empty")
            throw authError.noEmailOrPassword
        }
        
        guard password == confirmPassword else {
            print("passwords do not match")
            throw authError.passwordsNoMatch
        }
        
        let _ = try await authManager.shared.createUser(email: email, password: password)
    }
}
