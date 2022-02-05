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
    
    init() {
        voturecordsApp.container.register(ImageDownloaderProtocol.self, factory: { _ in
            ImageDownloader()
        })
        
        voturecordsApp.container.register(NetworkCallHelper.self, factory: { _ in
            DefaultNetworkCallHelper()
        })
        
        voturecordsApp.container.register(APIHelper.self, factory: { resolver in
            guard let networkCallHelper = resolver.resolve(NetworkCallHelper.self) else {
                return DefaultAPIHelper(networkCallHelper: DefaultNetworkCallHelper())
            }
            return DefaultAPIHelper(networkCallHelper: networkCallHelper)
        })
    }
    
    var body: some Scene {
        WindowGroup {
            TabView {
                NewsView()
                    .tabItem {
                        Label("Latest news", systemImage: "list.dash")
                    }
                ProductList()
                    .tabItem {
                        Label("Products", systemImage: "record.circle")
                    }
                AboutView()
                    .tabItem {
                        Label("About", systemImage: "info.circle")
                    }
            }
            
        }
    }
}
