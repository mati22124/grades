//
//  gradesView.swift
//  grades
//
//  Created by Mayank Tiku on 9/27/24.
//

import SwiftUI

struct gradesView: View {
    @Binding var showSignInView: Bool
    
    @StateObject var viewModel = gradesViewModel()
    
    var body: some View {
        ZStack {
            Color.bgBlue.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(viewModel.courses) { classGrade in
                            ClassGradeRow(course: classGrade)
                        }
                    }
                    .padding(.top, 10)
                }
            }
            .padding(.horizontal, 20)
        }
        .toolbar(content: {
            ToolbarItem {
                Button {
                    //add course logic
                } label: {
                    Image(systemName: "plus.circle.fill")
                }
            }
        })
        .onChange(of: showSignInView, { _, newValue in
            if newValue == false {
                Task {
                    do {
                        try await viewModel.loadCurrentUser()
                    } catch {
                        print("error: \(error)")
                    }
                }
            }
        })
    }
}

struct ClassGradeRow: View {
    let course: course
    
    var body: some View {
        HStack {
            Text(course.name)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(Color(red: 0.2, green: 0.5, blue: 0.8))
            
            Spacer()
            
            Text("\(course.average)")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(Color(red: 0.2, green: 0.5, blue: 0.8))
        }
        .padding()
        .background(Color.white)
        .clipShape(Capsule())
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
}

#Preview {
    gradesView(showSignInView: .constant(false))
}
