//
//  SwipeToDeleteView.swift
//  grades
//
//  Created by Mayank Tiku on 11/16/24.
//
import SwiftUI

struct SwipeToDeleteView<Content: View>: View {
    let content: Content
    let onDelete: () -> Void
    @State private var offset: CGFloat = 0
    @State private var isSwiping = false
    private let deleteThreshold: CGFloat = -75
    
    init(@ViewBuilder content: () -> Content, onDelete: @escaping () -> Void) {
        self.content = content()
        self.onDelete = onDelete
    }
    
    var body: some View {
        HStack {
            
            // Content
            content
                .offset(x: offset)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            // Prevent swipe to the right in default position
                            if offset == 0 && gesture.translation.width > 0 {
                                return
                            }
                            
                            // Prevent drag more than deleteThreshold points
                            if gesture.translation.width < deleteThreshold {
                                return
                            }
                            
                            // Prevent swipe againt to the left if it's already swiped
                            if offset == deleteThreshold && gesture.translation.width < 0 {
                                return
                            }
                            
                            // If view already swiped to the left and we start dragging to the right
                            // Firstly will check if it's swiped left
                            if offset >= deleteThreshold {
                                // And here checking if swiped to the right more than swipeRightLimit points
                                // If more - need to set the view to zero position
                                if gesture.translation.width > 0 {
                                    self.offset = 0
                                    return
                                }
                                
                                // Check if only swiping to the right - update distance by minus deleteThreshold points
                                if offset != 0 && gesture.translation.width > 0 {
                                    self.offset = deleteThreshold + gesture.translation.width
                                    return
                                }
                            }
                                
                            self.offset = gesture.translation.width
                        }
                        .onEnded { gesture in
                            withAnimation {
                                // Left swipe handle:
                                if self.offset < -30 {
                                    self.offset = deleteThreshold
                                    return
                                }
                                if self.offset < deleteThreshold {
                                    self.offset = deleteThreshold
                                    return
                                }
                                
                                // Right swipe handle:
                                if gesture.translation.width > 30 {
                                    self.offset = 0
                                    return
                                }
                                if gesture.translation.width < 30 {
                                    self.offset = deleteThreshold
                                    return
                                }
                                
                                self.offset = 0
                            }
                        }
                )
            Group {
                Button(action: {
                    onDelete()
                }) {
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: 40, height: 40)
                        .foregroundStyle(.terCol)
                        .overlay {
                            Image(systemName: "xmark")
                                .foregroundStyle(.white)
                        }
                }
                .offset(x: 40+offset)
            }.frame(width: 0)
        }
    }
}
