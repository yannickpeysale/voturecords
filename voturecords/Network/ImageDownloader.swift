//
//  ImageDownloader.swift
//  voturecords
//
//  Created by Yannick Peysale on 07/08/2021.
//

import Foundation

public protocol ImageDownloaderProtocol {
    func downloadImage(from url: URL, completion: @escaping (Data?, Error?) -> ())
}

public class ImageDownloader: ImageDownloaderProtocol {
    public func downloadImage(from url: URL, completion: @escaping (Data?, Error?) -> ()) {
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if let error = error {
                NSLog(error.localizedDescription)
                completion(nil, error)
                return
            }
            guard let data = data else {
                NSLog("Empty answer")
                completion(nil, APIError.emptyAnswer)
                return
            }
            
            completion(data, nil)
        }
        
        task.resume()
    }
}
