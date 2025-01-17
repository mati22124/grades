//
//  AddCourseView.swift
//  grades
//
//  Created by Mayank Tiku on 10/29/24.
//


import SwiftUI

struct addCourseView: View {
    // MARK: - Properties
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var viewModel: gradesViewModel
    
    @State private var courseInfo = CourseInfo()
    @State private var isSubmitting = false
    @State private var errorMessage: String?
    @State private var showError = false
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Color.primaryCol
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    courseFormFields
                    addCourseButton
                    Spacer(minLength: 20)
                }
                .padding(.horizontal, 20)
            }
        }
        .navigationTitle("Add Course")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Error", isPresented: $showError, actions: {
            Button("OK") { showError = false }
        }, message: {
            Text(errorMessage ?? "An unknown error occurred")
        })
    }
    
    // MARK: - Course Form Fields
    private var courseFormFields: some View {
        VStack(spacing: 15) {
            CustomTextField(
                text: $courseInfo.name,
                placeholder: "Course Name",
                icon: Image(systemName: "book.fill")
            )
            
            CustomTextField(
                text: $courseInfo.teacher,
                placeholder: "Course Teacher",
                icon: Image(systemName: "person.fill")
            )
            
            Toggle(isOn: $courseInfo.isPointsBased) {
                Label {
                    Text("Points-based Course")
                        .foregroundStyle(.secCol)
                } icon: {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(courseInfo.isPointsBased ? .terCol : .gray)
                }
            }
            .toggleStyle(SwitchToggleStyle(tint: .terCol))
        }
        .font(.custom("ProductSans-Regular", size: 16))
    }
    
    // MARK: - Add Course Button
    private var addCourseButton: some View {
        Button(action: submitCourse) {
            HStack {
                if isSubmitting {
                    ProgressView()
                        .tint(.secCol)
                }
                Text(isSubmitting ? "Adding..." : "Add Course")
                    .font(.custom("ProductSans-Bold", size: 18))
            }
            .frame(maxWidth: .infinity)
            .foregroundColor(isSubmitting ? .gray : .secCol)
            .padding()
            .background(Color.white.opacity(0.075))
            .clipShape(Capsule())
            .shadow(
                color: Color.black.opacity(0.1),
                radius: 5
            )
        }
        .disabled(isSubmitting)
    }
    
    // MARK: - Actions
    private func submitCourse() {
        Task {
            isSubmitting = true
            do {
                try viewModel.addCourse(
                    name: courseInfo.name,
                    teacher: courseInfo.teacher,
                    isPoints: courseInfo.isPointsBased
                )
                dismiss()
            } catch coursesError.courseEmpty {
                errorMessage = "Please fill out all fields before adding the course."
                showError = true
            } catch {
                errorMessage = "An error occurred while adding the course: \(error.localizedDescription)"
                showError = true
            }
            isSubmitting = false
        }
    }
}

// MARK: - Supporting Types
private struct CourseInfo {
    var name: String = ""
    var teacher: String = ""
    var isPointsBased: Bool = false
}

// MARK: - Custom TextField
private struct CustomTextField: View {
    let text: Binding<String>
    let placeholder: String
    let icon: Image
    
    var body: some View {
        HStack {
            icon
                .foregroundStyle(.terCol)
                .padding(.leading)
            
            TextField("", text: text, prompt: Text(placeholder).foregroundStyle(.secCol))
                .padding(.vertical, 14)
                .autocapitalization(.none)
                .autocorrectionDisabled()
                .foregroundStyle(.white)
                .font(.custom("ProductSans-Regular", size: 16))
                .tint(.white)
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.1))
        )
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        addCourseView()
            .environmentObject(gradesViewModel())
    }
}
