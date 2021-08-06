//
//  ProductDetails.swift
//  voturecords
//
//  Created by Yannick Peysale on 05/08/2021.
//

import SwiftUI

struct ProductDetails: View {
    var product: Product
    
    var body: some View {
        NavigationView() {
            VStack {
                Image("ingrina")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Text(product.shortDescription)
                Text("\(product.price)€")
                
            }
            .navigationBarTitle(product.name)
        }
    }
}

struct ProductDetails_Previews: PreviewProvider {
    static var previews: some View {
        ProductDetails(product: Product.makeTestProduct())
    }
}
