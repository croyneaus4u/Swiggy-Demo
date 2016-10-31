//
//  ImageDownloader.swift
//  SwiggyDemo
//
//  Created by Lab kumar on 01/11/16.
//  Copyright © 2016 Lab kumar. All rights reserved.
//

import UIKit

class ImageDownloadManager: NSObject {
    
    let queue = NSOperationQueue()
    var imageCache = NSCache()
    var operationCache = NSMutableDictionary()
    class var sharedInstance: ImageDownloadManager {
        
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: ImageDownloadManager? = nil
        }
        
        dispatch_once(&Static.onceToken) {
            Static.instance = ImageDownloadManager()
        }
        
        return Static.instance!
    }
    
    private override init() {
        
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ImageDownloadManager.recievedMemoryWarning), name: UIApplicationDidReceiveMemoryWarningNotification, object: nil)
    }
    
    func cancelOperation(path: String) {
        
        if let op = self.operationCache[path] as? NSOperation {
            op.cancel()
            operationCache.removeObjectForKey(path)
        }
    }
    
    func downloadWebImage(path: String, completionHandler: (image: UIImage?) -> ()){
        
        if let image = imageCache.objectForKey(path) as? UIImage {
            completionHandler(image: image)
            return
        }
        
        let imagePath = path.cachesPath()
        if let image = UIImage(contentsOfFile: imagePath) {
            
            completionHandler(image: image)
            imageCache.setObject(image, forKey: path)
            return
        }
        
        if let existingOp = self.operationCache[path] as? ImageDownloadOperation {
            let existingHandler = existingOp.completion
            existingOp.completion = { (image) in
                existingHandler?(image)
                completionHandler(image: image)
            }
            return
        }
        
        let op = ImageDownloadOperation.operationWith(path, completionHandler: { (image) -> () in
            self.operationCache.removeObjectForKey(path)
            if image != nil {
                self.imageCache.setObject(image!, forKey: path)
            }
            completionHandler(image: image)
            
        })
        
        operationCache.setValue(op, forKey: path)
        queue.addOperation(op)
    }
    
    func recievedMemoryWarning() {
        imageCache.removeAllObjects()
        operationCache.removeAllObjects()
        
    }
}

class ImageDownloadOperation: NSOperation {
    
    var path: String?
    var completion: ((UIImage?) -> Void)?
    
    class func operationWith(path: String , completionHandler: (image: UIImage?) -> ()) -> ImageDownloadOperation {
        let op = ImageDownloadOperation()
        op.path = path
        op.completion = completionHandler
        return op
        
    }
    
    override func main() {
        
        if self.cancelled {
            self.completion?(nil)
            return
        }
        var image: UIImage?
        
        if path != nil {
            let url = NSURL(string: path!)
            let data = NSData(contentsOfURL: url!)
            if (self.cancelled) {
                self.completion?(nil)
                return
            }
            
            if let imageData = data {
                image = UIImage(data: imageData)
                imageData.writeToFile(path!.cachesPath(), atomically: true)
            } else {
                //print("error downloading image for URL: \(path)")
            }
        }
        
        if (self.cancelled) {
            self.completion?(nil)
            return
        }
        
        NSOperationQueue.mainQueue().addOperationWithBlock({ [weak self] () -> Void in
            self?.completion?(image)
            })
    }
}
