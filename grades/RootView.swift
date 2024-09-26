//
//  ContentView.swift
//  grades
//
//  Created by Mayank Tiku on 9/23/24.
//

import SwiftUI

struct RootView: View {
    
    @State var showSignInView: Bool = true
    
    var body: some View {
        ZStack {
            NavigationStack {
//                GradesView()
                VStack {
                    Text("Hello, World!")
                    Button("Sign out") {
                        try? authManager.shared.signOut()
                        showSignInView = true
                    }
                    Spacer()
                }
            }
        }
        .onAppear {
            let authUser = try? authManager.shared.getAuthUser()
            showSignInView = authUser == nil
        }
        .fullScreenCover(isPresented: $showSignInView) {
            LoginView(showLoginView: $showSignInView)
        }
    }
}

#Preview {
    RootView()
}
