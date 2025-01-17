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
    
    @StateObject var gradesVm = gradesViewModel()
    
    @State private var deleteAcc: Bool = false
    
    var items = [ittabbar(image: "books.vertical.fill", title: "Grades", index: 0), ittabbar(image: "gear", title: "Settings", index: 1)]
    
    var body: some View {
        VStack(spacing: 0) {
            if #available(iOS 18.0, *) {
                TabView {
                    Tab("Grades", systemImage: "books.vertical.fill") {
                        classesView(showSignInView: $showSignInView)
                            .environmentObject(gradesVm)
                    }
                    
                    Tab("Import", systemImage: "square.and.arrow.up") {
                        importView()
                            .environmentObject(gradesVm)
                    }
                    
                    Tab("Settings", systemImage: "gear") {
                        SettingsView(showSignInView: $showSignInView)
                    }
                }
                .tint(.terCol)
            } else {
                TabView(selection: $selectedTab) {
                    classesView(showSignInView: $showSignInView)
                    .environmentObject(gradesVm)
                    .tabItem {
                        Label("Grades", systemImage: "books.vertical.fill")
                    }
                    .tag(0)
                    
                    importView()
                        .environmentObject(gradesVm)
                        .tabItem {
                            Label("Import", systemImage: "square.and.arrow.up")
                        }
                    .tag(1)

                    SettingsView(showSignInView: $showSignInView)
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
