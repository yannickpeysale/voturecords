//
//  MockNetworkCallHelper.swift
//  voturecords
//
//  Created by Yannick Peysale on 25/12/2021.
//

import Foundation

/// Mock implementation of the NetworkCallHelper. This will be useful for checking error display or unit testing
public class MockNetworkCallHelper: NetworkCallHelper {
    public func sendAPICall(with urlPath: String, params: [String: String]?, completion: @escaping (APIReturnValue<Data>) -> Void) {
        guard let data = Data(base64Encoded: "{ id = 1033; link = \"http://www.deezer.com/artist/1033\"; name = \"Alain Souchon\"; }") else {
            return
        }
        completion(.success(data))
    }
}

