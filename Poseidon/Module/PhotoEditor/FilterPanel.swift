//
//  FilterPanel.swift
//  Poseidon
//
//  Created by fdd on 2024/2/4.
//

import SwiftUI

struct FilterPanel: View {
    
    @State var currentItem: FilterType = .default
    @State private var sliderValue: Float = 0.5
    
    @EnvironmentObject var messageViewModel: MessageViewModel
    
    var body: some View {
        VStack {
            if currentItem != .default {
                Slider(value: $sliderValue, in: 0...1)
                    .onChange(of: sliderValue) { oldValue, newValue in
                        messageViewModel.filterIntensity = sliderValue
                    }
            }
            ScrollView(.horizontal) {
                HStack {
                    ForEach(FilterType.allCases, id: \.self) { item in
                        Button(action: {
                            currentItem = item
                            messageViewModel.addFilter = item
                        }, label: {
                            Text(item.name)
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
