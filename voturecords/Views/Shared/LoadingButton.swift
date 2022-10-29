//
//  LoadingButton.swift
//  voturecords
//
//  Created by Yannick Peysale on 29/10/2022.
//

import SwiftUI

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
            .background(Color.votuTint)
            .foregroundColor(.votuText)
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

struct LoadingButton_Previews: PreviewProvider {
    static var previews: some View {
        LoadingButton(buttonState: .loading, buttonAction: {})
        LoadingButton(buttonState: .standard, buttonAction: {})
    }
}
