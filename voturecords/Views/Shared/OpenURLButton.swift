//
//  OpenURLButton.swift
//  voturecords
//
//  Created by Yannick Peysale on 05/02/2022.
//

import Foundation
import SwiftUI

struct OpenURLButton: View {
    @Environment(\.openURL) var openURL
    private let urlString: String
    private let title: String
    
    init(
        title: String,
        urlString: String
    ) {
        self.title = title
        self.urlString = urlString
    }
    
    var body: some View {
        Button(action: {
            openProduct(urlString)
        }) {
            Text(title)
        }
        .frame(width: 150, height: 40, alignment: .center)
        .background(Color.votuTint)
        .foregroundColor(Color.votuText)
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
