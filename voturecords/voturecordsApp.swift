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
    
    init() {
        voturecordsApp.container.register(ProductAPIRetrieverProtocol.self, factory: { _ in
            if voturecordsApp.productRetriever == nil {
                voturecordsApp.productRetriever = MockProductAPIRetriever()
            }
            
            return voturecordsApp.productRetriever!
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
