//
//  AddGradeView.swift
//  grades
//
//  Created by Mayank Tiku on 10/31/24.
//


import SwiftUI

struct editGradeView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: editGradeViewModel
    
    @State private var isPressed = false
    
    @State var gradee: grade
    
    @Binding var course: course
    
    init(grade: grade, course: Binding<course>) {
        self._gradee = State(initialValue: grade)
        self._course = course
        self._viewModel = StateObject(wrappedValue: editGradeViewModel(grade: grade))
    }
    
    var body: some View {
        GeometryReader { _ in
            ZStack {
                Color.primaryCol.edgesIgnoringSafeArea(.all).removeFocusOnTap()
                VStack(spacing: 16) {
                    // Assignment Name
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Assignment Name")
                            .font(.custom("ProductSans-Regular", size: 16))
                            .foregroundColor(.secCol)
                        
                        TextField("", text: $gradee.name, prompt: Text("Enter assignment name").foregroundStyle(.secCol).font(.custom("ProductSans-Regular", size: 16)))
                            .textFieldStyle(ModernTextFieldStyle())
                            .autocorrectionDisabled()
                    }
                    .removeFocusOnTap()
                    
                    // Points Section
                    HStack(spacing: 16) {
                        // Points Earned
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Points Earned")
                                .font(.custom("ProductSans-Regular", size: 16))
                                .foregroundColor(.secCol)
                            
                            TextField("", text: $viewModel.pointsEarned, prompt: Text("Enter here").foregroundStyle(.secCol).font(.custom("ProductSans-Regular", size: 16)))
                                .textFieldStyle(ModernTextFieldStyle())
                                .keyboardType(.decimalPad)
                        }
                        .removeFocusOnTap()
                        
                        
                        // Total Points
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Total Points")
                                .font(.custom("ProductSans-Regular", size: 16))
                                .foregroundColor(.secCol)
                            
                            TextField("100", text: $viewModel.totalPoints, prompt: Text("Enter here").foregroundStyle(.secCol).font(.custom("ProductSans-Regular", size: 16)))
                                .textFieldStyle(ModernTextFieldStyle())
                                .keyboardType(.decimalPad)
                        }
                    }
                    .removeFocusOnTap()
                    
                    
                    // Date Picker
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Date")
                            .font(.custom("ProductSans-Regular", size: 16))
                            .foregroundColor(.secCol)
                        
                        DatePicker("Assignment Date",
                                   selection: $gradee.date,
                                   displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .clipShape(Capsule())
                        .accentColor(.terCol)
                        .colorScheme(.dark)
                    }
                    
                    if !course.isPoints {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Category")
                                .font(.custom("ProductSans-Regular", size: 16))
                                .foregroundColor(.secCol)
                            LabeledContent {
                                Picker("", selection: $viewModel.category) {
                                    ForEach(0..<(course.categories.count+1)) {
                                        if $0 == course.categories.count {
                                            Text("No Category")
                                                .tag("No Category")
                                        } else {
                                            Text(course.categories[$0].name)
                                                .tag(course.categories[$0].name)
                                        }
                                    }
                                }
                                .tint(.terCol)
                            } label: {
                                Text("Category")
                            }
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .clipShape(Capsule())
                            .accentColor(.terCol)
                            .colorScheme(.dark)
                        }
                    } else {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Category")
                                .font(.custom("ProductSans-Regular", size: 16))
                                .foregroundColor(.secCol)
                            TextField("", text: $viewModel.category, prompt: Text("Enter Category").foregroundStyle(.secCol).font(.custom("ProductSans-Regular", size: 16)))
                                .textFieldStyle(ModernTextFieldStyle())
                        }
                    }
                    
                    Spacer()
                    
                    // Save Button
                    Button(action: {
                        do {
                            isPressed = true
                            try viewModel.saveGrade(course: &course, grade: gradee)
                            dismiss()
                            isPressed = false
                        } catch {
                            isPressed = false
                            print(error)
                        }
                    }) {
                        Text(isPressed ? "Changing Grade..." : "Edit Grade")
                            .font(.custom("ProductSans-Bold", size: 18))
                            .foregroundColor(isPressed ? .gray : .secCol)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background((viewModel.isValidInput && !gradee.name.isEmpty) ? Color.terCol : Color.gray)
                            .cornerRadius(12)
                    }
                    .disabled(!(viewModel.isValidInput && !gradee.name.isEmpty))
                }
                .padding()
                .navigationTitle("Edit Grade")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarTitleTextColor(.secCol)
            }
        }
    }
}
