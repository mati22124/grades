//
//  ContentView.swift
//  grades
//
//  Created by Mayank Tiku on 12/20/24.
//
import SwiftUI

struct importView: View {
    @EnvironmentObject var viewModel: gradesViewModel

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()) // figure out spacing heree
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                Color.primaryCol.edgesIgnoringSafeArea(.all)
                VStack {
                    LazyVGrid(columns: columns, spacing: 15) {
                        importItemView(
                            bgColor: .secCol,
                            textColor: .primaryCol,
                            imageName: "g.circle.fill",
                            textName: "Genesis",
                            destination: genesisImportView().environmentObject(viewModel)
                        )
                        importItemView(
                            bgColor: .secCol,
                            textColor: .primaryCol,
                            imageName: "camera.aperture",
                            textName: "Camera",
                            destination: photoImportView()
                        )
                    }
                    .padding()
                    Spacer()
                }
            }
            .navigationTitle("Import")
            .navigationBarTitleTextColor(.secCol)
        }
    }
}

struct importItemView: View {
    let bgColor: Color
    let textColor: Color
    
    let imageName: String
    let textName: String
    
    let destination: any View

    var body: some View {
        ZStack {
            bgColor.ignoresSafeArea(.all)
            NavigationLink {
                AnyView(destination)
            } label: {
                HStack {
                    Image(systemName: imageName)
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundStyle(textColor)
                    Text(textName)
                        .font(.custom("ProductSans-Regular", size: 28))
                        .foregroundColor(textColor)
                }
                .padding()
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    ZStack {
        Color.primaryCol.edgesIgnoringSafeArea(.all)
        importView()
            .environmentObject(gradesViewModel())
    }
}
