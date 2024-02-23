//
//  PhotoEditor.swift
//  Poseidon
//
//  Created by fdd on 2024/1/23.
//

import SwiftUI

struct PhotoEditor: View {
    
    @EnvironmentObject var messageViewModel: MessageViewModel
    @State var yOffset: CGFloat = 134
    @State var currentSelectedType: HomePanel.ButtonType = .none {
        didSet {
            withAnimation(.easeOut) {
                yOffset = currentSelectedType == .none ? 134 : 0
            }
        }
    }
    
    @State var imageOperate: ImageOperate = .none
    
    var body: some View {
        ZStack {
            VStack {
                CanvasView(tapAction: {
                    withAnimation(.easeIn) {
                        currentSelectedType = .none
                    }
                })
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                CanvasVieww()
                HomePanel { type in
                    withAnimation(.easeIn) {
                        currentSelectedType = type
                    }
                }
            }
            
            if let _ = messageViewModel.currentElement as? ImageElement {
                VStack {
                    Spacer()
                    FilterPanel()
                        .frame(maxWidth: .infinity, maxHeight: 134)
                        .background(.white)
                    
                }
            }
            if currentSelectedType == .shape {
                VStack {
                    Spacer()
                    ShapePanel(currentSelectedType: $currentSelectedType)
                    .frame(maxWidth: .infinity, maxHeight: 134)
                    .background(.white)
                    .offset(y: yOffset)
                    
                }
            }
            if currentSelectedType == .photo {
                VStack {
                    Spacer()
                    PhotoPanel(currentSelectedType: $currentSelectedType)
                    .frame(maxWidth: .infinity, maxHeight: 400)
                    .background(.white)
                    .offset(y: yOffset)
                    
                }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct HomePanel: View {
    
    @EnvironmentObject var messageViewModel: MessageViewModel
    let action: ((ButtonType) -> Void)
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                PhotoEditorButton(icon: "squareshape.fill", text: "形状") {
                    action(.shape)
                    messageViewModel.cancelSelected = true
                }
//                Spacer()
//                PhotoEditorButton(icon: "paintpalette.fill", text: "画笔") {
//                    action(.paint)
//                    messageViewModel.cancelSelected = true
//                }
                Spacer()
                PhotoEditorButton(icon: "photo.fill", text: "图片") {
                    action(.photo)
                    messageViewModel.cancelSelected = true
                }
                Spacer()
            }
            .frame(height: 50)
            Spacer()
        }
        .frame(height: 84)
        .background(.white)
        .compositingGroup()
        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
    }
    
    enum ButtonType {
        case shape
        case paint
        case photo
        case none
    }
}

struct PhotoEditorButton: View {
    let icon: String
    let text: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: icon)
                    .padding(3)
                    .foregroundColor(.black)
                Text(text)
                    .font(.subheadline)
                    .foregroundColor(.black)
            }
            .padding(10)
        }
    }
}

struct CanvasVieww: View {
    var body: some View {
        Color.red
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    PhotoEditor()
}
