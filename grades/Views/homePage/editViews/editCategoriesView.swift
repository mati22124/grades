//
//  editCategoriesView.swift
//  grades
//
//  Created by Mayank Tiku on 2/8/25.
//

import SwiftUI

struct editCategoriesView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var vm: editCategoryViewModel
    
    @State var ctd: category? = nil
    @State var showDeleteAlert: Bool = false
    
    init(course: course) {
        self._vm = StateObject(wrappedValue: editCategoryViewModel(course: course))
        self.ctd = nil
        self.showDeleteAlert = false
    }
    
    var body: some View {
        ZStack {
            Color.primaryCol.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 12) {
                    ForEach($vm.categories, id: \.self) { $cat in
                        singleCategoryView(category: $cat, ctd: $ctd, showDeleteAlert: $showDeleteAlert)
                            .padding(.horizontal, 20)
                    }
                    
                    if !vm.isValid {
                        Text("Weights must sum to 100%!")
                            .font(.custom("ProductSans-Bold", size: 16))
                            .foregroundColor(.red)
                            .padding(.top, 10)
                    }
                    
                    Button {
                        do {
                            try vm.saveCategories()
                            dismiss()
                        } catch {
                            print("coulnt save categories: \(error)")
                        }
                    } label: {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Save Categories")
                                .font(.custom("ProductSans-Bold", size: 16))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(vm.isValid ? Color.terCol : Color.gray)
                        .cornerRadius(10)
                    }
                    .disabled(!vm.isValid)
                    .padding(.horizontal, 20)
                    .padding(.bottom)
                }
                .padding(.top, 10)
            }
        }
        .navigationTitle("Edit Categories")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitleTextColor(.secCol)
        .toolbar {
            Button {
                vm.categories.append(category(name: "New Category", grades: [], weight: 0.1))
                print(vm.categories)
            } label: {
                Image(systemName: "plus.circle.fill")
                    .foregroundStyle(.terCol)
            }
        }
        .alert("Confirm delete", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                vm.deleteCategory(catToDelete: ctd)
                ctd = nil
            }
            Button("Cancel", role: .cancel) {
                ctd = nil
            }
        } message: {
            Text("Are you sure you want to delete the \(ctd?.name ?? "NOT WORKING DONT DELETE") category? When saved, all grades inside the category will be deleted.")
        }
    }
}

struct singleCategoryView: View {
    @Binding var category: category
    @State private var weightValue: Double
    @State private var weightPercentage: String

    @Binding var ctd: category?
    @Binding var showDeleteAlert: Bool
    
    init(category: Binding<category>, ctd: Binding<category?>, showDeleteAlert: Binding<Bool>) {
        self._category = category
        let initialWeight = category.wrappedValue.weight
        self._weightValue = State(initialValue: initialWeight)
        self._weightPercentage = State(initialValue: String(format: "%.0f", initialWeight * 100))
        self._ctd = ctd
        self._showDeleteAlert = showDeleteAlert
    }
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text(category.name)
                    .font(.custom("ProductSans-Bold", size: 22))
                    .foregroundColor(.secCol)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Button {
                    ctd = category
                    showDeleteAlert = true
                } label: {
                    Image(systemName: "trash.fill")
                        .foregroundStyle(.red)
                        .font(.system(size: 20))
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            
            VStack(spacing: 16) {
                // Weight display
                Text("Weight: \(Int(weightValue * 100))%")
                    .font(.custom("ProductSans-Bold", size: 18))
                    .foregroundColor(.secCol)
                
                // Slider
                Slider(value: $weightValue, in: 0...1, step: 0.01) { _ in
                    category.weight = weightValue
                    weightPercentage = String(format: "%.0f", weightValue * 100)
                }
                .tint(Color.terCol)
                .padding(.horizontal)
                
                // Increment/Decrement buttons
                HStack(spacing: 8) {
                    // Decrement buttons
                    Button(action: { adjustWeight(-10) }) {
                        Text("-10")
                            .font(.custom("ProductSans-Bold", size: 12))
                            .foregroundColor(.white)
                            .frame(width: 42, height: 30)
                            .background(Color.red.opacity(0.8))
                            .cornerRadius(6)
                    }
                    
                    Button(action: { adjustWeight(-5) }) {
                        Text("-5")
                            .font(.custom("ProductSans-Bold", size: 12))
                            .foregroundColor(.white)
                            .frame(width: 42, height: 30)
                            .background(Color.red.opacity(0.6))
                            .cornerRadius(6)
                    }
                    
                    Button(action: { adjustWeight(-1) }) {
                        Text("-1")
                            .font(.custom("ProductSans-Bold", size: 12))
                            .foregroundColor(.white)
                            .frame(width: 42, height: 30)
                            .background(Color.red.opacity(0.4))
                            .cornerRadius(6)
                    }
                    
                    // Increment buttons
                    Button(action: { adjustWeight(1) }) {
                        Text("+1")
                            .font(.custom("ProductSans-Bold", size: 12))
                            .foregroundColor(.white)
                            .frame(width: 42, height: 30)
                            .background(Color.green.opacity(0.4))
                            .cornerRadius(6)
                    }
                    
                    Button(action: { adjustWeight(5) }) {
                        Text("+5")
                            .font(.custom("ProductSans-Bold", size: 12))
                            .foregroundColor(.white)
                            .frame(width: 42, height: 30)
                            .background(Color.green.opacity(0.6))
                            .cornerRadius(6)
                    }
                    
                    Button(action: { adjustWeight(10) }) {
                        Text("+10")
                            .font(.custom("ProductSans-Bold", size: 12))
                            .foregroundColor(.white)
                            .frame(width: 42, height: 30)
                            .background(Color.green.opacity(0.8))
                            .cornerRadius(6)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .background(Color.black.opacity(0.3))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
    
    private func adjustWeight(_ change: Int) {
        let newPercentage = (weightValue * 100) + Double(change)
        let clampedPercentage = min(100, max(0, newPercentage))
        weightValue = clampedPercentage / 100.0
        category.weight = weightValue
        weightPercentage = String(format: "%.0f", clampedPercentage)
    }
}

#Preview {
    @Previewable @State var c = course(
        name: "AP Calculus BC",
        teacher: "Anatoly Fonarev",
        grades: [
            grade(name: "Test grade", points: 100, earned: 95, weight: 1, date: Date()),
            grade(name: "Test grade 2", points: 100, earned: 85, weight: 1, date: Date()),
            grade(name: "Test grade 3", points: 100, earned: 75, weight: 1, date: Date())
        ], categories: [
            category(name: "Homework", grades: [], weight: 0.1),
            category(name: "Assessments", grades: [], weight: 0.85),
            category(name: "Labs", grades: [], weight: 0.05)
        ]
    )
    NavigationStack {
        editCategoriesView(course: c)
    }
}
