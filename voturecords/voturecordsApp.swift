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
    
    @State var selectedTab = 0
    
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
        
        UITabBar.appearance().barTintColor = UIColor(Color.votuBackground)
        UITabBar.appearance().tintColor = UIColor.red
        UITabBar.appearance().isTranslucent = true
    }
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $selectedTab) {
                NewsView()
                    .tabItem {
                        Label("Latest news", systemImage: "list.dash")
                    }
                    .tag(0)
                ProductList()
                    .tabItem {
                        Label("Products", systemImage: "record.circle")
                    }
                    .tag(1)
                AboutView()
                    .tabItem {
                        Label("About", systemImage: "info.circle")
                    }
                    .tag(2)
            }
            .accentColor(Color.votuTint)
        }
    }
}
