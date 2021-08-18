//
//  MockCategoriesAPIRetriever.swift
//  voturecords
//
//  Created by Yannick Peysale on 10/08/2021.
//

import Foundation

/// Mock implementation of CategoriesAPIRetrieverProtocol returning 3 categories
public class MockCategoriesAPIRetriever: CategoriesAPIRetrieverProtocol {
    public func requestCategories(
        completion: @escaping ((Error?, [Category]) -> Void)
    ) throws {
        completion(nil, [
            Category(id: 1, name: "Vinyl", parentId: 0, description: "vinyl records"),
            Category(id: 2, name: "12\"", parentId: 1, description: "12\" vinyl"),
            Category(id: 3, name: "7\"", parentId: 1, description: "7\" vinyl")
        ]
        )
    }
}
