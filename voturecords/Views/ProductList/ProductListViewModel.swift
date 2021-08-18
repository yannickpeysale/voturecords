//
//  ProductListInteractor.swift
//  voturecords
//
//  Created by Yannick Peysale on 08/09/2020.
//

import Foundation

/// Different states for the product list
///
/// - loading : loading products for the selected category (default : none = all products)
/// - loaded : display all the products loaded
/// - error : error while fetching the products
public enum ProductListState {
    case loading
    case loaded
    case error
}

/// State of the loading button
///
/// - standard : normal state, displaying the button title
/// - loading : performing an action, showing an activity indicator
public enum LoadingButtonState {
    case standard
    case loading
}

/// View module to display product list. Observable to update view automatically with Combine
///
/// - productAPIRetriever : retrieved through dependency injection, handles API calls to retrieve products
/// Hint : inject a MockProductAPIRetriever to get a test set of products
/// - state : state of the view, as defined in ProductListState. Published
/// - currentPage : product retrieval is paginated, this counter automatically increments at each call. Reset to 1 at first call
/// - products : list of products retrieved from the API. Published
/// - loadiingButtonState : state of the button to load more product, as defined in LoadingButtonState. Published
/// - category : category for the products retrieved (optional, if nil retrieves all products)
public class ProductListViewModel: ObservableObject {
    let productAPIRetriever: ProductAPIRetrieverProtocol
    @Published var state: ProductListState = .loading
    private var currentPage = 1
    @Published var products: [Product] = []
    @Published var loadingButtonState: LoadingButtonState = .standard
    public var category: Category?
    
    init() {
        guard let retriever = voturecordsApp.container.resolve(ProductAPIRetrieverProtocol.self) else {
            NSLog("Couldn't resolve ProductRetriever : specifying a default one")
            self.productAPIRetriever = ProductAPIRetriever()
            return
        }
        self.productAPIRetriever = retriever
    }
    
    /// Sends a first batch of products, using specified category
    public func requestInitialProducts() {
        DispatchQueue.main.async {
            self.state = .loading
        }
        do {
            self.currentPage = 1
            try self.productAPIRetriever.requestProducts(
                page: currentPage,
                category: category,
                completion: { [weak self] error, products in
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
    
    /// Appends a new batch of products to the previously retrieved products
    public func loadMoreProducts() {
        DispatchQueue.main.async {
            self.loadingButtonState = .loading
        }
        do {
            try self.productAPIRetriever.requestProducts(
                page: currentPage,
                category: category,
                completion: { [weak self] error, products in
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
