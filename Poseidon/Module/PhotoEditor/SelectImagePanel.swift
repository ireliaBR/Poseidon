//
//  SelectImagePanel.swift
//  Poseidon
//
//  Created by fdd on 2024/2/4.
//

import SwiftUI

enum ImageOperate {
    case filter
    case none
}

extension ImageOperate {
    var icon: UIImage {
        switch self {
        case .none:
            UIImage(systemName: "camera.filters")!
        case .filter:
            UIImage(systemName: "camera.filters", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40))!.withTintColor(.gray)
        }
    }
    
    var text: String {
        switch self {
        case .none:
            ""
        case .filter:
            "滤镜"
        }
    }
}

struct SelectImagePanel: View {
    
    let items: [ImageOperate] = [.filter]
    let itemAction: ((ImageOperate) -> Void)?
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(items, id: \.self) { item in
                        Button(action: {
                            itemAction?(item)
                        }, label: {
                            VStack {
                                Image(uiImage: item.icon)
                                Text(item.text)
                                    .foregroundColor(.gray)
                            }
                        })
                        .cornerRadius(10)
                        .frame(width: 80, height: 80)
                    }.padding(10)
                }
            }
            .scrollIndicators(.hidden)
            .padding(10)
            Spacer().frame(minHeight: 34)
        }
        .frame(maxWidth: .infinity, maxHeight: 134)
        .background(.white)
        .compositingGroup()
        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
    }
}


struct SelectImagePanelView: View {
    
    var body: some View {
        Spacer()
        SelectImagePanel(itemAction: {_ in })
            .frame(maxWidth: .infinity, maxHeight: 134)
    }
}

#Preview {
    SelectImagePanelView()
}
