//
//  Utils.swift
//  Flickr
//
//  Created by Hemant Singh on 30/04/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import UIKit

class Utils {
    class func frame(for image: UIImage, inImageViewAspectFit imageView: UIImageView) -> CGRect {
        let imageRatio = (image.size.width / image.size.height)
        let viewRatio = imageView.frame.size.width / imageView.frame.size.height
        if imageRatio < viewRatio {
            let scale = imageView.frame.size.height / image.size.height
            let width = scale * image.size.width
            let topLeftX = (imageView.frame.size.width - width) * 0.5
            return CGRect(x: topLeftX, y: 0, width: width, height: imageView.frame.size.height)
        } else {
            let scale = imageView.frame.size.width / image.size.width
            let height = scale * image.size.height
            let topLeftY = (imageView.frame.size.height - height) * 0.5
            return CGRect(x: 0.0, y: topLeftY, width: imageView.frame.size.width, height: height)
        }
    }
    class func CGSizeAspectFill(aspectRatio: CGSize, minimumSize: CGSize) -> CGSize {
        var aspectFillSize = CGSize(width: minimumSize.width, height: minimumSize.height)
        let mW = Float(minimumSize.width / aspectRatio.width)
        let mH = Float(minimumSize.height / aspectRatio.height)
        if mH > mW {
            aspectFillSize.width = CGFloat(mH) * aspectRatio.width
        } else if mW > mH {
            aspectFillSize.height = CGFloat(mW) * aspectRatio.height
        }
        return aspectFillSize
    }
    class func CGSizeAspectFit(aspectRatio: CGSize, boundingSize: CGSize) -> CGSize {
        var aspectFitSize = CGSize(width: boundingSize.width, height: boundingSize.height)
        let mW = Float(boundingSize.width / aspectRatio.width)
        let mH = Float(boundingSize.height / aspectRatio.height)
        if mH < mW {
            aspectFitSize.width = CGFloat(mH) * aspectRatio.width
        } else if mW < mH {
            aspectFitSize.height = CGFloat(mW) * aspectRatio.height
        }
        return aspectFitSize
    }
}
