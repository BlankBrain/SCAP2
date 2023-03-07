//
//  ImageExtension.swift
//  OtpChat
//
//  Created by Md. Mehedi Hasan on 1/3/23.
//

import UIKit
import  ImageIO
import SDWebImage
extension UIImageView
{
    
    func downloadedFrom(link: String,
                        placeHolder:String = "asset-profile-placeholder",
                        isFromCache:Bool = true,
                        isIndicator:Bool = false,
                        mode:UIView.ContentMode = .scaleAspectFit,
                        isAppendBaseUrl:Bool = true) {

        self.contentMode = mode

        let placeHolderImage = UIImage(named: placeHolder)
        self.image = placeHolderImage

        if link.isEmpty {
            return
        }
        else {
            let strlink =  link //isAppendBaseUrl ? WebService.IMAGE_BASE_URL + link : link
            guard let url = URL(string: strlink) else {
                return
            }

            if isIndicator {
                self.sd_imageIndicator = SDWebImageActivityIndicator.gray
                self.sd_imageIndicator?.startAnimatingIndicator()
            }

            if isFromCache {
                self.sd_setImage(with: url,
                                 placeholderImage: placeHolderImage,
                                 completed: { [weak self] (image, error, cacheType, url) -> Void in
                                    if error != nil {
                                        //debugPrint("\(self ?? UIImageView()) \(error!)")
                                    }

                                    self?.image = image ?? self?.image
                                    self?.sd_imageIndicator?.stopAnimatingIndicator()
                })
            }
            else {
                let shared = SDWebImageDownloader.shared
                shared.downloadImage(with: url,
                                     options: SDWebImageDownloaderOptions.ignoreCachedResponse,
                                     progress: nil,
                                     completed: { [weak self] (image, data, error, result) in
                                        if error != nil {
                                            //debugPrint("\(self ?? UIImageView()) \(error!)")
                                        }

                                        self?.image = image ?? self?.image
                                        self?.sd_imageIndicator?.stopAnimatingIndicator()
                })
            }
        }
    }
    func downloadedFromWithProfilePlaceholder(link: String,
                        placeHolder:String = "emergeny",
                        isFromCache:Bool = true,
                        isIndicator:Bool = false,
                        mode:UIView.ContentMode = .scaleAspectFit,
                        isAppendBaseUrl:Bool = true) {

        self.contentMode = mode

        let placeHolderImage = UIImage(named: placeHolder)
        self.image = placeHolderImage

        if link.isEmpty {
            return
        }
        else {
            let strlink = isAppendBaseUrl ? WebService.IMAGE_BASE_URL + link : link
            guard let url = URL(string: strlink) else {
                return
            }

            if isIndicator {
                self.sd_imageIndicator = SDWebImageActivityIndicator.gray
                self.sd_imageIndicator?.startAnimatingIndicator()
            }

            if isFromCache {
                self.sd_setImage(with: url,
                                 placeholderImage: placeHolderImage,
                                 completed: { [weak self] (image, error, cacheType, url) -> Void in
                                    if error != nil {
                                        //debugPrint("\(self ?? UIImageView()) \(error!)")
                                    }

                                    self?.image = image ?? self?.image
                                    self?.sd_imageIndicator?.stopAnimatingIndicator()
                })
            }
            else {
                let shared = SDWebImageDownloader.shared
                shared.downloadImage(with: url,
                                     options: SDWebImageDownloaderOptions.ignoreCachedResponse,
                                     progress: nil,
                                     completed: { [weak self] (image, data, error, result) in
                                        if error != nil {
                                            //debugPrint("\(self ?? UIImageView()) \(error!)")
                                        }

                                        self?.image = image ?? self?.image
                                        self?.sd_imageIndicator?.stopAnimatingIndicator()
                })
            }
        }
    }
    
    
}

extension UIImage
{
     func jd_imageAspectScaled(toFit size: CGSize) -> UIImage
     {
        let imageAspectRatio = self.size.width / self.size.height
        let canvasAspectRatio = size.width / size.height
        
        var resizeFactor: CGFloat
        
        if imageAspectRatio > canvasAspectRatio {
            resizeFactor = size.width / self.size.width
        } else {
            resizeFactor = size.height / self.size.height
        }
        
        let scaledSize = CGSize(width: self.size.width * resizeFactor, height: self.size.height * resizeFactor)
        let origin = CGPoint(x: (size.width - scaledSize.width) / 2.0, y: (size.height - scaledSize.height) / 2.0)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        draw(in: CGRect(origin: origin, size: scaledSize))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}


//Animation Images

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}



extension UIImage {
    
    public class func gifImageWithData(_ data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            printE("image doesn't exist")
            return nil
        }
        
        return UIImage.animatedImageWithSource(source)
    }
    
    public class func gifImageWithURL(_ gifUrl:String) -> UIImage? {
        guard let bundleURL:URL = URL(string: gifUrl)
            else {
                printE("image named \"\(gifUrl)\" doesn't exist")
                return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            printE("image named \"\(gifUrl)\" into NSData")
            return nil
        }
        
        return gifImageWithData(imageData)
    }
    
    public class func gifImageWithName(_ name: String) -> UIImage? {
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif") else {
                printE("SwiftGif: This image named \"\(name)\" does not exist")
                return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            printE("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }
        
        return gifImageWithData(imageData)
    }
    
    class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1
        
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifProperties: CFDictionary = unsafeBitCast(
            CFDictionaryGetValue(cfProperties,
                                 Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()),
            to: CFDictionary.self)
        
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                                 Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                                                             Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        
        delay = delayObject as! Double
        
        if delay < 0.1 {
            delay = 0.1
        }
        
        return delay
    }
    
    class func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }
        
        if a < b {
            let c = a
            a = b
            b = c
        }
        
        var rest: Int
        while true {
            rest = a! % b!
            
            if rest == 0 {
                return b!
            } else {
                a = b
                b = rest
            }
        }
    }
    
    class func gcdForArray(_ array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }
        
        return gcd
    }
    
    class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        
        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
            
            let delaySeconds = UIImage.delayForImageAtIndex(Int(i),
                                                            source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }
        
        let duration: Int = {
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            
            return sum
        }()
        
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
        let animation = UIImage.animatedImage(with: frames,
                                              duration: Double(duration) / 1000.0)
        
        return animation
    }
}
