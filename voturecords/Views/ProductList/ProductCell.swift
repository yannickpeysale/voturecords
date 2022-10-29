//
//  ProductCell.swift
//  voturecords
//
//  Created by Yannick Peysale on 29/10/2022.
//

import SwiftUI

struct ProductCell: View {
    var product: Product
    
    var body: some View {
        HStack(alignment: .center,
               spacing: 10) {
            ImageView(image: product.images.first!.src)
                .frame(width: 80, height: 80)
            Text(product.name)
                .foregroundColor(Color.votuText)
                .font(.body)
                .fontWeight(.light)
                .lineLimit(3)
            Spacer()
            Text("\(product.price)€")
                .font(.body)
                .fontWeight(.light)
                .foregroundColor(Color.votuText)
            Image(systemName: "chevron.right")
                .foregroundColor(Color.votuChevron)
        }
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
        .background(Color.votuTint)
        .cornerRadius(5)
    }
}

struct ProductCell_Previews: PreviewProvider {
    static var previews: some View {
        ProductCell(product: Product.makeTestProduct())
    }
}
