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
            Text(news.title)
                .foregroundColor(Color(UIColor.label))
                .font(.body)
                .fontWeight(.light)
                .multilineTextAlignment(.leading)
                .lineLimit(3)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
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
                    Text("Loading all news...")
                        .fontWeight(.light)
                }
            }
            
        case .loaded:
            NavigationView() {
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
            
        case .error:
            Button(action: {
                newsModels.requestNews()
            }) {
                Image(systemName: "arrow.clockwise")
            }
            .frame(width: 40, height: 40, alignment: .center)
        }
    }
}

struct NewsView_Previews: PreviewProvider {
    static var previews: some View {
        NewsView()
    }
}
