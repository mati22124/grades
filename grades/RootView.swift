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
            mainView(showSignInView: $showSignInView)
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
