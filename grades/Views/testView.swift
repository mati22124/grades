//
//  testView.swift
//  grades
//
//  Created by Mayank Tiku on 11/19/24.
//

import SwiftUI
import PhotosUI

struct testView: View {
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    
    @State private var listOfGrades: [grade] = []
    
    var body: some View {
        ScrollView {
            PhotosPicker(
                selection: $selectedItem,
                matching: .images,
                photoLibrary: .shared()) {
                    Text("Select a photo")
                }
                .onChange(of: selectedItem) { _,newItem in
                    Task {
                        // Retrieve selected asset in the form of Data
                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                            selectedImage = UIImage(data: data)
                            do {
                                listOfGrades = try await importManager.shared.sendMessageFromImage(image: selectedImage)
                            } catch {
                                listOfGrades = []
                                print("error with anthropic: \(error)")
                            }
                        }
                    }
                }
            Button("retry") {
                Task {
                    do {
                        listOfGrades = try await importManager.shared.sendMessageFromImage(image: selectedImage)
                    } catch {
                        listOfGrades = []
                        print("error with anthropic: \(error)")
                    }
                }
            }
            ForEach(listOfGrades) { grade in
                GradeCard(grade: grade, isPoints: true)
            }
        }
    }
}

#Preview {
    testView()
}
