//
//  ProductImageViewModel.swift
//  voturecords
//
//  Created by Yannick Peysale on 05/08/2021.
//

import Foundation

/// The loading state of a product image
public enum ProductImageState {
    case loading
    case loaded(String)
    case error
}

public class ProductImageViewModel: ObservableObject {
    @Published var state: ProductImageState
    let image: ProductImage
    
    public init(image: ProductImage) {
        self.state = .loading
        self.image = image
    }
}
