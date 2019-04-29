//
//  DownloadManager.swift
//  Flickr
//
//  Created by Hemant Singh on 30/04/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import UIKit

protocol ImageDownloader {
    func getImage(for url:URL, completion: @escaping (URL?, UIImage?) -> Swift.Void)
    func decreasePriority(url: URL)
    func clearCache()
}
class DownloadManager: ImageDownloader {

    let imageCache = NSCache<NSString, UIImage>()
    var callBacks: [String: (URL?, UIImage?) -> Swift.Void] = [:]
    var tasks : [String: URLSessionDataTask] = [:]
    static let sharedManager : DownloadManager = {
        let instance = DownloadManager()
        return instance
    }()
    
    func getImage(for url: URL, completion: @escaping (URL?, UIImage?) -> Void) {
        callBacks[url.absoluteString] = completion
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "GET"
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
//           "cache found:")
            callBacks[url.absoluteString]?(url, cachedImage)
        }
        else if let task = tasks[url.absoluteString] {
            //           Increase priority
            task.priority = URLSessionTask.highPriority
            task.resume()
        }
        else {
//          "cache not found:")
            var dataTask: URLSessionDataTask
            dataTask = URLSession.shared.dataTask(with: request, completionHandler: {  (data : Data?, response : URLResponse?, error :Error?) in
                if (error == nil && data != nil && data?.count != 0) {
                        if let urlString = response?.url?.absoluteString, let imageData = data, let image = UIImage(data: imageData){
                            DispatchQueue.main.async {
                            self.imageCache.setObject(image, forKey: urlString as NSString)
                            self.callBacks[urlString]?(url, image)
                            self.callBacks[urlString] = nil
                            self.tasks[urlString] = nil
                            }
                        }
                    }
                });
            tasks[url.absoluteString] = dataTask
            dataTask.resume()
        }
    }
    
    func decreasePriority(url: URL){
        tasks[url.absoluteString]?.priority = URLSessionTask.lowPriority
    }
    
    func clearCache() {
        imageCache.removeAllObjects()
    }
   
}
