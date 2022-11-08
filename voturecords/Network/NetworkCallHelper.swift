//
//  NetworkCallHelper.swift
//  voturecords
//
//  Created by Yannick Peysale on 25/12/2021.
//

import Foundation

/// Return value from the API
public enum APIReturnValue<T> {
    /// In case of success, returns the type T expected
    case success(T)
    /// In case of failure, returns the error
    case failure(Error)
}

/// Method for the API call
public enum APIMethod: String {
    /// GET API Method
    case get = "GET"
    /// POST API Method
    case post = "POST"
}

/// Protocol for generic API call sending
public protocol NetworkCallHelper {
    func sendAPICall(
        with url: String,
        method: APIMethod,
        params: [String: String]?,
        bodyParams: String?,
        completion: @escaping (APIReturnValue<Data>) -> Void
    )
}

/// Default implementation for API call sending, performing the call to the URL via URLRequest
public class DefaultNetworkCallHelper: NetworkCallHelper {
    /// Sends the API call to the backend
    /// @params:
    ///  - urlPath : a String containing the endpoint to call
    ///  - method :  API method (GET or POST)
    ///  - params : a Dictionary (String, String) of parameters to add to the endpoint
    ///  - bodyParams : a Dictionary (String, String) of parameters added to the body with x-www-form-urlencoded
    ///  - completion : a closure called at the end of the call. It will either return Data in case of success, or an error in case of failure
    public func sendAPICall(
        with urlPath: String,
        method: APIMethod,
        params: [String: String]?,
        bodyParams: String?,
        completion: @escaping (APIReturnValue<Data>) -> Void
    ) {
        var url: URL
        if let params = params {
            var urlComponents = URLComponents(string: urlPath)
            
            urlComponents?.queryItems = params.map({
                URLQueryItem(name: $0.key, value: $0.value)
            })
            
            guard let urlComponentsURL = urlComponents?.url else {
                completion(.failure(APIError.invalidURL))
                return
            }
            url = urlComponentsURL
        } else {
            guard let urlFromPath = URL(string: urlPath) else {
                completion(.failure(APIError.invalidURL))
                return
            }
            url = urlFromPath
        }
        
        let session = URLSession.shared

        // create the request
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let bodyParams = bodyParams {
            let data : Data = bodyParams.data(using: .utf8)!
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type");
            request.httpBody = data
        }
        
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if let error = error {
                NSLog(error.localizedDescription)
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                NSLog("Empty answer")
                completion(.failure(APIError.emptyAnswer))
                return
            }
            
            completion(.success(data))
        }
    
        task.resume()
    }
}

