//
//  voturecordsApp.swift
//  voturecords
//
//  Created by Yannick Peysale on 07/09/2020.
//

import SwiftUI
import Swinject

@main
struct voturecordsApp: App {
    static let container = Container()
    static var productRetriever: ProductAPIRetrieverProtocol?
    static var imageDownloader: ImageDownloaderProtocol?
    static var categoriesRetriever: CategoriesAPIRetrieverProtocol?
    
    init() {
        voturecordsApp.container.register(ProductAPIRetrieverProtocol.self, factory: { _ in
            if let productRetriever = voturecordsApp.productRetriever {
                return productRetriever
            } else {
                let productRetriever = ProductAPIRetriever()
                voturecordsApp.productRetriever = productRetriever
                
                return productRetriever
            }
        })
        
        voturecordsApp.container.register(ImageDownloaderProtocol.self, factory: { _ in
            if let imageDownloader = voturecordsApp.imageDownloader  {
                return imageDownloader
            } else {
                let imageDownloader = ImageDownloader()
                voturecordsApp.imageDownloader = imageDownloader
                
                return imageDownloader
            }
        })
        
        voturecordsApp.container.register(CategoriesAPIRetrieverProtocol.self, factory: { _ in
            if let categoriesRetriever = voturecordsApp.categoriesRetriever  {
                return categoriesRetriever
            } else {
                let categoriesRetriever = CategoriesAPIRetriever()
                voturecordsApp.categoriesRetriever = categoriesRetriever
                
                return categoriesRetriever
            }
        })
    }
    
    var body: some Scene {
        WindowGroup {
            TabView {
                ProductList()
                    .tabItem {
                        Label("Products", systemImage: "list.dash")
                    }
                
                NewsView()
                    .tabItem {
                        Label("News", systemImage: "square.and.pencil")
                    }
            }
            
        }
    }
}
