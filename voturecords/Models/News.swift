//
//  News.swift
//  voturecords
//
//  Created by Yannick Peysale on 26/12/2021.
//

import Foundation

/// News displayed in the store
public class News: Decodable, Hashable {
    /// News identifier
    public let id: Int
    /// Title of the news
    public let title: String
    /// Content of the news (in HTML format)
    public let content: String
    /// URL of the news on the website
    public let link: String
    /// URL of the image associated to the news
    public let image: String
    
    init(
        id: Int,
        title: String,
        content: String,
        link: String,
        image: String
    ) {
        self.id = id
        self.title = title
        self.content = content
        self.link = link
        self.image = image
    }
    
    public static func == (lhs: News, rhs: News) -> Bool {
        guard lhs.id == rhs.id else { return false }
    
        return true
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.link = try container.decode(String.self, forKey: .link)
        self.image = try container.decode(String.self, forKey: .image)
        
        let titleContainer = try container.nestedContainer(keyedBy: NestedCodingKeys.self, forKey: .title)
        self.title = try titleContainer.decode(String.self, forKey: .rendered).stripOutHtml()!
        
        let contentContainer = try container.nestedContainer(keyedBy: NestedCodingKeys.self, forKey: .content)
        self.content = try contentContainer.decode(String.self, forKey: .rendered)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case content
        case link
        case image = "jetpack_featured_media_url"
    }
    
    enum NestedCodingKeys: String, CodingKey {
        case rendered
    }
}

extension News {
    public class func makeTestNews() -> News {
        return News(
            id: 1,
            title: "Test news",
            content: "Coucou, bienvenue dans cette news de test",
            link: "https://voturecords.com/2021/07/02/join-the-discord-community/",
            image: "https://i0.wp.com/voturecords.com/wp-content/uploads/2021/07/discordvotu.jpeg?fit=1080%2C1080&ssl=1"
        )
    }
}
