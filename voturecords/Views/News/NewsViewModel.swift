//
//  NewsViewModel.swift
//  voturecords
//
//  Created by Yannick Peysale on 26/12/2021.
//

import Foundation

/// Different states for the news list
///
/// - loading : loading news
/// - loaded : display all the news loaded
/// - error : error while fetching the news
public enum NewsListState {
    case loading
    case loaded
    case error
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
public class NewsListViewModel: ObservableObject {
    let apiHelper: APIHelper
    @Published var state: NewsListState = .loading
    @Published var news: [News] = []
    
    init() {
        guard let apiHelper = voturecordsApp.container.resolve(APIHelper.self) else {
            NSLog("Couldn't resolve ProductRetriever : specifying a default one")
            self.apiHelper = DefaultAPIHelper(networkCallHelper: DefaultNetworkCallHelper())
            return
        }
        self.apiHelper = apiHelper
    }
    
    /// Sends a first batch of products, using specified category
    public func requestNews() {
        DispatchQueue.main.async {
            self.state = .loading
        }
        do {
            try self.apiHelper.requestNews(
                completion: { [weak self] returnValue in
                    guard let self = self else { return }
                    switch returnValue {
                    case .success(let news):
                        DispatchQueue.main.async {
                            self.state = .loaded
                            self.news = news
                        }
                    case .failure:
                        self.state = .error
                    }
            })
        } catch {
            NSLog("Interactor could not request news")
            self.state = .error
        }
    }
}
