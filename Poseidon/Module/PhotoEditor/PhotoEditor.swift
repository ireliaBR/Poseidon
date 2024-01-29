//
//  PhotoEditor.swift
//  Poseidon
//
//  Created by fdd on 2024/1/23.
//

import SwiftUI

struct PhotoEditor: View {
    
    @State var yOffset: CGFloat = 134
    @State var currentSelectedType: HomePanel.ButtonType = .none {
        didSet {
            yOffset = currentSelectedType == .none ? 134 : 0
        }
    }
    
    
    var body: some View {
        ZStack {
            VStack {
                CanvasView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                HomePanel { type in
                    withAnimation(.easeIn) {
                        currentSelectedType = type
                    }
                }
            }
            VStack {
                Spacer()
                ShapePanel(currentSelectedType: $currentSelectedType)
                .frame(maxWidth: .infinity, maxHeight: 134)
                .background(.white)
                .offset(y: yOffset)
                
            }
            .opacity(currentSelectedType == .shape ? 1.0 : 0.0)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct HomePanel: View {
    
    let action: ((ButtonType) -> Void)
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                PhotoEditorButton(icon: "squareshape.fill", text: "形状") {
                    action(.shape)
                }
                Spacer()
                PhotoEditorButton(icon: "paintpalette.fill", text: "画笔") {
                    action(.paint)
                }
                Spacer()
                PhotoEditorButton(icon: "photo.fill", text: "图片") {
                    action(.photo)
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

struct ShapePanel: View {
    
    @Binding var currentSelectedType: HomePanel.ButtonType
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    withAnimation(.easeIn) {
                        currentSelectedType = .none
                    }
                }) {
                    Image(systemName: "square.fill")
                        .font(.system(size: 60))
                    
                }
                Spacer()
                Button(action: {
                    
                }) {
                    Image(systemName: "triangle.fill")
                        .font(.system(size: 60))
                    
                }
                Spacer()
            }
            .padding()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: 134)
        .background(.white)
        .compositingGroup()
        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
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

//struct CanvasVieww: View {
//    var body: some View {
//        Color.red
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//    }
//}

#Preview {
    PhotoEditor()
}
