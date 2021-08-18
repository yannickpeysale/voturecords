//
//  CategoriesAPIRetriever.swift
//  voturecords
//
//  Created by Yannick Peysale on 10/08/2021.
//

import Foundation

/// Protocol to implement to retrieve categories from the server
public protocol CategoriesAPIRetrieverProtocol {
    func requestCategories(
        completion: @escaping ((Error?, [Category]) -> Void)
    ) throws
}

/// Default implementation of CategoriesAPIRetrieverProtocol
public class CategoriesAPIRetriever: CategoriesAPIRetrieverProtocol {
    public func requestCategories(
        completion: @escaping ((Error?, [Category]) -> Void)
    ) throws {
        let session = URLSession.shared
        
        var categoriesURLComponents = URLComponents(string: "https://voturecords.com/wp-json/wc/v3/products/categories")
        
        categoriesURLComponents?.queryItems = [
            URLQueryItem(name: "per_page", value: "20")
        ]

        guard let categoriesURL = categoriesURLComponents?.url else {
            NSLog("Couldn't build categories URL")
            return
        }
        
        // create the request
        var request = URLRequest(url: categoriesURL)
        request.httpMethod = "GET"
        request.setValue("Basic \(APIAuthHelper.getAuthForRequest())", forHTTPHeaderField: "Authorization")
        
        
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
            guard let categories = try? jsonDecoder.decode([Category].self, from: data) else {
                NSLog("Couldn't parse answer, data has wrong format")
                completion(APIError.parsingError, [])
                return
            }
            
            completion(nil, categories)
        }
    
        task.resume()
    }
}
