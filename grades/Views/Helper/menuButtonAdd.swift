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
                    if #available(iOS 26.0, *) {
                        Rectangle()
                            .fill(.primaryCol.opacity(0.2))
                            .glassEffect(in: RoundedRectangle(cornerRadius: 0.1))
                            .environment(\.colorScheme, .dark)
                            .ignoresSafeArea(edges: .all)
                            .onTapGesture {
                                withAnimation {
                                    isMenuPresented = false
                                }
                            }
                    } else {
                        Rectangle()
                            .fill(.primaryCol.opacity(0.2))
                            .background(.ultraThinMaterial)  // This creates the frosted glass effect
                            .environment(\.colorScheme, .dark)
                            .ignoresSafeArea(edges: .all)
                            .onTapGesture {
                                withAnimation {
                                    isMenuPresented = false
                                }
                            }                    }
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
                                if let dest = item.destination {
                                    NavigationLink {
                                        AnyView(dest)
                                            .onAppear {
                                                withAnimation(Animation.linear.delay(0.5)) {
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
                                                .aspectRatio(contentMode: .fit)
                                                .frame(height: 25)
                                                .alignmentGuide(.menu) { dim in
                                                    dim.width / 2
                                                }
                                        }
                                    }
                                }
                                
                                if let act = item.action {
                                    Button {
                                        if !item.isAnimated {
                                            act()
                                        }
                                        withAnimation {
                                            if item.isAnimated {
                                                act()
                                            }
                                            isMenuPresented = false
                                        }
                                    } label: {
                                        HStack(spacing: 15) {
                                            Text(item.optionName)
                                                .foregroundStyle(.secCol)
                                                .font(.custom("ProductSans-Regular", size: 32))
                                            Image(systemName: item.icon)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(height: 25)
                                                .alignmentGuide(.menu) { dim in
                                                    dim.width / 2
                                                }
                                        }
                                    }
                                }
                                
                            }
                        }
                        .padding()
                        .transition(.move(edge: .trailing).combined(with: .opacity))
                    }
                    if #available(iOS 26.0, *) {
                        Button {
                            withAnimation {
                                isMenuPresented.toggle()
                            }
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundStyle(.white)
                                .fontWeight(.bold)
                                .padding(15)
                            .rotationEffect(.degrees(isMenuPresented ? 0 : -45))
                        }
                        .buttonStyle(.glass)
                        .padding(.horizontal)
                        .padding(.bottom)
                        .padding(.top, 10)
                    } else {
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
}

struct menuItem: Identifiable {
    var id: String = UUID().uuidString
    var destination: (any View)?
    var action: (() -> Void)?
    var optionName: String
    var icon: String
    
    var isAnimated: Bool = false
    
    init(destination: any View, optionName: String, icon: String) {
        self.destination = destination
        self.optionName = optionName
        self.icon = icon
    }
    
    init(action: @escaping () -> Void, optionName: String, icon: String, isAnimated: Bool = false) {
        self.action = action
        self.optionName = optionName
        self.icon = icon
        self.isAnimated = isAnimated
    }
}

#Preview {
    @Previewable @State var isPresentedd: Bool = true
    ZStack {
        Color.primaryCol.ignoresSafeArea()
        Text("hello")
        menuButtonAdd(isMenuPresented: $isPresentedd, menuItems: [
            menuItem(destination: Text("hold on"), optionName: "test", icon: "gear"),
            menuItem(destination: Text("wait a minute"), optionName: "Add post", icon: "camera.aperture")
        ])
    }
}
