//
//  ProductImageViewModel.swift
//  voturecords
//
//  Created by Yannick Peysale on 05/08/2021.
//

import Foundation
import SwiftUI
import UIKit

/// The loading state of a product image
public enum ProductImageState {
    case loading
    case loaded(Image)
    case error
}

public class ProductImageViewModel: ObservableObject {
    @Published var state: ProductImageState
    let image: ProductImage
    let imageDownloader: ImageDownloaderProtocol
    
    public init(image: ProductImage) {
        self.state = .loading
        self.image = image
        guard let imageDownloader = voturecordsApp.container.resolve(ImageDownloaderProtocol.self) else {
            NSLog("Couldn't resolve ProductRetriever : specifying a default one")
            self.imageDownloader = ImageDownloader()
            return
        }
        self.imageDownloader = imageDownloader
    }
    
    public func downloadImage() {
        guard let url = URL(string: self.image.src) else {
            NSLog("Couldn't build url from image src : \(self.image.src)")
            self.state = .error
            return
        }
        
        self.imageDownloader.downloadImage(from: url) { [weak self] data, error in
            guard error == nil, let data = data, let uiImage = UIImage(data: data) else {
                self?.state = .error
                return
            }
            
            DispatchQueue.main.async {
                self?.state = .loaded(Image(uiImage: uiImage))
            }
        }
    }
}
