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
    
    
    var body: some View {
        VStack {
            // Content area
            TabView(selection: $selectedTab) {
                NavigationStack() {
                    StudentClassesView()
                        .navigationTitle("grades")
                        .navigationBarTitleDisplayMode(.automatic)
                }
                .tag(0)
                .ignoresSafeArea(.all)
                Text("Search")
                    .tag(1)
            }
            
            // Custom capsule-shaped tab bar
            HStack {
                ForEach(0..<2) { index in
                    TabBarItem(imageName: getImageName(for: index),
                               title: getTitle(for: index),
                               isSelected: selectedTab == index,
                               action: { selectedTab = index })
                }
            }
            .padding(8)
            .background(Color(UIColor.systemBackground)) // Add contrasting background
            .clipShape(Capsule())
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
            .padding(.horizontal)
        }
        .background(Color.bgBlue)
    }
        
    func getImageName(for index: Int) -> String {
        switch index {
        case 0: return "books.vertical.fill"
        case 1: return "gear"
        default: return ""
        }
    }
    
    func getTitle(for index: Int) -> String {
        switch index {
        case 0: return "Grades"
        case 1: return "Settings"
        default: return ""
        }
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
            .background(isSelected ? Color.blue : Color.clear)
            .clipShape(Capsule())
        }
    }
}

#Preview {
    mainView(showSignInView: .constant(false))
}
