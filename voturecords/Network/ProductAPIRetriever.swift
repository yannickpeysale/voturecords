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
    func requestProducts(
        page: Int,
        category: Category?,
        completion: @escaping ((Error?, [Product]) -> Void)
    ) throws
}

public class ProductAPIRetriever: NSObject, ProductAPIRetrieverProtocol {
    // page: parameter to know which batch of products to retrieve
    // per_page: number of products per batch
    public func requestProducts(
        page: Int,
        category: Category?,
        completion: @escaping((Error?, [Product]) -> Void)
    ) throws {
        let session = URLSession.shared
        
        var productsURLComponents = URLComponents(string: VOTUURL.productsURL)
        
        productsURLComponents?.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "stock_status", value: "instock")
        ]
        
        if let category = category {
            productsURLComponents?.queryItems?.append(
                URLQueryItem(name: "category", value: "\(category.id)")
            )
        }
        
        guard let productsURL = productsURLComponents?.url else {
           NSLog("Couldn't build url for products")
           throw APIError.invalidURL
       }

        // create the request
        var request = URLRequest(url: productsURL)
        request.httpMethod = "GET"
        
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
