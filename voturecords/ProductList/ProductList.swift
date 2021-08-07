//
//  ContentView.swift
//  voturecords
//
//  Created by Yannick Peysale on 07/09/2020.
//

import SwiftUI

public protocol ProductListProtocol {
    var productModels: ProductListViewModel { get set }
}

struct ProductCell: View {
    var product: Product
    
    var body: some View {
        HStack(alignment: .center,
               spacing: 10) {
            ProductImageView(image: product.images.first!)
                .imageScale(.small)
            Text(product.name)
            Spacer()
            Text("\(product.price)€")
                .fontWeight(.light)
        }
    }
}

struct ProductList: View, ProductListProtocol {
    @ObservedObject var productModels: ProductListViewModel = ProductListViewModel()
    
    init() {
        self.productModels.requestProducts()
    }
    
    var body: some View {
        switch productModels.state {
        case .loading:
            VStack() {
                Text("Loading products...")
                    .fontWeight(.light)
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            }
            
        case .loaded(let products):
            NavigationView() {
                ScrollView() {
                    VStack() {
                        ForEach((products), id: \.self) { product in
                            NavigationLink(destination: ProductDetails(product: product)) {
                                ProductCell(product: product)
                            }
                        }
                    }.padding()
                }
                .navigationTitle("Products")
            }
            
        case .error:
            Button(action: {
                productModels.requestProducts()
            }) {
                Image(systemName: "arrow.clockwise")
            }
            .frame(width: 40, height: 40, alignment: .center)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        guard let productList = voturecordsApp.container.resolve(ProductListProtocol.self) as? ProductList else {
            return ProductList()
        }
        return productList
    }
}
