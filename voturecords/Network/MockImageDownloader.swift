//
//  MockImageDownloader.swift
//  voturecords
//
//  Created by Yannick Peysale on 07/08/2021.
//

import Foundation
import UIKit

/// Mock implrementation of ImageDownloaderProtocol, returning directly one image stores in Assets
public class MockImageDownloader: ImageDownloaderProtocol {
    public func downloadImage(from url: URL, completion: @escaping (Data?, Error?) -> ()) {
        completion(UIImage(named: "ingrina")?.pngData(), nil)
        //completion(nil, APIError.emptyAnswer)
    }
}
