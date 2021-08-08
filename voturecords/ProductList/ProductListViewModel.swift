//
//  ProductListInteractor.swift
//  voturecords
//
//  Created by Yannick Peysale on 08/09/2020.
//

import Foundation

public enum ProductListState {
    case loading
    case loaded
    case error
}

public enum LoadingButtonState {
    case standard
    case loading
}

public class ProductListViewModel: ObservableObject {
    let productAPIRetriever: ProductAPIRetrieverProtocol
    @Published var state: ProductListState = .loading
    private var currentPage = 1
    @Published var products: [Product] = []
    @Published var loadingButtonState: LoadingButtonState = .standard
    
    init() {
        guard let retriever = voturecordsApp.container.resolve(ProductAPIRetrieverProtocol.self) else {
            NSLog("Couldn't resolve ProductRetriever : specifying a default one")
            self.productAPIRetriever = ProductAPIRetriever()
            return
        }
        self.productAPIRetriever = retriever
    }
    
    public func requestInitialProducts() {
        do {
            try self.productAPIRetriever.requestProducts(page: currentPage, completion: { [weak self] error, products in
                guard error == nil, let self = self else {
                    self?.state = .error
                    return
                }
                self.currentPage = self.currentPage + 1
                DispatchQueue.main.async {
                    self.state = .loaded
                    self.products = products
                }
            })
        } catch {
            NSLog("Interactor could not request products")
        }
    }
    
    public func loadMoreProducts() {
        DispatchQueue.main.async {
            self.loadingButtonState = .loading
        }
        do {
            try self.productAPIRetriever.requestProducts(page: currentPage, completion: { [weak self] error, products in
                guard error == nil, let self = self else {
                    self?.state = .error
                    return
                }
                self.currentPage = self.currentPage + 1
                DispatchQueue.main.async {
                    self.loadingButtonState = .standard
                    self.state = .loaded
                    self.products = self.products + products
                }
            })
        } catch {
            NSLog("Interactor could not request products")
        }
    }
}
