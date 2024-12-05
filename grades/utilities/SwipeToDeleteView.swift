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
                            // Allow dragging between 0 and deleteThreshold
                            let newOffset = gesture.translation.width
                            
                            let toff = min(0, max(deleteThreshold, newOffset))
                            if(toff == 0 && offset < 0) {
                                if newOffset+deleteThreshold > 0 {
                                    self.offset = 0
                                    return
                                }
                                self.offset = newOffset+deleteThreshold
                                return
                            }
                            self.offset = min(0, max(deleteThreshold, newOffset))
                        }
                        .onEnded { gesture in
                            withAnimation {
                                // If dragged more than halfway to threshold, snap to threshold
                                if offset < deleteThreshold/2 {
                                    self.offset = deleteThreshold
                                } else {
                                    self.offset = 0
                                }
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
