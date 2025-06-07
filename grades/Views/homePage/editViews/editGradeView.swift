//
//  editGradeView.swift
//  grades
//
//  Created by Mayank Tiku on 10/31/24.
//


import SwiftUI

struct editGradeView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: editGradeViewModel
    
    @State private var isPressed = false
    @State private var weightString: String = ""
    
    @State var gradee: grade
    
    @Binding var course: course
    
    init(grade: grade, course: Binding<course>) {
        self._gradee = State(initialValue: grade)
        self._course = course
        self._viewModel = StateObject(wrappedValue: editGradeViewModel(grade: grade))
    }
    
    var body: some View {
        ZStack {
            Color.primaryCol.ignoresSafeArea()
            GeometryReader { _ in
                VStack(spacing: 20) {
                    
                    VStack(spacing: 16) {
                        // Assignment Name
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Assignment Name")
                                .font(.custom("ProductSans-Bold", size: 14))
                                .foregroundColor(.secCol.opacity(0.8))
                            
                            TextField("Enter assignment name", text: $gradee.name)
                                .font(.custom("ProductSans-Regular", size: 16))
                                .padding()
                                .background(Color.black.opacity(0.3))
                                .cornerRadius(10)
                                .foregroundColor(.white)
                                .autocorrectionDisabled()
                        }
                        
                        // Points Section
                        HStack(spacing: 16) {
                            // Points Earned
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Points Earned")
                                    .font(.custom("ProductSans-Bold", size: 14))
                                    .foregroundColor(.secCol.opacity(0.8))
                                
                                TextField("Enter points", text: $viewModel.pointsEarned)
                                    .font(.custom("ProductSans-Regular", size: 16))
                                    .padding()
                                    .background(Color.black.opacity(0.3))
                                    .cornerRadius(10)
                                    .foregroundColor(.white)
                                    .keyboardType(.decimalPad)
                            }
                            
                            // Total Points
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Total Points")
                                    .font(.custom("ProductSans-Bold", size: 14))
                                    .foregroundColor(.secCol.opacity(0.8))
                                
                                TextField("100", text: $viewModel.totalPoints)
                                    .font(.custom("ProductSans-Regular", size: 16))
                                    .padding()
                                    .background(Color.black.opacity(0.3))
                                    .cornerRadius(10)
                                    .foregroundColor(.white)
                                    .keyboardType(.decimalPad)
                            }
                        }
                        
                        // Assignment Weight
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Assignment Weight")
                                .font(.custom("ProductSans-Bold", size: 14))
                                .foregroundColor(.secCol.opacity(0.8))
                            
                            TextField("e.g. 1.0", text: $weightString)
                                .font(.custom("ProductSans-Regular", size: 16))
                                .padding()
                                .background(Color.black.opacity(0.3))
                                .cornerRadius(10)
                                .foregroundColor(.white)
                                .keyboardType(.decimalPad)
                                .onAppear {
                                    weightString = String(gradee.weight)
                                }
                        }
                        
                        // Date and Category Section
                        HStack(spacing: 16) {
                            // Date Picker
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Date")
                                    .font(.custom("ProductSans-Bold", size: 14))
                                    .foregroundColor(.secCol.opacity(0.8))
                                
                                DatePicker("",
                                           selection: $gradee.date,
                                           displayedComponents: .date)
                                .datePickerStyle(.compact)
                                .labelsHidden()
                                .padding()
                                .background(Color.black.opacity(0.3))
                                .cornerRadius(10)
                                .accentColor(.terCol)
                                .colorScheme(.dark)
                            }
                            
                            // Category Section
                            if !course.isPoints {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Category")
                                        .font(.custom("ProductSans-Bold", size: 14))
                                        .foregroundColor(.secCol.opacity(0.8))
                                    
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
                                    .pickerStyle(.menu)
                                    .tint(.terCol)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.black.opacity(0.3))
                                    .cornerRadius(10)
                                }
                            } else {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Category")
                                        .font(.custom("ProductSans-Bold", size: 14))
                                        .foregroundColor(.secCol.opacity(0.8))
                                    
                                    TextField("Enter category", text: $viewModel.category)
                                        .font(.custom("ProductSans-Regular", size: 16))
                                        .padding()
                                        .background(Color.black.opacity(0.3))
                                        .cornerRadius(10)
                                        .foregroundColor(.white)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: 40)
                    
                    // Save Button
                    Button(action: {
                        do {
                            isPressed = true
                            if let weight = Double(weightString) {
                                gradee.weight = weight
                            }
                            try viewModel.saveGrade(course: &course, grade: gradee)
                            dismiss()
                            isPressed = false
                        } catch {
                            isPressed = false
                            print(error)
                        }
                    }) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text(isPressed ? "Saving..." : "Save Changes")
                                .font(.custom("ProductSans-Bold", size: 16))
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background((viewModel.isValidInput && !gradee.name.isEmpty) ? Color.terCol : Color.gray)
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                    .disabled(!(viewModel.isValidInput && !gradee.name.isEmpty) || isPressed)
                    .ignoresSafeArea(.keyboard)
                }
            }
        }
        .removeFocusOnTap()
        .navigationTitle("Edit Grade")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitleTextColor(.secCol)
    }
}
