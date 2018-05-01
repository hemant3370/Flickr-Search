//
//  StringExt.swift
//  Quiz
//
//  Created by Hemant Singh on 26/03/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import UIKit

extension String{    
    func convertHtml() -> NSAttributedString{
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do{
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html,
                                                                .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        }catch{
            return NSAttributedString()
        }
    }
}
