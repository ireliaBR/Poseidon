//
//  ShapePanel.swift
//  Poseidon
//
//  Created by fdd on 2024/1/31.
//

import SwiftUI

struct ShapePanel: View {
    
    @EnvironmentObject var messageViewModel: MessageViewModel
    @Binding var currentSelectedType: HomePanel.ButtonType
    @State var currentColor = UIColor.red
    
    let colorItems: [UIColor] = [
        .red, .green, .blue, .yellow, .orange, .purple, .cyan, .magenta,
        UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0), // 自定义灰色
        UIColor.systemTeal, // 系统的蓝绿色
        UIColor.systemPink, // 系统的粉红色
        UIColor(hue: 0.6, saturation: 0.8, brightness: 0.8, alpha: 1.0) // 自定义 HSB 颜色
    ]
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(colorItems, id: \.self) { item in
                        Button(action: {
                            currentColor = item
                        }, label: {
                            Color(item)
                        })
                        .cornerRadius(10)
                        .frame(width: 40, height: 40)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: currentColor == item ? 2 : 0) // 设置边框
                        )
                    }.padding(5)
                }.padding(10)
            }.scrollIndicators(.hidden)
            .frame(maxWidth: .infinity, maxHeight: 50)
            .background(.white)
            .compositingGroup()
            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        var element = ShapeElement.square()
                        element.color = currentColor
                        element.translate(tx: CanvasControl.screenWidth / 2 / element.screenScale, ty: CanvasControl.screenHeight / 2 / element.screenScale, tz: 0)
                        messageViewModel.element = element
                        withAnimation(.easeIn) {
                            currentSelectedType = .none
                        }
                    }) {
                        Image(systemName: "square.fill")
                            .font(.system(size: 60))
                            .foregroundColor(Color(uiColor: currentColor))
                    }
                    Spacer()
                    Button(action: {
                        var element = ShapeElement.triangle()
                        element.color = currentColor
                        element.translate(tx: CanvasControl.screenWidth / 2 / element.screenScale, ty: CanvasControl.screenHeight / 2 / element.screenScale, tz: 0)
                        messageViewModel.element = element
                        withAnimation(.easeIn) {
                            currentSelectedType = .none
                        }
                    }) {
                        Image(systemName: "triangle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(Color(uiColor: currentColor))
                    }
                    Spacer()
                }
                .padding()
                Spacer().frame(minHeight: 34)
            }
            .frame(maxWidth: .infinity, maxHeight: 134)
            .background(.white)
            .compositingGroup()
            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
        }
    }
}

struct ShapePanelTestView: View {
    
    @State var currentSelectedType: HomePanel.ButtonType = .none
    
    var body: some View {
        Spacer()
        ShapePanel(currentSelectedType: $currentSelectedType)
        .frame(maxWidth: .infinity, maxHeight: 134)
    }
}

#Preview {
    ShapePanelTestView()
}
