//
//  ImageBuffer.swift
//  PaintBucket
//
//  Created by Jack Flintermann on 3/15/16.
//  Copyright © 2016 jflinter. All rights reserved.
//

import CoreGraphics

class ImageBuffer {
    let context: CGContext
    let pixelBuffer: UnsafeMutablePointer<UInt32>
    let imageWidth: Int
    let imageHeight: Int
    
    init(image: CGImage) {
        self.imageWidth = Int(image.width)
        self.imageHeight = Int(image.height)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        self.context = CGContext(data: nil, width: imageWidth, height: imageHeight, bitsPerComponent: 8, bytesPerRow: imageWidth * 4, space: colorSpace, bitmapInfo: CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue)!
        self.context.draw(image, in: CGRect(x: 0, y: 0, width: CGFloat(imageWidth), height: CGFloat(imageHeight)))
        
        let ptr = context.data
        self.pixelBuffer = ptr!.assumingMemoryBound(to: UInt32.self)
    }
    
    func indexFrom(_ x: Int, _ y: Int) -> Int {
        return x + (self.imageWidth * y)
    }
    
    func differenceAtPoint(_ x: Int, _ y: Int, toPixel pixel: Pixel) -> Int {
        let index = indexFrom(x, y)
        let newPixel = self[index]
        return pixel.diff(newPixel)
    }
    
    func differenceAtIndex(_ index: Int, toPixel pixel: Pixel) -> Int {
        let newPixel = self[index]
        return pixel.diff(newPixel)
    }
    
    func scanline_replaceColor(_ colorPixel: Pixel, startingAtPoint startingPoint: (Int, Int), withColor replacementPixel: Pixel, tolerance: Int, antialias: Bool) {
        
        func testPixelAtPoint(_ x: Int, _ y: Int) -> Bool {
            return differenceAtPoint(x, y, toPixel: colorPixel) <= tolerance
        }
        
        let seenIndices = NSMutableIndexSet()
        let indices = NSMutableIndexSet(index: indexFrom(startingPoint.0, startingPoint.1))
        while indices.count > 0 {
            let index = indices.firstIndex
            indices.remove(index)
            
            if seenIndices.contains(index) {
                continue
            }
            seenIndices.add(index)
            
            if differenceAtIndex(index, toPixel: colorPixel) > tolerance {
                continue
            }
            
            let pointX = index % imageWidth
            let y = index / imageWidth
            var minX = pointX
            var maxX = pointX + 1
            
            while minX >= 0 {
                let index = indexFrom(minX, y)
                let pixel = self[index]
                let diff = pixel.diff(colorPixel)
                if diff > tolerance { break }
                let alphaMultiplier = (tolerance == 0) ? 1 : CGFloat(diff) / CGFloat(tolerance)
                let newPixel = antialias ? pixel.multiplyAlpha(alphaMultiplier).blend(replacementPixel) : replacementPixel
                self[index] = newPixel
                minX -= 1
            }
            while maxX < imageWidth {
                let index = indexFrom(maxX, y)
                let pixel = self[index]
                let diff = pixel.diff(colorPixel)
                if diff > tolerance { break }
                let alphaMultiplier = (tolerance == 0) ? 1 : CGFloat(diff) / CGFloat(tolerance)
                let newPixel = antialias ? pixel.multiplyAlpha(alphaMultiplier).blend(replacementPixel) : replacementPixel
                self[index] = newPixel
                maxX += 1
            }
            
            for x in ((minX + 1)...(maxX - 1)) {
                if y < imageHeight - 1 {
                    let index = indexFrom(x, y + 1)
                    if !seenIndices.contains(index) && differenceAtIndex(index, toPixel: colorPixel) <= tolerance {
                        indices.add(index)
                    }
                }
                if y > 0 {
                    let index = indexFrom(x, y - 1)
                    if !seenIndices.contains(index) && differenceAtIndex(index, toPixel: colorPixel) <= tolerance {
                        indices.add(index)
                    }
                }
            }
            
        }
    }
    
    subscript(index: Int) -> Pixel {
        get {
            let pixelIndex = pixelBuffer + index
            return Pixel(memory: pixelIndex.pointee)
        }
        set(pixel) {
            self.pixelBuffer[index] = pixel.uInt32Value
        }
    }
    
    var image: CGImage {
        return self.context.makeImage()!
    }
    
}
