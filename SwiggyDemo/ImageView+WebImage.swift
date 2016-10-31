//
//  ImageView+WebImage.swift
//  SwiggyDemo
//
//  Created by Lab kumar on 01/11/16.
//  Copyright © 2016 Lab kumar. All rights reserved.
//

import Foundation
import UIKit


private var xoAssociationKey: String = "com.image.downloader"
extension UIImageView {
    
    var imageUrlPath: String? {
        get {
            return objc_getAssociatedObject(self, &xoAssociationKey) as? String
        }
        set {
            objc_setAssociatedObject(self, &xoAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    func imageWithUrlString(path: String?){
        
        imageWithUrlString(path, placeHolder: nil)
    }
    
    
    func imageWithUrlString(path: String?, placeHolder: String?) {
        imageWithUrlString(path, placeHolder: placeHolder, completion: nil)
    }
    
    func imageWithUrlString(path: String?, placeHolder: String?, completion: (() -> Void)?) {
        
        
        if placeHolder != nil {
            self.image = UIImage(named: placeHolder!)
        } else {
            self.image = nil
        }
        
        guard path != nil else {
            return
        }
        
        if NSURL(string: path!) == nil {
            return
        }
        
        if imageUrlPath != nil && imageUrlPath != path {
            ImageDownloadManager.sharedInstance.cancelOperation(imageUrlPath!)
        }
        
        imageUrlPath = path
        ImageDownloadManager.sharedInstance.downloadWebImage(imageUrlPath!, completionHandler: { [weak self] (image) -> () in
            if image != nil {
                self?.image = image
            } else {
                print("error downloading image for URL: \(path)")
            }
            
            self?.setNeedsDisplay()
            self?.imageUrlPath = nil
            completion?()
        })
    }
}

extension String {
    
    func documentPath() -> String {
        
        let path = NSSearchPathForDirectoriesInDomains( .DocumentDirectory, .UserDomainMask, true).last
        
        let nsPath: NSString = path!
        let nsSelf: NSString = self
        
        return nsPath.stringByAppendingPathComponent(nsSelf.lastPathComponent)
    }
    
    func cachesPath() -> String {
        
        let path = NSSearchPathForDirectoriesInDomains( .CachesDirectory, .UserDomainMask, true).last
        
        let nsPath: NSString = path!
        let nsSelf: NSString = self
        
        return nsPath.stringByAppendingPathComponent(nsSelf.lastPathComponent)
    }
    
    func tempPath() -> String {
        
        let path: NSString = NSTemporaryDirectory()
        
        let nsSelf: NSString = self
        
        return path.stringByAppendingPathComponent(nsSelf.lastPathComponent)
        
    }
}
