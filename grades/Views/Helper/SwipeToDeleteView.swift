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
    let onEdit: any View
    @State private var offset: CGFloat = 0
    @State private var isSwiping = false
    private let deleteThreshold: CGFloat = -150
    
    init(@ViewBuilder content: () -> Content, onDelete: @escaping () -> Void, onEdit: any View) {
        self.content = content()
        self.onDelete = onDelete
        self.onEdit = onEdit
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
                            if(offset <= deleteThreshold && newOffset < 0) { // if u try to swipe left when ur swiped out it will snap back
                                offset = deleteThreshold
                                return
                            }
                            if(toff == 0 && offset < 0) { // if it wants to return and ur already swiped out
                                if newOffset+deleteThreshold > 0 { // if u have swiped past the end point, then just snap back to 0. dont allow swipe more right.
                                    self.offset = 0
                                    return
                                }
                                self.offset = newOffset+deleteThreshold //start going back
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
                ZStack {
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
                    
                    NavigationLink {
                        AnyView(onEdit)
                            .onAppear {
                                withAnimation {
                                    self.offset = 0
                                }
                            }
                    } label: {
                        RoundedRectangle(cornerRadius: 8)
                            .frame(width: 40, height: 40)
                            .foregroundStyle(.terCol)
                            .overlay {
                                Image(systemName: "pencil.line")//maybe do pencil no.line
                                    .foregroundStyle(.white)
                            }
                    }
                    .offset(x: 115+offset)
                }
                .frame(width: 0)
            }
        }
    }
}
