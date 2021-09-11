//
//  ProductImageSlider.swift
//  voturecords
//
//  Created by Yannick Peysale on 18/08/2021.
//

import SwiftUI

struct ProductImageSlider: View {
    var images: [ProductImage]
    
    init(images: [ProductImage]) {
        self.images = images
        UIPageControl.appearance().currentPageIndicatorTintColor = .label
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.label.withAlphaComponent(0.2)
    }
    
    var body: some View {
        if images.count > 1 {
            TabView {
                ForEach(images, id: \.self) { image in
                    ProductImageView(image: image)
                        .padding(EdgeInsets(top: 0, leading: 5, bottom: 40, trailing: 5))
                    
                }
            }
            .tabViewStyle(PageTabViewStyle())
            
        } else {
            ProductImageView(image: images.first!)
        }
    }
}

struct ProductImageSlider_Previews: PreviewProvider {
    static var previews: some View {
        ProductImageSlider(images: [])
    }
}
