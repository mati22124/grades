//
//  GradingScaleSettingsView.swift
//  grades
//
//  Created by Mayank Tiku on 5/22/25.
//

import SwiftUI

struct GradingScaleSettingsView: View {
    @State private var settings: UserSettings = .defaultSettings
    @State private var isLoading: Bool = true
    @State private var showingSaveAlert: Bool = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.primaryCol.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Grading Options Section
                        VStack(spacing: 16) {
                            Text("Grading Options")
                                .modifier(textStyle(size: 20))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                            
                            VStack(spacing: 12) {
                                ToggleRowView(
                                    title: "Round percentages for letter grades",
                                    isOn: $settings.roundForLetterGrade
                                )
                            }
                            .padding(.horizontal)
                            
                            Text("When enabled, percentages will be rounded to the nearest whole number before calculating letter grades")
                                .modifier(textStyle(size: 14))
                                .opacity(0.7)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                        }
                        
                        // Grade Scale Section
                        VStack(spacing: 16) {
                            Text("Grade Scale (Minimum Percentage)")
                                .modifier(textStyle(size: 20))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                            
                            VStack(spacing: 12) {
                                GradeScaleCard(label: "A+", value: $settings.gradingScale.aPlus)
                                GradeScaleCard(label: "A", value: $settings.gradingScale.a)
                                GradeScaleCard(label: "A-", value: $settings.gradingScale.aMinus)
                                GradeScaleCard(label: "B+", value: $settings.gradingScale.bPlus)
                                GradeScaleCard(label: "B", value: $settings.gradingScale.b)
                                GradeScaleCard(label: "B-", value: $settings.gradingScale.bMinus)
                                GradeScaleCard(label: "C+", value: $settings.gradingScale.cPlus)
                                GradeScaleCard(label: "C", value: $settings.gradingScale.c)
                                GradeScaleCard(label: "C-", value: $settings.gradingScale.cMinus)
                                GradeScaleCard(label: "D+", value: $settings.gradingScale.dPlus)
                                GradeScaleCard(label: "D", value: $settings.gradingScale.d)
                                GradeScaleCard(label: "D-", value: $settings.gradingScale.dMinus)
                            }
                            .padding(.horizontal)
                            
                            Text("Enter the minimum percentage required for each letter grade. Grades below D- will be F.")
                                .modifier(textStyle(size: 14))
                                .opacity(0.7)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                        }
                        
                        // Reset Button
                        VStack(spacing: 16) {
                            Button {
                                settings.gradingScale = GradingScale.defaultScale
                                settings.roundForLetterGrade = false
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
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Grading Scale")
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
                Text("Your grading scale preferences have been saved successfully.")
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

struct ToggleRowView: View {
    let title: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            Text(title)
                .font(.custom("ProductSans-Regular", size: 17))
                .foregroundColor(.white)
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .toggleStyle(SwitchToggleStyle(tint: .terCol))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
        .background(Color.black.opacity(0.3))
        .cornerRadius(16)
    }
}

struct GradeScaleCard: View {
    let label: String
    @Binding var value: Double
    
    var body: some View {
        HStack {
            Text(label)
                .font(.custom("ProductSans-Bold", size: 18))
                .foregroundColor(.white)
                .frame(width: 40, alignment: .leading)
            
            Spacer()
            
            HStack(spacing: 8) {
                TextField("", value: $value, format: .number.precision(.fractionLength(0...2)))
                    .keyboardType(.decimalPad)
                    .font(.custom("ProductSans-Regular", size: 16))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.trailing)
                    .frame(width: 60)
                
                Text("%")
                    .font(.custom("ProductSans-Regular", size: 16))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.black.opacity(0.5))
            .cornerRadius(8)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
        .background(Color.black.opacity(0.3))
        .cornerRadius(16)
    }
}

#Preview {
    GradingScaleSettingsView()
}
