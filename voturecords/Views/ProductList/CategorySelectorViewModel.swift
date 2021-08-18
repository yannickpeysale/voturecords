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
    private let categoriesAPIRetriever: CategoriesAPIRetrieverProtocol
    
    @Published var categories: [Category] = []
    
    init() {
        guard let categoriesAPIRetriever = voturecordsApp.container.resolve(CategoriesAPIRetrieverProtocol.self) else {
            NSLog("Couldn't resolve ProductRetriever : specifying a default one")
            self.categoriesAPIRetriever = CategoriesAPIRetriever()
            return
        }
        
        self.categoriesAPIRetriever = categoriesAPIRetriever
    }
    
    public func getCategories() {
        do {
            try self.categoriesAPIRetriever.requestCategories { [weak self] error, categories in
                if error != nil {
                    NSLog("Error while retrieving categories \(String(describing: error))")
                    return
                }
                
                DispatchQueue.main.async {
                    self?.categories = categories
                }
            }
        } catch {
            NSLog("Error while retrieving categories \(error)")
        }
    }
}
