//
//  ContentView.swift
//  voturecords
//
//  Created by Yannick Peysale on 07/09/2020.
//

import SwiftUI

struct ProductList: View {
    var products: [ProductListModel]
    
    var body: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(minimum: 20, maximum: 130)),
                GridItem(.flexible(minimum: 20, maximum: 130)),
                GridItem(.flexible(minimum: 20, maximum: 130))
            ],
            alignment: .leading,
            spacing: 20,
            pinnedViews: /*@START_MENU_TOKEN@*/[]/*@END_MENU_TOKEN@*/,
            content: {
                Text("Placeholder")
                Text("Placeholder")
                Text("Placeholder")
            }
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ProductList()
    }
}
