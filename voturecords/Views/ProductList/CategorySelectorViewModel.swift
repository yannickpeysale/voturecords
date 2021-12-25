//
//  CategorySelectorViewModel.swift
//  voturecords
//
//  Created by Yannick Peysale on 11/08/2021.
//

import Foundation

/// View model used by the category selector ActionSheet view. Observable
///
/// - categoriesAPIRetriever : retrieved through dependency injection, allows to get all categories from the backend
/// Hint : inject a MockCategoriesAPIRetriever to get a test set of categories
public class CategorySelectorViewModel: ObservableObject {
    private let apiHelper: APIHelper
    
    @Published var categories: [Category] = []
    
    init() {
        guard let apiHelper = voturecordsApp.container.resolve(APIHelper.self) else {
            NSLog("Couldn't resolve ProductRetriever : specifying a default one")
            self.apiHelper = DefaultAPIHelper(networkCallHelper: DefaultNetworkCallHelper())
            return
        }
        
        self.apiHelper = apiHelper
    }
    
    public func getCategories() {
        do {
            try self.apiHelper.requestCategories { [weak self] returnValue in
                guard let self = self else { return }
                switch returnValue {
                case .success(let categories):
                    DispatchQueue.main.async {
                        self.categories = categories
                    }
                case .failure(let error):
                    NSLog("Error while retrieving categories \(String(describing: error))")
                }
            }
        } catch {
            NSLog("Error while retrieving categories \(error)")
        }
    }
}
