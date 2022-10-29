//
//  Category.swift
//  voturecords
//
//  Created by Yannick Peysale on 10/08/2021.
//

import Foundation

/// Category of the product available in the store
public class Category: Decodable, Hashable {
    /// Category identifier
    public let id: Int
    /// Category name
    public let name: String
    /// Id of the parent category
    public let parentId: Int
    /// Category description
    public let description: String
    /// Number of products in category
    public let count: Int
    
    init(
        id: Int,
        name: String,
        parentId: Int,
        description: String,
        count: Int
    ) {
        self.id = id
        self.name = name
        self.parentId = parentId
        self.description = description
        self.count = count
    }
    
    public static func == (lhs: Category, rhs: Category) -> Bool {
        guard lhs.id == rhs.id else { return false }
    
        return true
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case parentId = "parent"
        case description
        case count
    }
}
