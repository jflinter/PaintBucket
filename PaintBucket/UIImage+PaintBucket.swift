//
//  UIImage+PaintBucket.swift
//  PaintBucket
//
//  Created by Jack Flintermann on 3/13/16.
//  Copyright © 2016 jflinter. All rights reserved.
//

import UIKit

public extension UIImage {
    
    @objc public func pbk_imageByReplacingColorAt(_ x: Int, _ y: Int, withColor: UIColor, tolerance: Int, antialias: Bool = false) -> UIImage {
        let point = CGPoint(x: x, y: y)
        let imageBuffer = ImageBuffer(image: self.cgImage!)
        let pixel = imageBuffer[imageBuffer.indexFrom(x,y)]
        let replacementPixel = Pixel(color: withColor)
        imageBuffer.scanline_replaceColor(pixel, startingAtPoint: point, withColor: replacementPixel, tolerance: tolerance, antialias: antialias)
        
        return UIImage(cgImage: imageBuffer.image, scale: self.scale, orientation: UIImageOrientation.up)
    }
    
}
