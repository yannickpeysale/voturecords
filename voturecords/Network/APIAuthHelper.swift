//
//  APIAuthHelper.swift
//  voturecords
//
//  Created by Yannick Peysale on 14/08/2021.
//

import Foundation

/// Helper class for API calls
public class APIAuthHelper {
    /// Returns base64 encoded value for authenticating requests
    public static func getAuthForRequest() -> String {
        let username = "ck_b2c22b84112f8980e5a94dc7131a1166b469d5a4"
        let password = "cs_9f5ed385bcbf684edec5861c8fdfbaeceff2a968"
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        return loginData.base64EncodedString()
    }
    
}
