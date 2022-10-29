//
//  NewsView.swift
//  voturecords
//
//  Created by Yannick Peysale on 05/08/2021.
//

import SwiftUI

struct NewsCell: View {
    var news: News
    
    var body: some View {
        HStack(alignment: .center,
               spacing: 10) {
            ImageView(image: news.image)
                .frame(width: 80, height: 80)
                .clipped()
            Text(news.title)
                .foregroundColor(Color.votuText)
                .font(.body)
                .fontWeight(.light)
                .multilineTextAlignment(.leading)
                .lineLimit(3)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(Color.votuChevron)
        }
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
        .background(Color.votuTint)
        .cornerRadius(5)
    }
}


struct NewsView: View {
    @ObservedObject var newsModels: NewsListViewModel = NewsListViewModel()
    
    @State private var animateLoading = false
    
    init() {
        self.newsModels.requestNews()
    }
    
    var body: some View {
        switch newsModels.state {
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
                    Text("Loading all news...")
                        .fontWeight(.light)
                }
            }
            
        case .loaded:
            NavigationView() {
                ZStack() {
                    Color.votuBackground
                        .ignoresSafeArea(.all)
                    ScrollView() {
                        VStack(spacing: 5) {
                            ForEach((newsModels.news), id: \.self) { news in
                                Link(destination: URL(string: news.link)!) {
                                    NewsCell(news: news)
                                }
                            }
                        }
                        .padding(5)
                    }
                    .navigationTitle("News")
                }
            }
            .foregroundColor(Color.votuText)
            
        case .error:
            ZStack() {
                Color.votuBackground
                    .ignoresSafeArea(.all)
                Button(action: {
                    newsModels.requestNews()
                }) {
                    Image(systemName: "arrow.clockwise")
                }
                .frame(width: 40, height: 40, alignment: .center)
            }
        }
    }
}

struct NewsView_Previews: PreviewProvider {
    static var previews: some View {
        NewsView()
    }
}
