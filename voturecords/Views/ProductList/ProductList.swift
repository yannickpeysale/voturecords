//
//  ContentView.swift
//  voturecords
//
//  Created by Yannick Peysale on 07/09/2020.
//

import SwiftUI

struct ProductCell: View {
    var product: Product
    
    var body: some View {
        HStack(alignment: .center,
               spacing: 10) {
            ProductImageView(image: product.images.first!)
                .frame(width: 80, height: 80)
            Text(product.name)
                .foregroundColor(Color(UIColor.label))
                .font(.body)
                .fontWeight(.light)
                .lineLimit(3)
            Spacer()
            Text("\(product.price)€")
                .font(.body)
                .fontWeight(.light)
                .foregroundColor(Color(UIColor.label))
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
        .overlay(
            Rectangle()
                .stroke(Color.gray, lineWidth: 1)
        )
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
            .disabled(true)
        }
        
        
    }
}

struct ProductList: View {
    @ObservedObject var productModels: ProductListViewModel = ProductListViewModel()
    @ObservedObject var categoryViewModel: CategorySelectorViewModel = CategorySelectorViewModel()
    
    @State private var showingSortOrder = false
    @State private var animateLoading = false
    
    init() {
        self.productModels.requestInitialProducts()
        self.categoryViewModel.getCategories()
    }
    
    var body: some View {
        switch productModels.state {
        case .loading:
            ZStack() {
                Color(UIColor.systemBackground)
                    .ignoresSafeArea(.all)
                VStack() {
                    Image("logo")
                        .opacity(animateLoading ? 0.3 : 1)
                        .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: self.animateLoading)
                        .onAppear {
                            NSLog("Loading state appear")
                            self.animateLoading.toggle()
                        }
                    if let category = productModels.category {
                        Text("Loading \(category.name.lowercased())...")
                            .fontWeight(.light)
                            .multilineTextAlignment(.center)
                    } else {
                        Text("Loading all products...")
                            .fontWeight(.light)
                    }
                }
            }
            
        case .loaded:
            NavigationView() {
                ScrollView() {
                    VStack(spacing: 5) {
                        ForEach((productModels.products), id: \.self) { product in
                            NavigationLink(destination: ProductDetails(product: product)) {
                                ProductCell(product: product)
                            }
                        }
                        if productModels.products.count % ProductListViewModel.pageSize == 0 {
                            LoadingButton(
                                buttonState: self.productModels.loadingButtonState,
                                buttonAction: {
                                    self.productModels.loadMoreProducts()
                                })
                                .padding(EdgeInsets(top: 10, leading: 0, bottom: 5, trailing: 0))
                        }
                    }
                    .padding(5)
                }
                .navigationTitle("Products")
                .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                showingSortOrder.toggle()
                            } label: {
                                Label("Sort", systemImage: "arrow.up.arrow.down")
                            }
                            .disabled(categoryViewModel.categories.isEmpty)
                        }
                }
                .actionSheet(isPresented: $showingSortOrder) {
                    self.generateActionSheet()
                }
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
    
    func generateActionSheet() -> ActionSheet {
        let buttons = self.categoryViewModel.categories.map { category in
            Alert.Button.default(
                Text(category.name),
                action: {
                    self.productModels.category = category
                    self.productModels.requestInitialProducts()
                }
            )
        }
        return ActionSheet(title: Text("Select a category"),
                   buttons: buttons + [Alert.Button.cancel()])
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ProductList()
    }
}
