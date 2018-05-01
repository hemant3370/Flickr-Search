//
//  PhotoManager.swift
//  Flickr
//
//  Created by Hemant Singh on 01/05/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import Foundation
import RxSwift
import Moya

let flickrApi    =  "https://api.flickr.com/services/rest"
let flickrMethod =  "flickr.photos.search"
let apiKeyValue  =  "0a6469c6785f136e439ac83048fe3b6e"
let limit        =  30

let methodKey =         "method"
let apiKey    =         "api_key"
let nojsoncallbackKey = "nojsoncallback"
let formatKey =         "format"
let safeSearchKey =     "safe_search"
let textKey =           "text"
let perPageKey =        "per_page"
let pageKey =           "page"
let format =            "format"

class PhotoManager {
    
    static func searchPhotos(forQuery searchText: String, page: Int,disposeBag: DisposeBag, completion: @escaping (_ photos: [Photo])->Void) -> Void {
        
        guard let encodedText = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        
        let parameters : [String: Any] = [
            methodKey:          flickrMethod,
            apiKey:             apiKeyValue,
            nojsoncallbackKey:  "1",
            formatKey:          "json",
            safeSearchKey:      "1",
            textKey:            encodedText,
            perPageKey:         limit,
            pageKey:            page
        ]
        TVAPIProvider.rx.request(.SEARCH(parameters)).subscribe {  event in
            switch event {
            case let .success(response):
                if let json = try? response.mapJSON(), let photosDict = (json as? [String: Any])?["photos"] as? [String: Any],
                let photosArray = photosDict["photo"] as? [[String:Any]] {
                   completion(photosArray.map({ Photo(with: $0) }))
                }
            case let .error(err):
                print(err)
                completion([])
                break
            }
            }.disposed(by: disposeBag)
    }
    
    
    
}
