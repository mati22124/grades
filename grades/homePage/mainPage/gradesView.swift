//
//  gradesView.swift
//  grades
//
//  Created by Mayank Tiku on 9/27/24.
//

import SwiftUI

struct gradesView: View {
    let backgroundColor = Color(red: 0.9, green: 0.95, blue: 1.0) // Lighter sky blue
    let accentColor = Color(red: 1.0, green: 0.8, blue: 0.0) // Gold accent
    @Binding var showSignInView: Bool
    
    @StateObject var viewModel = gradesViewModel()
    
    var body: some View {
        ZStack {
            Color.bgBlue.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(viewModel.courses) { course in
                            NavigationLink {
                                CourseDetailView(course: course)
                            } label: {
                                ClassGradeBlock(classGrade: course)
                                    .environmentObject(viewModel)
                            }
                        }
                    }
                    .padding(.top, 10)
                }
            }
            .padding(.horizontal, 20)
        }
        .toolbar(content: {
            ToolbarItem {
                NavigationLink {
                    addCourseView()
                        .environmentObject(viewModel)
                        .navigationTitle("Add Course")
                        .navigationBarTitleDisplayMode(.inline)
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .foregroundStyle(.white)
                }
            }
        })
        .onAppear(perform: {
            Task {
                do {
                    try await viewModel.loadCurrentUser()
                } catch {
                    print("error: \(error)")
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

struct ClassGradeBlock: View {
    let classGrade: course
    @EnvironmentObject var viewModel: gradesViewModel
    
    var body: some View {
        HStack {
            VStack {
                Text(classGrade.name)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(classGrade.teacher)
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Spacer()
            VStack {
                Text(classGrade.averageToGrade())
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                Text("\(classGrade.average.roundedGrade())%")
                    .font(.system(size: 15, weight: .regular, design: .rounded))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color.accentRed.brightness(-0.08)) //Color.accentRed.brightness(-0.08)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        }
        .padding()
        .background(Color.bgBlue.brightness(-0.06)) //Color.bgBlue.opacity(0.75)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
}

#Preview {
    gradesView(showSignInView: .constant(false))
}

