//
//  Restaurants.swift
//  SwiggyDemo
//
//  Created by Lab kumar on 31/10/16.
//  Copyright © 2016 Lab kumar. All rights reserved.
//

import UIKit

class JSONResponse: JSONDeserializable {
    required init(dictionary: [String : AnyObject]) {
        //
    }
}

class Response: JSONResponse {
    
    var restaurants: [Restaurants]?
    
    required init(dictionary: [String : AnyObject]) {
        super.init(dictionary: dictionary)
        restaurants <-- dictionary["restaurants"]
    }
}

class Restaurants: JSONResponse {
    
    var name: String?
    var deliveryTime: Int = 0
    var costForTwo: String?
    var closed: Bool = false
    var city: String?
    var cid: String?
    var chain: [Restaurants]?
    var avg_rating: String?
    var area: String?
    
    var cuisine: [String]?
    
    // to check selection
    var selected = false
    
    required init(dictionary: [String : AnyObject]) {
        super.init(dictionary: dictionary)
        
        name <-- dictionary["name"]
        deliveryTime <-- dictionary["deliveryTime"]
        costForTwo <-- dictionary["costForTwo"]
        closed <-- dictionary["closed"]
        city <-- dictionary["city"]
        cid <-- dictionary["cid"]
        chain <-- dictionary["chain"]
        avg_rating <-- dictionary["avg_rating"]
        area <-- dictionary["area"]
        cuisine <-- dictionary["cuisine"]
    }

}
