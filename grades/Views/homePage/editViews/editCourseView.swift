//
//  editCourseView.swift
//  grades
//
//  Created by Mayank Tiku on 10/29/24.
//


import SwiftUI

struct editCourseView: View {
    
    @Binding var originalCourse: course
    
    @State private var isPressed = false
    @State private var creditsString: String = ""
    @State private var markingPeriodString: String = ""
    @State private var yearString: String = ""
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: gradesViewModel
    
    var body: some View {
        ZStack {
            Color.primaryCol.ignoresSafeArea()
            
            GeometryReader { _ in
                VStack(spacing: 20) {
                    VStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Course Name")
                                .font(.custom("ProductSans-Bold", size: 14))
                                .foregroundColor(.secCol.opacity(0.8))
                            
                            TextField("Course Name", text: $originalCourse.name)
                                .font(.custom("ProductSans-Regular", size: 16))
                                .padding()
                                .background(Color.black.opacity(0.3))
                                .cornerRadius(10)
                                .foregroundColor(.white)
                        }
                        .padding(.top, 10)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Course Teacher")
                                .font(.custom("ProductSans-Bold", size: 14))
                                .foregroundColor(.secCol.opacity(0.8))
                            
                            TextField("Course Teacher", text: $originalCourse.teacher)
                                .font(.custom("ProductSans-Regular", size: 16))
                                .padding()
                                .background(Color.black.opacity(0.3))
                                .cornerRadius(10)
                                .foregroundColor(.white)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Credits")
                                .font(.custom("ProductSans-Bold", size: 14))
                                .foregroundColor(.secCol.opacity(0.8))
                            
                            TextField("e.g. 1.0", text: $creditsString)
                                .font(.custom("ProductSans-Regular", size: 16))
                                .padding()
                                .background(Color.black.opacity(0.3))
                                .cornerRadius(10)
                                .foregroundColor(.white)
                                .keyboardType(.decimalPad)
                        }
                        
                        // Marking Period and Year
                        HStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Marking Period")
                                    .font(.custom("ProductSans-Bold", size: 14))
                                    .foregroundColor(.secCol.opacity(0.8))
                                
                                TextField("e.g. 1, 2, 3, 4", text: $markingPeriodString)
                                    .font(.custom("ProductSans-Regular", size: 16))
                                    .padding()
                                    .background(Color.black.opacity(0.3))
                                    .cornerRadius(10)
                                    .foregroundColor(.white)
                                    .keyboardType(.numberPad)
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Year")
                                    .font(.custom("ProductSans-Bold", size: 14))
                                    .foregroundColor(.secCol.opacity(0.8))
                                
                                TextField("e.g. 2024", text: $yearString)
                                    .font(.custom("ProductSans-Regular", size: 16))
                                    .padding()
                                    .background(Color.black.opacity(0.3))
                                    .cornerRadius(10)
                                    .foregroundColor(.white)
                                    .keyboardType(.numberPad)
                            }
                        }
                        
                        HStack {
                            Text("Points-based Course")
                                .font(.custom("ProductSans-Bold", size: 14))
                                .foregroundColor(.secCol.opacity(0.8))
                            
                            Spacer()
                            
                            Toggle(isOn: $originalCourse.isPoints) {
                                Text("")
                            }
                            .toggleStyle(SwitchToggleStyle(tint: .terCol))
                        }
                    }
                    .padding(.horizontal)
                    .onAppear {
                        if let credits = originalCourse.credits {
                            creditsString = String(credits)
                        }
                        if let markingPeriod = originalCourse.markingPeriod {
                            markingPeriodString = String(markingPeriod)
                        }
                        if let year = originalCourse.year {
                            yearString = String(year)
                        }
                    }
                    
                    Spacer(minLength: 40)
                    
                    Button(action: {
                        Task {
                            do {
                                isPressed = true
                                originalCourse.credits = Double(creditsString)
                                originalCourse.markingPeriod = Int(markingPeriodString)
                                originalCourse.year = Int(yearString)
                                try viewModel.publishCourses()
                                dismiss()
                                isPressed = false
                            } catch coursesError.courseEmpty {
                                isPressed = false
                                print("one of the fields empty. make sure u fill it out fully")
                            } catch {
                                isPressed = false
                                print("unknown error when saving course: \(error)")
                            }
                        }
                    }) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text(isPressed ? "Saving..." : "Save Course")
                                .font(.custom("ProductSans-Bold", size: 16))
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(isPressed ? Color.gray : Color.terCol)
                        .cornerRadius(10)
                        .ignoresSafeArea(.keyboard)
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                    .disabled(isPressed)
                }
            }
        }
        .removeFocusOnTap()
        .navigationTitle("Edit Course")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitleTextColor(.secCol)
    }
}

#Preview {
    NavigationView {
        editCourseView(originalCourse: .constant(course(name: "Test Course", teacher: "Test Teacher", isPoints: true)))
            .environmentObject(gradesViewModel())
    }
}
