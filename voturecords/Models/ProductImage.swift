//
//  ProductImage.swift
//  voturecords
//
//  Created by Yannick Peysale on 07/09/2020.
//

import Foundation

/// Image associated to a product
public class ProductImage: Decodable, Hashable {
    /// Image identifier
    public let id: Int
    /// Image source url
    public let src: String
    /// Image name
    public let name: String
    /// Image alternative text
    public let alt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case src
        case name
        case alt
    }
    
    init(
        id: Int,
        src: String,
        name: String,
        alt: String
    ) {
        self.id = id
        self.src = src
        self.name = name
        self.alt = alt
    }
    
    public static func == (lhs: ProductImage, rhs: ProductImage) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}
