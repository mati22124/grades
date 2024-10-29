//
//  AddCourseView.swift
//  grades
//
//  Created by Mayank Tiku on 10/29/24.
//


import SwiftUI

struct addCourseView: View {
    @State private var courseName = ""
    @State private var courseTeacher = ""
    @State private var isPointsBased = false
    
    @State private var isPressed = false
    
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var viewModel: gradesViewModel
    
    var body: some View {
        ZStack {
            Color.bgBlue.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                
                VStack(spacing: 15) {
                    TextField("", text: $courseName, prompt: Text("Course Name").foregroundStyle(.white).font(.custom("ProductSans-Regular", size: 16)))
                        .textFieldStyle(ModernTextFieldStyle())
                    
                    TextField("", text: $courseTeacher, prompt: Text("Course Teacher").foregroundStyle(.white).font(.custom("ProductSans-Regular", size: 16)))
                        .textFieldStyle(ModernTextFieldStyle())
                    
                    Toggle("Points-based Course", isOn: $isPointsBased)
                        .font(.custom("ProductSans-Regular", size: 16))
                        .foregroundColor(.white) // Darker blue
                        .padding(.vertical, 8)
                    
                    Button(action: {
                        Task {
                            do {
                                isPressed = true
                                try viewModel.addCourse(name: courseName, teacher: courseTeacher, isPoints: isPointsBased)
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
                        Text(isPressed ? "Adding..." : "Save Course")
                            .font(.custom("ProductSans-Bold", size: 18))
                            .foregroundColor(isPressed ? .gray : .white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 0.2, green: 0.5, blue: 0.8)) // Darker blue
                            .clipShape(Capsule())
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
        }
    }
}

#Preview {
    addCourseView()
        .environmentObject(gradesViewModel())
}
