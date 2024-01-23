//
//  PhotoEditor.swift
//  Poseidon
//
//  Created by fdd on 2024/1/23.
//

import SwiftUI

struct PhotoEditor: View {
    
    @State var isShowShapePanel: Bool = true
    @State var isShowPaintPanel: Bool = false
    @State var isShowPhotoPanel: Bool = false
    
    @State var yOffset: CGFloat = 134
    
    @State var currentSelectedType: HomePanel.ButtonType = .none {
        didSet {
            
        }
    }
    
    
    var body: some View {
        ZStack {
            VStack {
                Canvas()
                HomePanel { type in
                    currentSelectedType = type
                    withAnimation(.easeIn) {
                        yOffset = 0
                    }
                }
            }
            VStack {
                Button(action: {}) {
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                HStack {
                    Spacer()
                    Button(action: {}) {
                        Image(systemName: "square.fill")
                            .font(.system(size: 60))
                        
                    }
                    Spacer()
                    Button(action: {}) {
                        Image(systemName: "triangle.fill")
                            .font(.system(size: 60))
                        
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: 134)
                .background(.white)
                .offset(y: yOffset)
            }
            .opacity(isShowShapePanel ? 1.0 : 0.0)
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

struct Canvas: View {
    var body: some View {
        Color.red
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    PhotoEditor()
}
