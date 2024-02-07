//
//  FilterPanel.swift
//  Poseidon
//
//  Created by fdd on 2024/2/4.
//

import SwiftUI


enum Filter {
    case gray
    case none
}

extension Filter {
    
    var filter: BaseFilter? {
        switch self {
        case .none:
            return nil
        case .gray:
            let vs = """
    #version 300 es
    layout (location = 0) in vec3 aPos;
    layout (location = 1) in vec2 aTexCoord;

    uniform mat4 projection;
    uniform mat4 model;

    out vec2 TexCoord;

    void main()
    {
        gl_Position = vec4(aPos, 1.0);
        TexCoord = aTexCoord;
    }
    """.utf8CString
            let fs = """
    #version 300 es
    precision mediump float;

    uniform sampler2D texture1;
    uniform float intensity;

    in vec2 TexCoord;
    out vec4 fragColor;
    const mediump vec3 LUMINANCE_FACTOR = vec3(0.2125, 0.7154, 0.0721);

    void main()
    {
        vec4 sampleColor = texture(texture1, TexCoord);
        float luminance = dot(sampleColor.rgb, LUMINANCE_FACTOR);
        fragColor = vec4(mix(vec3(luminance), sampleColor.rgb, 1.0 - intensity), 1.0);
    }

    """.utf8CString
            let vsPointer = vs.withUnsafeBufferPointer { UnsafePointer<CChar>($0.baseAddress) }
            let fsPointer = fs.withUnsafeBufferPointer { UnsafePointer<CChar>($0.baseAddress) }
            let gray = BaseFilter(vsPointer, fsPointer)
            return gray
        }
    }
}

struct FilterPanel: View {
    
    @State var currentItem: Filter = .none
    @State private var sliderValue: Float = 0.5
    
    @EnvironmentObject var messageViewModel: MessageViewModel
    
    let items: [Filter] = [.gray]
    
    var body: some View {
        VStack {
            if currentItem != .none {
                Slider(value: $sliderValue, in: 0...1)
                    .onChange(of: sliderValue) { oldValue, newValue in
                        var filter = Filter.gray.filter!
                        filter.filterValue = sliderValue
                        messageViewModel.addFilter = [filter]
                    }
            }
            ScrollView(.horizontal) {
                HStack {
                    ForEach(items, id: \.self) { item in
                        Button(action: {
                            currentItem = item
                            var filter = Filter.gray.filter!
                            filter.filterValue = sliderValue
                            messageViewModel.addFilter = [filter]
                        }, label: {
                            Color.gray
                        })
                        .cornerRadius(10)
                        .frame(width: 80, height: 80)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: currentItem == item ? 2 : 0) // 设置边框
                        )
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


struct FilterPanelView: View {
    
    var body: some View {
        Spacer()
        FilterPanel()
            .frame(maxWidth: .infinity, maxHeight: 134)
    }
}

#Preview {
    FilterPanelView()
}
