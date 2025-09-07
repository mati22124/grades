//
//  GenesisURLEditView.swift
//  grades
//
//  Created by Mayank Tiku on 9/7/25.
//

import SwiftUI

struct GenesisURLEditView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("genesisURL") private var genesisURL: String = ""
    @State private var selectedOption: String = ""
    @State private var customURL: String = ""
    
    let schools: [(name: String, url: String)] = [
        ("Montville Township Public Schools", "https://students.montville.net/genesis"),
        ("Livingston Public School", "https://students.livingston.org/livingston"),
        ("Livingston Public School", "https://students.livingston.org/livingston"),
        ("South Brunswick Public Schools", "https://students.sbschools.org/genesis"),
        ("Monroe Township Schools - Parents", "https://parents.monroe.k12.nj.us/genesis"),
        ("Caldwell-West Caldwell School District", "https://students.c1.genesisedu.net/cwcboe"),
        ("Custom URL", "custom")
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.primaryCol.ignoresSafeArea()
                
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Genesis URL Configuration")
                            .font(.custom("ProductSans-Bold", size: 22))
                            .foregroundColor(.secCol)
                            .padding(.bottom, 6)
                        
                        Text("Select your school district or enter a custom Genesis URL")
                            .font(.custom("ProductSans-Regular", size: 16))
                            .foregroundColor(.secCol.opacity(0.8))
                            .multilineTextAlignment(.leading)
                    }
                    .padding(.top, 20)
                    
                    VStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("School District")
                                .font(.custom("ProductSans-Regular", size: 14))
                                .foregroundColor(.secCol.opacity(0.8))
                            
                            Picker("School District", selection: $selectedOption) {
                                ForEach(schools, id: \.url) { school in
                                    Text(school.name)
                                        .tag(school.url)
                                }
                            }
                            .pickerStyle(.menu)
                            .tint(.white)
                            .padding(8)
                            .background(Color.black.opacity(0.3))
                            .cornerRadius(16)
                        }
                        
                        if selectedOption == "custom" {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Custom URL Override")
                                    .font(.custom("ProductSans-Regular", size: 14))
                                    .foregroundColor(.secCol.opacity(0.8))
                                
                                TextField("", text: $customURL, prompt: Text("https://genesis.example.org").foregroundStyle(.secCol.opacity(0.5)).font(.custom("ProductSans-Regular", size: 16)))
                                    .padding()
                                    .background(Color.black.opacity(0.3))
                                    .cornerRadius(16)
                                    .foregroundColor(.white)
                                    .autocapitalization(.none)
                                    .autocorrectionDisabled()
                                    .font(.custom("ProductSans-Regular", size: 16))
                                    .tint(.white)
                                    .keyboardType(.URL)
                                
                                Text("Enter the base Genesis URL up to (but not including) '/sis/'\n\nExample: https://students.example.org/genesis\n(Not the full login page URL)")
                                    .font(.custom("ProductSans-Regular", size: 14))
                                    .foregroundColor(.secCol.opacity(0.8))
                                    .multilineTextAlignment(.leading)
                                    .padding(.horizontal)
                            }
                            .transition(.opacity.combined(with: .move(edge: .top)))
                        }
                        
                        if selectedOption != "custom" && selectedOption != "" {
                            HStack {
                                Image(systemName: "link")
                                    .foregroundColor(.secCol.opacity(0.7))
                                    .font(.system(size: 14))
                                
                                Text(selectedOption)
                                    .font(.custom("ProductSans-Regular", size: 14))
                                    .foregroundColor(.secCol.opacity(0.7))
                                    .lineLimit(1)
                                    .truncationMode(.middle)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.black.opacity(0.2))
                            .cornerRadius(12)
                        }
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 16) {
                        Button(action: {
                            dismiss()
                        }) {
                            Text("Cancel")
                                .font(.custom("ProductSans-Regular", size: 16))
                                .foregroundColor(.secCol)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 12)
                                .background(Color.black.opacity(0.3))
                                .cornerRadius(20)
                        }
                        
                        Button(action: {
                            if selectedOption == "custom" {
                                // Extract base URL up to /sis/ if present
                                if let range = customURL.range(of: #"^(.*?)(?=/sis/)"#, options: .regularExpression) {
                                    genesisURL = String(customURL[range])
                                } else {
                                    // If no /sis/ found, use the URL as is (assuming it's already the base URL)
                                    genesisURL = customURL
                                }
                            } else {
                                genesisURL = selectedOption
                            }
                            dismiss()
                        }) {
                            Text("Save")
                                .font(.custom("ProductSans-Bold", size: 16))
                                .foregroundColor(.white)
                                .padding(.horizontal, 32)
                                .padding(.vertical, 12)
                                .background(.terCol)
                                .cornerRadius(20)
                        }
                        .disabled(selectedOption.isEmpty || (selectedOption == "custom" && customURL.isEmpty))
                    }
                    .padding(.bottom, 20)
                }
                .padding(.horizontal)
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            if schools.contains(where: { $0.url == genesisURL }) {
                selectedOption = genesisURL
            } else {
                selectedOption = "custom"
                customURL = genesisURL
            }
        }
    }
}

#Preview {
    GenesisURLEditView()
}
