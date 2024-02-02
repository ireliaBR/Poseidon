//
//  PhotoPanel.swift
//  Poseidon
//
//  Created by fdd on 2024/2/2.
//

import SwiftUI
import Photos

struct PhotoPanel: View {
    
    @EnvironmentObject var messageViewModel: MessageViewModel
    @Binding var currentSelectedType: HomePanel.ButtonType
    @State private var images: [UIImage] = []
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 3), spacing: 10) {
                ForEach(images, id: \.self) { item in
                    Button(action: {
                        withAnimation(.easeIn) {
                            currentSelectedType = .none
                        }
                    }, label: {
                        Image(uiImage: item)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .cornerRadius(5)
                    })
                }
            }
            .padding()
        }
        .scrollIndicators(.hidden)
        .background(.white)
        .compositingGroup()
        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
        .onAppear(perform: {
            Task {
                await fetchRecentPhotos()
            }
        })
    }
    
    func fetchRecentPhotos() async {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.fetchLimit = 50
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.deliveryMode = .highQualityFormat
        requestOptions.isSynchronous = false
        
        for index in 0..<fetchResult.count {
            let asset = fetchResult.object(at: index)
            
            let imageManager = PHImageManager.default()
            imageManager.requestImage(for: asset, targetSize: CGSize(width: 150, height: 150), contentMode: .aspectFill, options: requestOptions) { image, _ in
                if let image = image {
                    images.append(image)
                }
            }
        }
    }
}

struct PhotoPanelTestView: View {
    
    @State var currentSelectedType: HomePanel.ButtonType = .none
    
    var body: some View {
        Spacer()
        PhotoPanel(currentSelectedType: $currentSelectedType)
            .frame(maxWidth: .infinity, maxHeight: 134)
    }
}

#Preview {
    PhotoPanelTestView()
}
