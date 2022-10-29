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
        ZStack() {
            Color.votuBackground
                .ignoresSafeArea(.all)
            ScrollView() {
                VStack(spacing: 10) {
                    ProductImageSlider(images: product.images)
                        .frame(width: 300, height: 300, alignment: .center)
                    Text(product.name)
                        .font(.title)
                        .foregroundColor(Color.votuText)
                        .lineLimit(Int.max)
                        .fixedSize(horizontal: false, vertical: true)
                    Text(product.shortDescription.stripOutHtml()?.trimmingCharacters(in: CharacterSet(charactersIn: "\n")) ?? "")
                        .font(.body)
                        .foregroundColor(Color.votuText)
                        .padding()
//                        .border(Color.votuText)
                    Text("\(product.price)€")
                        .font(.body)
                        .foregroundColor(Color.votuText)
                        .bold()
                    OpenURLButton(title: "Listen / order", urlString: product.url)
                }
                .navigationBarTitle("Details")
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            }
        }
    }
}

struct ProductDetails_Previews: PreviewProvider {
    static var previews: some View {
        ProductDetails(product: Product.makeTestProduct())
    }
}
