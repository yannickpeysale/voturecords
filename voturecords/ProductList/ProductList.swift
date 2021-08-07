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
            /*Image("ingrina")
                //.renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)*/
            Text(product.name)
                .bold()
            Spacer()
            Text("\(product.price)€")
        }
    }
}

struct ProductList: View, ProductListProtocol {
    @ObservedObject var productModels: ProductListViewModel = ProductListViewModel()
    
    init() {
        self.productModels.requestProducts()
    }
    
    var body: some View {
        NavigationView() {
            ScrollView() {
                VStack() {
                    ForEach((productModels.products), id: \.self) { product in
                        NavigationLink(destination: ProductDetails(product: product)) {
                            ProductCell(product: product)
                        }
                    }
                }.padding()
            }
            .navigationTitle("Products")
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
