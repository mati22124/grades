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
            // Content area
//            VStack {
//                switch(selectedTab) {
//                case 0:
//
//                case 1:
//                    Button {
//                        try? authManager.shared.signOut()
//                        showSignInView = true
//                    } label: {
//                        Text("Sign Out")
//                    }
//                default:
//                    Text("Error")
//                }
//            }.ignoresSafeArea(.keyboard, edges: .bottom)
//            
            TabView {
                Tab("Grades", systemImage: "books.vertical.fill") {
                    NavigationStack {
                        classesView(showSignInView: $showSignInView)
                    }
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
            .background(Color(UIColor.systemBackground))
//            // Custom capsule-shaped tab bar
//            HStack {
//                ForEach(items) { item in
//                    TabBarItem(imageName: item.image,
//                               title: item.title,
//                               isSelected: selectedTab == item.index,
//                               action: { selectedTab = item.index })
//                }
//            }
//            .padding(8)
//            .background(Color(UIColor.systemBackground))
//            .clipShape(Capsule())
//            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
//            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.primaryCol.ignoresSafeArea(.all))
        .ignoresSafeArea(.keyboard)
    }
}

struct TabBarItem: View {
    let imageName: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: imageName)
                    .font(.system(size: 20))
                if isSelected {
                    Text(title)
                        .font(.caption)
                        .fontWeight(.bold)
                }
            }
            .foregroundColor(isSelected ? .white : .gray)
            .padding(.vertical, 10)
            .padding(.horizontal, isSelected ? 16 : 12)
            .background(isSelected ? Color.terCol : Color.clear)
            .clipShape(Capsule())
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
