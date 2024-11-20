//
//  gradesView.swift
//  grades
//
//  Created by Mayank Tiku on 9/27/24.
//

import SwiftUI

struct classesView: View {
    @Binding var showSignInView: Bool
    
    @StateObject var viewModel = gradesViewModel()
    
    @State private var didAppear: Bool = false
    @State private var menuIsPresentedCourse: Bool = false
    @State private var showingAlert: Bool = false
    
    @State private var courseToDelete: course? = nil
    
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
                                    courseToDelete = $course.wrappedValue
                                }
                            }
                        }
                    }
                    .padding(.top, 10)
                }
            }
            .onChange(of: courseToDelete, { _, newValue in
                if let _ = courseToDelete {
                    showingAlert = true
                }
            })
            .alert("Confirm delete", isPresented: $showingAlert) {
                Button("Delete", role: .destructive) {
                    try? coursesManager.shared.removeCourse(data: courseToDelete!)
                    courseToDelete = nil
                }
                Button("Cancel", role: .cancel) {
                    courseToDelete = nil
                }
            } message: {
                Text("Are you sure you want to delete \(courseToDelete?.name ?? "NOT WORKING DONT DELETE")?")
            }
            .frame(maxWidth: .infinity)
            .ignoresSafeArea(.keyboard)
            .padding(.horizontal, 20)
            
            HStack {
                Spacer(minLength: 0)
                VStack(alignment: .trailing, spacing: 0) {
                    Spacer(minLength: 0)
                    NavigationLink {
                        addCourseView().environmentObject(viewModel)
                    } label: {
                        Circle()
                            .frame(width: 50, height: 50,alignment: .trailing)
                            .foregroundStyle(.terCol)
                            .overlay {
                                Image(systemName: "xmark")
                                    .foregroundStyle(.white)
                                    .fontWeight(.bold)
                            }
                            .rotationEffect(.degrees(45))
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                    .padding(.top, 10)
                }
            }

            
//            menuButtonAdd(isMenuPresented: $menuIsPresentedCourse, menuItems: [
//                menuItem(destination: addCourseView().environmentObject(viewModel), optionName: "Add Course", icon: "plus.circle.fill")
//                ]
//            )
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
        .navigationTitle("Courses")
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

