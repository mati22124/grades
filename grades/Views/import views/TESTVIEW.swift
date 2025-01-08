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
    
    @State private var isShowingView: Bool = false
    @StateObject var webVM = WebViewModel()
    
    @State private var listOfGrades: [grade] = []
    
    
    var body: some View {
        NavigationStack {
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
                
                Button("Genesis Login") {
                    isShowingView = true
                }
                .sheet(isPresented: $isShowingView) {
                    ZStack {
                        WebView(webView: webVM.webView)
                        if webVM.anim {
                            Image(systemName: "checkmark")
                                .resizable()
                                .frame(width: 60, height: 60)
                        }
                    }
                }
                
                ForEach(listOfGrades) { grade in
                    GradeCard(grade: grade, isPoints: true)
                }
                
                ForEach($webVM.ccc) { $course in
                    NavigationLink {
                        courseImportPreviewView(course: $course)
                    } label: {
                        ClassGradeBlock(classGrade: $course)
                            .environmentObject(gradesViewModel())
                    }
                    .padding()
                }
                
            }
            .frame(maxWidth: .infinity)
            .background {
                Color.primaryCol.ignoresSafeArea(.all)
            }
        }
    }
}

#Preview {
    testView()
}
