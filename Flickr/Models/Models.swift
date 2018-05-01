//
//  Models.swift
//  Flickr
//
//  Created by Hemant Singh on 30/04/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import Foundation

let idkey =     "id"
let farmKey =   "farm"
let serverKey = "server"
let secretKey = "secret"
let titleKey = "title"

class Photo {
    
    var id: String?
    var farm: Int?
    var server: String?
    var secret: String?
    var title: String?
    let size = "m"
    
    var url: String? {
        get {
            if let farm = farm, let server = server, let id = id, let secret = secret {
                return "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_m.jpg"
            }
            return nil
        }
    }
    
    init(with attributes: [String:Any]) {
        id = attributes[idkey] as? String
        farm = attributes[farmKey] as? Int
        server = attributes[serverKey] as? String
        secret = attributes[secretKey] as? String
        title = attributes[titleKey] as? String
    }
}

