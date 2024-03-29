//
//  APIHelper.swift
//  voturecords
//
//  Created by Yannick Peysale on 07/09/2020.
//

import Foundation

/// All the errors that can happen in an API call
public enum APIError: Error {
    /// URL used is invalid
    case invalidURL
    /// Error while parsing the answer from the backend
    case parsingError
    /// Answer from the back is empty
    case emptyAnswer
    
    /// Description message for the error
    public var localizedDescription: String {
        switch self {
        case .emptyAnswer:
            return "Backend returned an empty answer"
        case .invalidURL:
            return "Invalid URL : please verify the URL you specified"
        case .parsingError:
            return "Answer returned from the backend couldn't be parsed"
        }
    }
    
}

/// Protocol for all API calls
public protocol APIHelper {
    func requestProducts(
        page: Int,
        category: Category?,
        completion: @escaping ((APIReturnValue<[Product]>) -> Void)
    ) throws
    
    func requestCategories(
        completion: @escaping ((APIReturnValue<[Category]>) -> Void)
    ) throws
    
    func requestNews(
        completion: @escaping ((APIReturnValue<[News]>) -> Void)
    ) throws
    
    func registerPushNotifications(
        with token: String,
        completion: @escaping ((APIReturnValue<Void>) -> Void)
    )
}

/// Default implementation for APIHelper, performing calls to the Deezer API
public class DefaultAPIHelper: APIHelper {
    private var networkCallHelper: NetworkCallHelper
    
    init(networkCallHelper: NetworkCallHelper) {
        self.networkCallHelper = networkCallHelper
    }
    
    /// Requests products from the backend
    ///  @param :
    ///     - page : the number of the page to select product from (0 to start from the beginning)
    ///     - category : (optional) the category of the products to search  (if none, searches in all products)
    ///     - completion : a completion called at the end of the process, called with either the error that happened or an array of Product
    public func requestProducts(
        page: Int,
        category: Category?,
        completion: @escaping((APIReturnValue<[Product]>) -> Void)
    ) throws {
        // page: parameter to know which batch of products to retrieve
        // per_page: number of products per batch
        var params: [String: String] = [:]
        params["page"] = "\(page)"
        params["stock_status"] = "instock"
        params["status"] = "publish"
        
        if let category = category {
            params["category"] = "\(category.id)"
        }
        
        self.networkCallHelper.sendAPICall(
            with: VOTUURL.productsURL,
            method: .get,
            params: params,
            bodyParams: nil
        ) { returnValue in
                switch returnValue {
                case .success(let data):
                    Log(String(data: data, encoding: .utf8) ?? "Answer has incorrect encoding")
                    let jsonDecoder = JSONDecoder()
                    
                    guard let products = try? jsonDecoder.decode([Product].self, from: data) else {
                        NSLog("Couldn't parse answer, data has wrong format")
                        completion(.failure(APIError.parsingError))
                        return
                    }
                    
                    completion(.success(products))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        
    }
    
    /// Requests the list of the categories from the backend
    ///  @param :
    ///     - completion : a completion called at the end of the process, called with either the error that happened or an array of Category
    public func requestCategories(
        completion: @escaping ((APIReturnValue<[Category]>) -> Void)
    ) throws {
        var params: [String: String] = [:]
        params["per_page"] = "30"
        
        self.networkCallHelper.sendAPICall(
            with: VOTUURL.categoriesURL,
            method: .get,
            params: params,
            bodyParams: nil
        ) { returnValue in
                switch returnValue {
                case .success(let data):
                    NSLog(String(data: data, encoding: .utf8) ?? "Answer has incorrect encoding")
                    let jsonDecoder = JSONDecoder()
                    
                    guard let categories = try? jsonDecoder.decode([Category].self, from: data) else {
                        NSLog("Couldn't parse answer, data has wrong format")
                        completion(.failure(APIError.parsingError))
                        return
                    }
                    
                    completion(.success(categories))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    public func requestNews(
        completion: @escaping ((APIReturnValue<[News]>) -> Void)
    ) throws {
        var params: [String: String] = [:]
        params["per_page"] = "20"
        
        self.networkCallHelper.sendAPICall(
            with: VOTUURL.newsURL,
            method: .get,
            params: params,
            bodyParams: nil
        ) { returnValue in
                switch returnValue {
                case .success(let data):
                    NSLog(String(data: data, encoding: .utf8) ?? "Answer has incorrect encoding")
                    let jsonDecoder = JSONDecoder()
                    
                    guard let news = try? jsonDecoder.decode([News].self, from: data) else {
                        NSLog("Couldn't parse answer, data has wrong format")
                        completion(.failure(APIError.parsingError))
                        return
                    }
                    
                    completion(.success(news))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    public func registerPushNotifications(
        with token: String,
        completion: @escaping ((APIReturnValue<Void>) -> Void)
    ) {

        
        self.networkCallHelper.sendAPICall(
            with: VOTUURL.pushRegistrationURL,
            method: .post,
            params: nil,
            bodyParams: "token=\(token)&os=iOS"
        ) { returnValue in
                switch returnValue {
                case .success:
                    completion(.success(Void()))
                case .failure(let error):
                    completion(.failure(error))
                    
                }
            }
    }
}


func Log(_ format:String, _ args:CVarArg...) {
    let output = withVaList(args, { (p) -> NSString in
        NSString(format: format, arguments: p)
    }) as String
    print( output )
}
