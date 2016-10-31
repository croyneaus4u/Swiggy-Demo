//
//  Utility.swift
//  SwiggyDemo
//
//  Created by Lab kumar on 01/11/16.
//  Copyright © 2016 Lab kumar. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    func setAttributedText (partText: String, fullText: String, attributes: [String: AnyObject]) {
        
        let combinedString = fullText as NSString
        let range = combinedString.rangeOfString(partText)
        let attributedString = NSMutableAttributedString(string: combinedString as String)
        
        attributedString.addAttributes(attributes, range: range)
        
        self.attributedText = attributedString
    }
}
