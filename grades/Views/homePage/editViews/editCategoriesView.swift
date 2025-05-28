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
                VStack {
                    ForEach($vm.categories, id: \.self) { $cat in
                        singleCategoryView(category: $cat, ctd: $ctd, showDeleteAlert: $showDeleteAlert)
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                    }
                    
                    if !vm.isValid {
                        Text("Weights must sum to 100%!")
                            .modifier(textStyle(size: 16))
                    }
                    
                    Spacer()
                    
                    Button {
                        do {
                            try vm.saveCategories()
                            dismiss()
                        } catch {
                            print("coulnt save categories: \(error)")
                        }
                    } label: {
                        Text("Save Categories")
                            .font(.custom("ProductSans-Bold", size: 18))
                            .foregroundColor(.secCol)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(vm.isValid ? .terCol : .gray)
                            .cornerRadius(12)
                    }
                    .disabled(!vm.isValid)
                    .padding()
                }
                .navigationTitle("Edit Categories")
                .toolbar {
                    Button {
                        vm.categories.append(category(name: "New Category", grades: [], weight: 1.0))
                        print(vm.categories)
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(.secCol)
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
    }
}

struct singleCategoryView: View {
    @Binding var category: category
    @State private var weightValue: Double // Add this state variable

    @Binding var ctd: category?
    @Binding var showDeleteAlert: Bool
    
    init(category: Binding<category>, ctd: Binding<category?>, showDeleteAlert: Binding<Bool>) {
        self._category = category
        self._weightValue = State(initialValue: category.wrappedValue.weight)
        self._ctd = ctd
        self._showDeleteAlert = showDeleteAlert
    }
    
    var body: some View {
        VStack {
            ZStack {
                
                Text(category.name)
                    .modifier(textStyle(size: 22))
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Button {
                    ctd = category
                    showDeleteAlert = true
                } label: {
                    Image(systemName: "trash")
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.horizontal, 5)
                
            }
            
            Text("Weight: \(weightValue * 100, specifier: "%.2f")%")
                .modifier(textStyle(size: 15))
                .frame(alignment: .center)

            Slider(value: $weightValue, in: 0...1, step: 0.01) { _ in
                category.weight = weightValue
            }
            .tint(Color.terCol)
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 20))

    }
}

struct textStyle: ViewModifier {
    let size: CGFloat
    func body(content: Content) -> some View {
        content
            .font(.custom("ProductSans-Regular", size: size))
            .foregroundColor(.secCol)
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
