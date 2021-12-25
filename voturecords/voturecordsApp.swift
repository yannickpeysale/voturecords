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
    static var apiHelper: APIHelper?
    static var imageDownloader: ImageDownloaderProtocol?
    static var networkCallHelper: NetworkCallHelper?
    static var categoriesRetriever: CategoriesAPIRetrieverProtocol?
    
    init() {
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
        
        voturecordsApp.container.register(NetworkCallHelper.self, factory: { _ in
            if let networkCallHelper = voturecordsApp.networkCallHelper {
                return networkCallHelper
            } else {
                let networkCallHelper = DefaultNetworkCallHelper()
                voturecordsApp.networkCallHelper = networkCallHelper
                
                return networkCallHelper
            }
        })
        
        voturecordsApp.container.register(APIHelper.self, factory: { resolver in
            if let apiHelper = voturecordsApp.apiHelper {
                return apiHelper
            } else {
                guard let networkCallHelper = resolver.resolve(NetworkCallHelper.self) else {
                    return DefaultAPIHelper(networkCallHelper: DefaultNetworkCallHelper())
                }
                let apiHelper = DefaultAPIHelper(networkCallHelper: networkCallHelper)
                voturecordsApp.apiHelper = apiHelper
                
                return apiHelper
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
