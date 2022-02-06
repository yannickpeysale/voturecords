//
//  AboutView.swift
//  voturecords
//
//  Created by Yannick Peysale on 05/02/2022.
//

import Foundation
import SwiftUI

struct AboutView: View {
    var body: some View {
        NavigationView() {
            ScrollView() {
                VStack(spacing: 10) {
                    Image("logo")
                    Text("Voice Of The Unheard Records")
                        .font(.title)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.center)
                    Text("DIY post-rock, post-hardcore, screamo, indie/punk vinyl record label / distro based in Bordeaux (FR), since 2013.")
                        .font(.body)
                        .padding()
                    Text("The goal is to help bands release their music on vinyl records, as well as producing beautiful objects that everyone will be happy to have in their collection.")
                        .font(.body)
                        .padding()
                    Link(destination: URL(string: "https://voturecords.com")!) {
                        Text("https://voturecords.com")
                    }
                    OpenURLButton(title: "Contact", urlString: "mailto:contact@voturecords.com")
                }
                .navigationBarTitle("About")
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            }
        }
        .navigationTitle("About")
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
