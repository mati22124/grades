//
//  GPAScaleSettingsView.swift
//  grades
//
//  Created by Mayank Tiku on 6/7/25.
//

import SwiftUI

struct GPAScaleSettingsView: View {
    @State private var settings: UserSettings = .defaultSettings
    @State private var isLoading: Bool = true
    @State private var showingSaveAlert: Bool = false
    @Environment(\.dismiss) private var dismiss
    
    @State private var expandedAPScale: Bool = true
    @State private var expandedHonorsScale: Bool = false
    @State private var expandedCPScale: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.primaryCol.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Info Section
                        VStack(spacing: 8) {
                            Text("Configure GPA values for each letter grade by course level")
                                .font(.custom("ProductSans-Regular", size: 16))
                                .foregroundColor(.secCol)
                                .opacity(0.8)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                        }
                        .padding(.top, 20)
                        
                        // AP Scale Section
                        CollapsibleGPASection(
                            title: "AP Courses",
                            isExpanded: $expandedAPScale,
                            scale: $settings.gpaScales.apScale
                        )
                        
                        // Honors/Excel Scale Section
                        CollapsibleGPASection(
                            title: "Honors/Excel Courses",
                            isExpanded: $expandedHonorsScale,
                            scale: $settings.gpaScales.honorsScale
                        )
                        
                        // CP Scale Section
                        CollapsibleGPASection(
                            title: "CP Courses",
                            isExpanded: $expandedCPScale,
                            scale: $settings.gpaScales.cpScale
                        )
                        
                        // Reset Button
                        VStack(spacing: 16) {
                            Button {
                                settings.gpaScales = GPAScales.defaultScales
                            } label: {
                                HStack {
                                    Image(systemName: "arrow.clockwise")
                                        .font(.system(size: 20))
                                    
                                    Text("Reset to Default")
                                        .font(.custom("ProductSans-Regular", size: 17))
                                    
                                    Spacer()
                                }
                                .foregroundColor(.accentRed)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 16)
                                .frame(maxWidth: .infinity)
                                .background(Color.black.opacity(0.3))
                                .cornerRadius(16)
                            }
                            .padding(.horizontal)
                        }
                        
                        Spacer(minLength: 100)
                    }
                }
            }
            .navigationTitle("GPA Scale")
            .navigationBarTitleTextColor(.secCol)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveSettings()
                    }
                    .foregroundColor(.terCol)
                    .font(.custom("ProductSans-Bold", size: 16))
                    .disabled(isLoading)
                }
            }
            .onAppear {
                loadSettings()
            }
            .alert("Settings Saved", isPresented: $showingSaveAlert) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("Your GPA scale preferences have been saved successfully.")
            }
        }
    }
    
    private func loadSettings() {
        Task {
            do {
                settings = try await settingsManager.shared.getUserSettings()
                isLoading = false
            } catch {
                print("Error loading settings: \(error)")
                isLoading = false
            }
        }
    }
    
    private func saveSettings() {
        Task {
            do {
                try await settingsManager.shared.setUserSettings(settings: settings)
                showingSaveAlert = true
            } catch {
                print("Error saving settings: \(error)")
            }
        }
    }
}

struct CollapsibleGPASection: View {
    let title: String
    @Binding var isExpanded: Bool
    @Binding var scale: GPAScale
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack {
                    Text(title)
                        .font(.custom("ProductSans-Bold", size: 20))
                        .foregroundColor(.secCol)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.secCol)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(Color.black.opacity(0.4))
                .cornerRadius(16)
            }
            .padding(.horizontal)
            
            // Content
            if isExpanded {
                VStack(spacing: 12) {
                    GPAScaleCard(label: "A+", value: $scale.aPlus)
                    GPAScaleCard(label: "A", value: $scale.a)
                    GPAScaleCard(label: "A-", value: $scale.aMinus)
                    GPAScaleCard(label: "B+", value: $scale.bPlus)
                    GPAScaleCard(label: "B", value: $scale.b)
                    GPAScaleCard(label: "B-", value: $scale.bMinus)
                    GPAScaleCard(label: "C+", value: $scale.cPlus)
                    GPAScaleCard(label: "C", value: $scale.c)
                    GPAScaleCard(label: "C-", value: $scale.cMinus)
                    GPAScaleCard(label: "D+", value: $scale.dPlus)
                    GPAScaleCard(label: "D", value: $scale.d)
                    GPAScaleCard(label: "D-", value: $scale.dMinus)
                    GPAScaleCard(label: "F", value: $scale.f)
                }
                .padding(.horizontal)
                .padding(.top, 12)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }
}

struct GPAScaleCard: View {
    let label: String
    @Binding var value: Double
    
    var body: some View {
        HStack {
            Text(label)
                .font(.custom("ProductSans-Bold", size: 18))
                .foregroundColor(.white)
                .frame(width: 40, alignment: .leading)
            
            Spacer()
            
            TextField("", value: $value, format: .number.precision(.fractionLength(0...2)))
                .keyboardType(.decimalPad)
                .font(.custom("ProductSans-Regular", size: 16))
                .foregroundColor(.white)
                .multilineTextAlignment(.trailing)
                .frame(width: 60)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.black.opacity(0.5))
                .cornerRadius(8)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .background(Color.black.opacity(0.3))
        .cornerRadius(16)
    }
}

#Preview {
    GPAScaleSettingsView()
}