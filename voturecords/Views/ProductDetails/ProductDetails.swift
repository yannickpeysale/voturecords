//
//  ProductDetails.swift
//  voturecords
//
//  Created by Yannick Peysale on 05/08/2021.
//

import SwiftUI

struct OpenURLButton: View {
    @Environment(\.openURL) var openURL
    private let urlString: String
    
    init(urlString: String) {
        self.urlString = urlString
    }
    
    var body: some View {
        Button(action: {
            openProduct(urlString)
        }) {
            Text("Listen / order")
        }
        .frame(width: 150, height: 40, alignment: .center)
        .background(Color.blue)
        .foregroundColor(.white)
        .clipShape(Rectangle())
        .cornerRadius(10)
    }

    func openProduct(_ urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        openURL(url)
    }
}

struct ProductDetails: View {
    var product: Product
    
    var body: some View {
        ScrollView() {
            VStack(spacing: 10) {
                ProductImageSlider(images: product.images)
                    .frame(width: 300, height: 300, alignment: .center)
                Text(product.name)
                    .font(.title)
                    .lineLimit(Int.max)
                    .fixedSize(horizontal: false, vertical: true)
                Text(product.shortDescription.stripOutHtml()?.trimmingCharacters(in: CharacterSet(charactersIn: "\n")) ?? "")
                    .font(.body)
                    .padding()
                    .border(Color(UIColor.label))
                Text("\(product.price)€")
                    .font(.body)
                    .bold()
                OpenURLButton(urlString: product.url)
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
