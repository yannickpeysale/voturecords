//
//  ProductListInteractor.swift
//  voturecords
//
//  Created by Yannick Peysale on 08/09/2020.
//

import Foundation

public class ProductListViewModel: ObservableObject {
    let productAPIRetriever: ProductAPIRetrieverProtocol
    @Published var products: [Product] = []
    
    init() {
        guard let retriever = voturecordsApp.container.resolve(ProductAPIRetrieverProtocol.self) else {
            NSLog("Couldn't resolve ProductRetriever : specifying a default one")
            self.productAPIRetriever = ProductAPIRetriever()
            return
        }
        self.productAPIRetriever = retriever
    }
    
    public func requestProducts() {
        do {
            try self.productAPIRetriever.requestProducts(completion: { [weak self] error, products in
                guard error == nil else {
                    return
                }
                DispatchQueue.main.async {
                    self?.products = products
                }
            })
        } catch {
            NSLog("Interactor could not request products")
        }
    }
}
