//
//  mainView.swift
//  grades
//
//  Created by Mayank Tiku on 9/26/24.
//

import SwiftUI

struct mainView: View {
    @Binding var showSignInView: Bool
    @State private var selectedTab: Int = 0
    
    @State private var deleteAcc: Bool = false
    
    var items = [ittabbar(image: "books.vertical.fill", title: "Grades", index: 0), ittabbar(image: "gear", title: "Settings", index: 1)]
    
    var body: some View {
        VStack(spacing: 0) {
            if #available(iOS 18.0, *) {
                TabView {
                    Tab("Grades", systemImage: "books.vertical.fill") {
                        NavigationStack {
                            classesView(showSignInView: $showSignInView)
                        }
                    }
                    
                    Tab("Import", systemImage: "square.and.arrow.up") {
                        testView()
                    }
                    
                    Tab("Settings", systemImage: "gear") {
                        ZStack {
                            Color.primaryCol.ignoresSafeArea(.all)
                            VStack {
                                Button {
                                    try? authManager.shared.signOut()
                                    coursesManager.shared.removeListener()
                                    showSignInView = true
                                } label: {
                                    Text("Sign Out")
                                }
                                
                                Button {
                                    deleteAcc = true
                                } label: {
                                    Text("delete account")
                                }
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
                            }
                        }
                    }
                }
                .tint(.terCol)
            } else {
                TabView(selection: $selectedTab) {
                    NavigationStack {
                        classesView(showSignInView: $showSignInView)
                    }
                    .tabItem {
                        Label("Grades", systemImage: "books.vertical.fill")
                    }
                    .tag(0)
                    
                    testView()
                    .tabItem {
                        Label("Import", systemImage: "square.and.arrow.up")

                    }
                    .tag(1)

                    ZStack {
                        Color.primaryCol.ignoresSafeArea(.all)
                        VStack {
                            Button {
                                try? authManager.shared.signOut()
                                coursesManager.shared.removeListener()
                                showSignInView = true
                            } label: {
                                Text("Sign Out")
                            }
                            
                            Button {
                                deleteAcc = true
                            } label: {
                                Text("delete account")
                            }
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
                        }
                    }
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
                    .tag(2)
                }
                .tint(.terCol)
            }

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.primaryCol.ignoresSafeArea(.all))
        .ignoresSafeArea(.keyboard)
        .onAppear{
            UITabBar.appearance().unselectedItemTintColor = .lightGray
        }
    }
}

struct ittabbar: Identifiable {
    var id: String = UUID().uuidString
    var image:String
    var title:String
    var index:Int
}

#Preview {
    mainView(showSignInView: .constant(false))
}
