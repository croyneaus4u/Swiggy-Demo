//
//  BaseRequestor.swift
//  housejoy
//
//  Created by Lab kumar on 22/02/16.
//  Copyright © 2016 Sarvaloka. All rights reserved.
//

import Foundation
//import AlamofireObjectMapper

enum RequestMethodType: String {
    case GET = "GET", POST = "POST", PUT = "PUT", DELETE = "DELETE"
}

typealias NetworkSuccessHandler = (AnyObject?) -> Void
typealias NetworkFailureHandler = (NSError?) -> Void
typealias NetworkCompletionHandler = (success: Bool, object: AnyObject?) -> Void

class BaseRequestor: NSObject {
    
    let requestOperationQueue = NSOperationQueue()
    var dataTask: NSURLSessionDataTask?
    
    override init() {
        //
    }
    
    func defaultHeaders () -> [String: String] {
        /*if let token = UserInfo.sharedInstance.accessToken {
            return ["Accept" : "application/json", "Access-Token": token, "User-Id": UserInfo.sharedInstance.custID, "User-Type": USER_TYPE]
        }*/
        return ["Accept" : "application/json"]
    }
    
    // Generic request
    func makeRequestWithparameters (method: RequestMethodType, urlString: String, success: NetworkSuccessHandler?, failure: NetworkFailureHandler?) {
        
        print("\nRequestHeaders:>> \(defaultHeaders())")
        print("\nRequestURL:>> \(urlString)")
        
        guard let url = NSURL(string: urlString) else {
            failure?(nil)
            return
        }
        
        let request = NSMutableURLRequest(URL: url)
        request.allHTTPHeaderFields = defaultHeaders()
        request.HTTPMethod = method.rawValue
        
        dataTask = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration()).dataTaskWithRequest(request) { (data, response, error) in
            dispatch_async(dispatch_get_main_queue(), {
                if error != nil {
                    failure?(error)
                } else if let _ = data, let response = response as? NSHTTPURLResponse where 200...299 ~= response.statusCode {
                    do {
                        let serialized = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? NSDictionary
                        //print(serialized)
                        success?(serialized)
                    } catch {
                        print("exception in serializing object")
                        failure?(nil)
                    }
                } else {
                    failure?(nil)
                }
            })
        }
        
        dataTask?.resume()
    }
    
    // make GET Request
    func makeGETRequestWithparameters (urlString: String, success: NetworkSuccessHandler?, failure: NetworkFailureHandler?) {

        makeRequestWithparameters(.GET, urlString: urlString, success: success, failure: failure)
    }
}
