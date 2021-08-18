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
            ScrollView() {
                VStack(alignment: .leading, spacing: 10) {
                    ProductImageView(image: product.images.first!, shadow: true)
                    Text(product.name)
                        .font(.title)
                    Text(product.shortDescription)
                        .font(.body)
                    Text("\(product.price)€")
                        .font(.footnote)
                    
                }
                .navigationBarTitle("Details")
                .padding()
            }
    }
}

struct ProductDetails_Previews: PreviewProvider {
    static var previews: some View {
        ProductDetails(product: Product.makeTestProduct())
    }
}
