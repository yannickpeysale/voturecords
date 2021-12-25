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
    let apiHelper: APIHelper
    @Published var state: ProductListState = .loading
    private(set) var currentPage = 1
    @Published var products: [Product] = []
    @Published var loadingButtonState: LoadingButtonState = .standard
    public var category: Category?
    
    /// Default page size is 10
    public static let pageSize = 10
    
    init() {
        guard let apiHelper = voturecordsApp.container.resolve(APIHelper.self) else {
            NSLog("Couldn't resolve ProductRetriever : specifying a default one")
            self.apiHelper = DefaultAPIHelper(networkCallHelper: DefaultNetworkCallHelper())
            return
        }
        self.apiHelper = apiHelper
    }
    
    /// Sends a first batch of products, using specified category
    public func requestInitialProducts() {
        DispatchQueue.main.async {
            self.state = .loading
        }
        do {
            self.currentPage = 1
            try self.apiHelper.requestProducts(
                page: currentPage,
                category: category,
                completion: { [weak self] returnValue in
                    guard let self = self else { return }
                    switch returnValue {
                    case .success(let products):
                        self.currentPage = self.currentPage + 1
                        DispatchQueue.main.async {
                            self.state = .loaded
                            self.products = products
                        }
                    case .failure:
                        self.state = .error
                    }
            })
        } catch {
            NSLog("Interactor could not request products")
            self.state = .error
        }
    }
    
    /// Appends a new batch of products to the previously retrieved products
    public func loadMoreProducts() {
        DispatchQueue.main.async {
            self.loadingButtonState = .loading
        }
        do {
            try self.apiHelper.requestProducts(
                page: currentPage,
                category: category,
                completion: { [weak self] returnValue in
                    guard let self = self else { return }
                    switch returnValue {
                    case .success(let products):
                        self.currentPage = self.currentPage + 1
                        DispatchQueue.main.async {
                            self.loadingButtonState = .standard
                            self.state = .loaded
                            self.products = self.products + products
                        }
                    case .failure:
                        self.state = .error
                    }
            })
        } catch {
            NSLog("Interactor could not request products")
            self.state = .error
        }
    }
}
