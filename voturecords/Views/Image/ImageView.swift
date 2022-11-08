//
//  ProductImage.swift
//  voturecords
//
//  Created by Yannick Peysale on 05/08/2021.
//

import SwiftUI

struct ImageView: View {
    let image: String
    let contentMode: ContentMode
    @ObservedObject var imageViewModel: ImageViewModel
    
    public init(image: String, contentMode: ContentMode = .fill) {
        self.image = image
        self.contentMode = contentMode
        self.imageViewModel = ImageViewModel(image: image)
        self.imageViewModel.downloadImage()
    }
    
    var body: some View {
        switch imageViewModel.state {
        case .loading:
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
            
        case .loaded(let loadedImage):
            Image(uiImage: loadedImage)
                .resizable()
                .aspectRatio(contentMode: contentMode)
                
        case .error:
            Button(action: {
                imageViewModel.downloadImage()
            }) {
                Image(systemName: "arrow.clockwise")
            }
            .frame(width: 40, height: 40, alignment: .center)
        }
    }
}

struct ProductImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(image: "")
    }
}
