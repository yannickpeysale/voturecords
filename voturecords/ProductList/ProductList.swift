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
            ProductImageView(image: product.images.first!, shadow: true)
                .frame(width: 60)
            Text(product.name)
                .foregroundColor(.black)
                .fontWeight(.light)
            Spacer()
            Text("\(product.price)€")
                .fontWeight(.light)
                .foregroundColor(.gray)
        }
    }
}

struct LoadingButton: View {
    var buttonState: LoadingButtonState
    var buttonAction: ()->()
    
    init(
        buttonState: LoadingButtonState,
        buttonAction: @escaping () -> ()
    ) {
        self.buttonState = buttonState
        self.buttonAction = buttonAction
    }
    
    var body: some View {
        switch self.buttonState {
        case .standard:
            Button("Load more") {
                self.buttonAction()
            }
            .frame(width: 150, height: 40, alignment: .center)
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(Rectangle())
            .cornerRadius(10)
            
        case .loading:
            Button(action: {
                self.buttonAction()
            }) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            }
            .frame(width: 150, height: 40, alignment: .center)
            .background(Color.gray)
            .foregroundColor(.white)
            .clipShape(Rectangle())
            .cornerRadius(10)
        }
        
        
    }
}

struct ProductList: View, ProductListProtocol {
    @ObservedObject var productModels: ProductListViewModel = ProductListViewModel()
    
    init() {
        self.productModels.requestInitialProducts()
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
            
        case .loaded:
            NavigationView() {
                ScrollView() {
                    VStack() {
                        ForEach((productModels.products), id: \.self) { product in
                            NavigationLink(destination: ProductDetails(product: product)) {
                                ProductCell(product: product)
                            }
                        }
                        LoadingButton(
                            buttonState: self.productModels.loadingButtonState,
                            buttonAction: {
                                self.productModels.loadMoreProducts()
                            })
                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                    }
                    .padding()
                }
                .navigationTitle("Products")
            }
            
        case .error:
            Button(action: {
                productModels.requestInitialProducts()
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
