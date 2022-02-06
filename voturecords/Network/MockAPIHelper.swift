//
//  MockProductAPIRetriever.swift
//  voturecords
//
//  Created by Yannick Peysale on 05/08/2021.
//

import Foundation

/// Mock implementation of ProductAPIRetrieverProtocol. Returns a collection of 3 products
public class MockAPIHelper: APIHelper {
    
    public func requestProducts(
        page: Int,
        category: Category?,
        completion: @escaping ((APIReturnValue<[Product]>) -> Void)
    ) throws {
        completion(.success([
            Product(
                id: 11323,
                name: "Belka | Ermitage 12\"",
                catalogVisibility: .visible,
                description: "Bandcamp player",
                shortDescription: "screamo from Germany. On black or yellow 12\" vinyl",
                price: "10",
                purchasable: true,
                url: "https://google.com",
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
                url: "https://google.com",
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
                url: "https://google.com",
                images: [
                    ProductImage(
                        id: 11297,
                        src: "https://i0.wp.com/voturecords.com/wp-content/uploads/2021/06/drowningwithouranchors.jpeg?fit=1200%2C1135&ssl=1",
                        name: "drowningwithouranchors",
                        alt: ""
                    )
                ]
            )
        ]))
    }
    
    public func requestCategories(
        completion: @escaping ((APIReturnValue<[Category]>) -> Void)
    ) throws {
        completion(.success(
            [
                Category(id: 1, name: "Vinyl", parentId: 0, description: "vinyl records"),
                Category(id: 2, name: "12\"", parentId: 1, description: "12\" vinyl"),
                Category(id: 3, name: "7\"", parentId: 1, description: "7\" vinyl")
            ]
        )
        )
    }
    
    public func requestNews(completion: @escaping ((APIReturnValue<[News]>) -> Void)) {
        completion(.success(
            [
                News(
                    id: 1,
                    title: "Test news 1",
                    content: "Very important content",
                    link: "https://voturecords.com/toto",
                    image: "https://i0.wp.com/voturecords.com/wp-content/uploads/2021/07/discordvotu.jpeg?fit=1080%2C1080&ssl=1"
                )
            ]
        )
        )
    }
}
