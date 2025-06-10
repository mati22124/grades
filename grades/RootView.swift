//
//  ContentView.swift
//  grades
//
//  Created by Mayank Tiku on 9/23/24.
//

import SwiftUI

struct RootView: View {
    
    @State var showSignInView: Bool = false
    @State var showFirstLaunchSheet: Bool = false
    @AppStorage("hasLaunchedBefore") private var hasLaunchedBefore: Bool = false
    
    var body: some View {
        ZStack {
            mainView(showSignInView: $showSignInView)
        }
        .onAppear {
            let authUser = try? authManager.shared.getAuthUser()
            showSignInView = authUser == nil
            
            if !hasLaunchedBefore {
                showFirstLaunchSheet = true
            }
        }
        .fullScreenCover(isPresented: $showSignInView) {
            LoginView(showLoginView: $showSignInView)
        }
        .sheet(isPresented: $showFirstLaunchSheet) {
            FirstLaunchView(isPresented: $showFirstLaunchSheet)
                .onDisappear {
                    hasLaunchedBefore = true
                }
        }
    }
}

#Preview {
    RootView()
}
