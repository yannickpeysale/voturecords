//
//  Image.swift
//  voturecords
//
//  Created by Yannick Peysale on 07/09/2020.
//

import Foundation

/// Image associated to a product
public class ProductImage: Decodable {
    /// Image identifier
    public let id: String
    /// Image source url
    public let src: String
    /// Image name
    public let name: String
    /// Image alternative text
    public let alt: String
}
