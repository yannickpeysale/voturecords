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
            VStack(spacing: 10) {
                ProductImageSlider(images: product.images)
                    .frame(width: 200, height: 200, alignment: .center)
                Text(product.name)
                    .font(.title)
                    .lineLimit(Int.max)
                    .fixedSize(horizontal: false, vertical: true)
                Text(product.shortDescription)
                    .font(.body)
                Text("\(product.price)€")
                    .font(.footnote)
                
            }
            .navigationBarTitle("Details")
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
        }
    }
}

struct ProductDetails_Previews: PreviewProvider {
    static var previews: some View {
        ProductDetails(product: Product.makeTestProduct())
    }
}
