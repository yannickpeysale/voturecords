//
//  ProductImageViewModel.swift
//  voturecords
//
//  Created by Yannick Peysale on 05/08/2021.
//

import Foundation
import UIKit

/// The loading state of a product image
public enum ProductImageState {
    case loading
    case loaded(UIImage)
    case error
}

/// View model for a product image
/// - state : loading state of the image
/// - image : object containing all the info for the image
/// - imageDownloader : injected, allows to retrieve image info (use a MockImageDownloader for testing)
public class ImageViewModel: ObservableObject {
    @Published var state: ProductImageState
    let image: String
    let imageDownloader: ImageDownloaderProtocol
    
    public init(image: String) {
        self.state = .loading
        self.image = image
        guard let imageDownloader = voturecordsApp.container.resolve(ImageDownloaderProtocol.self) else {
            NSLog("Couldn't resolve ProductRetriever : specifying a default one")
            self.imageDownloader = ImageDownloader()
            return
        }
        self.imageDownloader = imageDownloader
    }
    
    // downloads image from the model source, and updates the state accordingly
    public func downloadImage() {
        guard let url = URL(string: image) else {
            NSLog("Couldn't build url from image src : \(image)")
            self.state = .error
            return
        }
        
        self.imageDownloader.downloadImage(from: url) { [weak self] data, error in
            guard error == nil, let data = data, let uiImage = UIImage(data: data) else {
                self?.state = .error
                return
            }
            
            DispatchQueue.main.async {
                self?.state = .loaded(uiImage)
            }
        }
    }
}
