//
//  ProductImage.swift
//  voturecords
//
//  Created by Yannick Peysale on 05/08/2021.
//

import SwiftUI

struct ProductImageView: View {
    let image: ProductImage
    @ObservedObject var imageViewModel: ProductImageViewModel
    let shadow: Bool
    
    public init(image: ProductImage, shadow: Bool = false) {
        self.image = image
        self.shadow = shadow
        self.imageViewModel = ProductImageViewModel(image: image)
        self.imageViewModel.downloadImage()
    }
    
    var body: some View {
        switch imageViewModel.state {
        case .loading:
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
            
        case .loaded(let loadedImage):
            
            if self.shadow {
                Image(uiImage: loadedImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .shadow(radius: 3)
            } else {
                Image(uiImage: loadedImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
                
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
        ProductImageView(image: ProductImage(id: 1, src: "", name: "", alt: ""))
    }
}
