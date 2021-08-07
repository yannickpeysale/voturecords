//
//  ProductListInteractor.swift
//  voturecords
//
//  Created by Yannick Peysale on 08/09/2020.
//

import Foundation

public enum ProductListState {
    case loading
    case loaded([Product])
    case error
}

public class ProductListViewModel: ObservableObject {
    let productAPIRetriever: ProductAPIRetrieverProtocol
    //@Published var products: [Product] = []
    @Published var state: ProductListState = .loading
    
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
                    self?.state = .error
                    return
                }
                DispatchQueue.main.async {
                    self?.state = .loaded(products)
                }
            })
        } catch {
            NSLog("Interactor could not request products")
        }
    }
}
