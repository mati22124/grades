//
//  menuButtonAdd.swift
//  grades
//
//  Created by Mayank Tiku on 11/16/24.
//

import SwiftUI

struct menuButtonAdd: View {
    @Binding var isMenuPresented: Bool
    
    var menuItems: [menuItem]
    
    var body: some View {
        ZStack {
            if isMenuPresented {
                VStack {
                    Rectangle()
                        .fill(.primaryCol.opacity(0.2))
                        .background(.ultraThinMaterial)  // This creates the frosted glass effect
                        .ignoresSafeArea(edges: .all)
                        .onTapGesture {
                            withAnimation {
                                isMenuPresented = false
                            }
                        }
                }
                .transition(.opacity)
            }
            HStack {
                Spacer(minLength: 0)
                VStack(alignment: .menu, spacing: 0) {
                    Spacer(minLength: 0)
                    if isMenuPresented {
                        VStack(alignment: .trailing, spacing: 25) {
                            ForEach(menuItems) { item in
                                NavigationLink {
                                    AnyView(item.destination)
                                        .onAppear {
                                            withAnimation {
                                                isMenuPresented = false
                                            }
                                        }
                                } label: {
                                    HStack(spacing: 15) {
                                        Text(item.optionName)
                                            .foregroundStyle(.secCol)
                                            .font(.custom("ProductSans-Regular", size: 32))
                                        Image(systemName: item.icon)
                                            .resizable()
                                            .frame(width: 25, height: 25)
                                            .alignmentGuide(.menu) { dim in
                                                dim.width / 2
                                            }
                                    }
                                }
                            }
                        }
                        .padding()
                        .transition(.move(edge: .trailing).combined(with: .opacity))
                    }
                    Button {
                        withAnimation {
                            isMenuPresented.toggle()
                        }
                    } label: {
                        Circle()
                            .frame(width: 50, height: 50,alignment: .trailing)
                            .foregroundStyle(.terCol)
                            .overlay {
                                Image(systemName: "xmark")
                                    .foregroundStyle(.white)
                                    .fontWeight(.bold)
                            }
                            .rotationEffect(.degrees(isMenuPresented ? 0 : -45))
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                    .padding(.top, 10)
                }
            }
        }
    }
}

struct menuItem: Identifiable {
    var id: String = UUID().uuidString
    var destination: any View
    var optionName: String
    var icon: String
}

#Preview {
    @Previewable @State var isPresentedd: Bool = true
    menuButtonAdd(isMenuPresented: $isPresentedd, menuItems: [
        menuItem(destination: Text("hold on"), optionName: "test", icon: "gear"),
        menuItem(destination: Text("wait a minute"), optionName: "Add post", icon: "camera.aperture")
        ])
}
