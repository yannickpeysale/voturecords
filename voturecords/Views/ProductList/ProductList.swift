//
//  ContentView.swift
//  voturecords
//
//  Created by Yannick Peysale on 07/09/2020.
//

import SwiftUI

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
                Color.votuBackground
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
                ZStack() {
                    Color.votuBackground
                        .ignoresSafeArea(.all)
                    ScrollView() {
                        LazyVGrid(
                          columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                          ], spacing: 15
                        ) {
                            ForEach((productModels.products), id: \.self) { product in
                                NavigationLink(destination: ProductDetails(product: product)) {
                                    ProductCell(product: product)
                                }
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
