//
//  ProductCell.swift
//  voturecords
//
//  Created by Yannick Peysale on 29/10/2022.
//

import SwiftUI
import CachedAsyncImage

struct ProductCell: View {
    var product: Product
    
    var body: some View {
        VStack(alignment: .center,
               spacing: 5) {
            CachedAsyncImage(url: URL(string: product.images.first!.src)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
            Text(product.name)
                .foregroundColor(Color.votuText)
                .font(.body)
                .fontWeight(.medium)
                .lineLimit(2)
                .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
            Spacer()
            Text("\(product.price)€")
                .font(.body)
                .fontWeight(.light)
                .foregroundColor(Color.votuText)
        }
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
        .background(Color.votuTint)
        .cornerRadius(5)
    }
}

struct ProductCell_Previews: PreviewProvider {
    static var previews: some View {
        ProductCell(product: Product.makeTestProduct())
    }
}
