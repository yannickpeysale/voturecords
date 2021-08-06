//
//  Product.swift
//  voturecords
//
//  Created by Yannick Peysale on 07/09/2020.
//

import Foundation

/// Visibility of a product :  visible, catalog, search and hidden
/// - visible : can be displayed
/// - catalog : ???
/// - search : ???
/// - hidden : do not display
public enum Visibility: String, Decodable {
    case visible = "visible"
    case catalog = "catalog"
    case search = "search"
    case hidden = "hidden"
}

/// Product available in the store
public class Product: Decodable, Hashable {
    /// Product identifier
    public let id: Int
    /// Product name
    public let name: String
    /// Visibility of the product
    public let catalogVisibility: Visibility
    /// Product description
    public let description: String
    /// Product short description
    public let shortDescription: String
    /// Product price
    public let price: String
    /// Product can be purchased
    public let purchasable: Bool
    /// Images associated to the product
    public let images: [ProductImage]
    
    init(
        id: Int,
        name: String,
        catalogVisibility: Visibility,
        description: String,
        shortDescription: String,
        price: String,
        purchasable: Bool,
        images: [ProductImage]
    ) {
        self.id = id
        self.name = name
        self.catalogVisibility = catalogVisibility
        self.description = description
        self.shortDescription = shortDescription
        self.price = price
        self.purchasable = purchasable
        self.images = images
    }
    
    public static func == (lhs: Product, rhs: Product) -> Bool {
        guard lhs.id == rhs.id else { return false }
    
        return true
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case catalogVisibility = "catalog_visibility"
        case description
        case shortDescription = "short_description"
        case price
        case purchasable
        case images
    }
}

extension Product {
    public class func makeTestProduct() -> Product {
        return Product(
            id: 1,
            name: "Test",
            catalogVisibility: .visible,
            description: "This is a test product",
            shortDescription: "test product",
            price: "100",
            purchasable: false,
            images: []
        )
    }
}
