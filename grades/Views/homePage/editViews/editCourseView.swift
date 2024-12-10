//
//  AddCourseView.swift
//  grades
//
//  Created by Mayank Tiku on 10/29/24.
//


import SwiftUI

struct editCourseView: View {
    
    @Binding var originalCourse: course
    
    @State private var isPressed = false
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: gradesViewModel
    
    var body: some View {
        ZStack {
            Color.primaryCol.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                
                VStack(spacing: 15) {
                    TextField("", text: $originalCourse.name, prompt: Text("Course Name").foregroundStyle(.secCol).font(.custom("ProductSans-Regular", size: 16)))
                        .textFieldStyle(ModernTextFieldStyle())
                    
                    TextField("", text: $originalCourse.teacher, prompt: Text("Course Teacher").foregroundStyle(.secCol).font(.custom("ProductSans-Regular", size: 16)))
                        .textFieldStyle(ModernTextFieldStyle())
                    
                    Toggle(isOn: $originalCourse.isPoints) {
                        Text("Points-based Course").foregroundStyle(.secCol)
                    }
                    .foregroundStyle(.terCol)
                    .font(.custom("ProductSans-Regular", size: 16))
                    .foregroundColor(.primaryCol) // Darker blue
                    .padding(.vertical, 8)
                    
                    Button(action: {
                        Task {
                            do {
                                isPressed = true
                                try viewModel.publishCourses()
                                dismiss()
                                isPressed = false
                            } catch coursesError.courseEmpty {
                                isPressed = false
                                print("one of the fieldsr empty. make sure u fill it out fully")
                            } catch {
                                isPressed = false
                                print("unknown error when adding course: \(error)")
                            }
                        }
                    }) {
                        Text(isPressed ? "Saving..." : "Save Course")
                            .font(.custom("ProductSans-Bold", size: 18))
                            .foregroundColor(isPressed ? .gray : .secCol)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.primaryCol) // Darker blue
                            .clipShape(Capsule())
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
        }
        .navigationTitle("Edit Course")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    addCourseView()
        .environmentObject(gradesViewModel())
}
