//
//  gradesView.swift
//  grades
//
//  Created by Mayank Tiku on 9/27/24.
//

import SwiftUI

struct classesView: View {
    let backgroundColor = Color(red: 0.9, green: 0.95, blue: 1.0) // Lighter sky blue
    let accentColor = Color(red: 1.0, green: 0.8, blue: 0.0) // Gold accent
    @Binding var showSignInView: Bool
    
    @StateObject var viewModel = gradesViewModel()
    
    @State private var didAppear: Bool = false
    
    @State private var menuIsPresentedCourse: Bool = false
    
    var body: some View {
        ZStack {
            Color.primaryCol.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach($viewModel.courses) { $course in
                            NavigationLink {
                                CourseDetailView(course: $course)
                            } label: {
                                SwipeToDeleteView {
                                    ClassGradeBlock(classGrade: course)
                                        .environmentObject(viewModel)
                                } onDelete: {
                                        try? coursesManager.shared.removeCourse(data: $course.wrappedValue)
                                }
                            }
                        }
                    }
                    .padding(.top, 10)
                }
            }
            .frame(maxWidth: .infinity)
            .ignoresSafeArea(.keyboard)
            .padding(.horizontal, 20)
            
            menuButtonAdd(isMenuPresented: $menuIsPresentedCourse, menuItems: [
                menuItem(destination: addCourseView().environmentObject(viewModel), optionName: "Add Course", icon: "plus.circle.fill")
                ]
            )
        }
        .onAppear(perform: {
            if !didAppear {
                Task {
                    do {
                        try await viewModel.loadCurrentUser()
                        didAppear = true
                    } catch {
                        print("error: \(error)")
                    }
                }
            }
        })
        .onChange(of: showSignInView, { _, newValue in
            if !didAppear && newValue == false {
                Task {
                    do {
                        try await viewModel.loadCurrentUser()
                        didAppear = true
                    } catch {
                        print("error: \(error)")
                    }
                }
            }
        })
        .navigationTitle("Grades")
        .navigationBarTitleTextColor(.secCol)
    }
}

struct ClassGradeBlock: View {
    let classGrade: course
    @EnvironmentObject var viewModel: gradesViewModel
    
    var body: some View {
        HStack {
            VStack {
                Text(classGrade.name)
                    .font(.custom("ProductSans-Bold", size: 22))
                    .foregroundColor(.secCol)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(classGrade.teacher)
                    .font(.custom("ProductSans-Regular", size: 13))
                    .foregroundColor(.secCol)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Spacer()
            VStack {
                Text(classGrade.averageToGrade())
                    .font(.custom("ProductSans-Bold", size: 30))
                    .foregroundColor(.secCol)
                Text("\(classGrade.average.roundedGrade())%")
                    .font(.custom("ProductSans-Regular", size: 16))
                    .foregroundColor(.secCol)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color.terCol) //Color.accentRed.brightness(-0.08)
            .cornerRadius(5)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        }
        .padding()
        .background(Color.primaryCol) //Color.bgBlue.opacity(0.75)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
}

#Preview {
    classesView(showSignInView: .constant(false))
}

