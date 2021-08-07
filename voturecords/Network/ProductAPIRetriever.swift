//
//  ProductRetriever.swift
//  voturecords
//
//  Created by Yannick Peysale on 07/09/2020.
//

import Foundation

public enum APIError: Error {
    case invalidURL
    case httpError(String)
    case parsingError
    case emptyAnswer
}

public protocol ProductAPIRetrieverProtocol {
    func requestProducts(completion: @escaping ((Error?, [Product]) -> Void)) throws
}

public class ProductAPIRetriever: NSObject, ProductAPIRetrieverProtocol {
    
    public func requestProducts(completion: @escaping((Error?, [Product]) -> Void)) throws {
        let session = URLSession.shared
        
        guard let productsURL = URL(string: "https://voturecords.com//wp-json/wc/v3/products") else {
            NSLog("Couldn't build url for products")
            throw APIError.invalidURL
        }
        
        let username = "ck_b2c22b84112f8980e5a94dc7131a1166b469d5a4"
        let password = "cs_9f5ed385bcbf684edec5861c8fdfbaeceff2a968"
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()

        // create the request
        var request = URLRequest(url: productsURL)
        request.httpMethod = "GET"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if let error = error {
                NSLog(error.localizedDescription)
                completion(error, [])
                return
            }
            guard let data = data else {
                NSLog("Empty answer")
                completion(APIError.emptyAnswer, [])
                return
            }
            NSLog(String(data: data, encoding: .utf8) ?? "Answer has incorrect encoding")
            let jsonDecoder = JSONDecoder()
            guard let products = try? jsonDecoder.decode([Product].self, from: data) else {
                NSLog("Couldn't parse answer, data has wrong format")
                completion(APIError.parsingError, [])
                return
            }
            
            completion(nil, products)
        }
    
        task.resume()
    }
}
