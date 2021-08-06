//
//  MockProductAPIRetriever.swift
//  voturecords
//
//  Created by Yannick Peysale on 05/08/2021.
//

import Foundation

public class MockProductAPIRetriever: ProductAPIRetrieverProtocol {
    
    public func requestProducts(completion: @escaping ((Error?, [Product]) -> Void)) throws {
        completion(nil, [
            Product(
                id: 11323,
                name: "Belka | Ermitage 12\"",
                catalogVisibility: .visible,
                description: "Bandcamp player",
                shortDescription: "screamo from Germany. On black or yellow 12\" vinyl",
                price: "10",
                purchasable: true,
                images: [
                    ProductImage(
                        id: 11324,
                        src: "https://i2.wp.com/voturecords.com/wp-content/uploads/2021/07/belka.jpeg?fit=1200%2C1200&ssl=1",
                        name: "belka",
                        alt: ""
                    )
                ]
            ),
            Product(
                id: 11321,
                name: "Kafka / Junior Leagues / Virginia Of Duty / TDOAFS | Split 12\"",
                catalogVisibility: .visible,
                description: "Bandcamp player",
                shortDescription: "screamo from Czech Republic, Russia, Malaisia and Canada. On black 12\" vinyl",
                price: "10",
                purchasable: true,
                images: [
                    ProductImage(
                        id: 11322,
                        src: "https://i2.wp.com/voturecords.com/wp-content/uploads/2021/07/kafkasplit.jpeg?fit=1200%2C1199&ssl=1",
                        name: "kafkasplit",
                        alt: ""
                    )
                ]
            ),
            Product(
                id: 11296,
                name: "Drowning With Our Anchors | You Can Never Go Home Again 12\"",
                catalogVisibility: .visible,
                description: "Bandcamp player",
                shortDescription: "emo from the US. On black 12\" vinyl",
                price: "10",
                purchasable: true,
                images: [
                    ProductImage(
                        id: 11297,
                        src: "https://i0.wp.com/voturecords.com/wp-content/uploads/2021/06/drowningwithouranchors.jpeg?fit=1200%2C1135&ssl=1",
                        name: "drowningwithouranchors",
                        alt: ""
                    )
                ]
            )
        ])
    }
    
    
}
