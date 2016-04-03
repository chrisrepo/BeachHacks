//
//  NetworkOperation.swift
//  HackathonRideApp
//
//  Created by Vrezh Gulyan on 4/2/16.
//  Copyright © 2016 Chris Repanich. All rights reserved.
//

import Foundation

class NetworkOperation {
    
    // lazy keyword allows vairable to only be initialized once needed and not before
    
    lazy var config : NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
    lazy var session: NSURLSession = NSURLSession(configuration: self.config)
    
    let queryURL: NSURL
    
    typealias JSONDictionaryCompletion = ([ String: AnyObject]?) -> Void
    
    init(url: NSURL){
        self.queryURL = url
    }
    
    
    func downloadJSONFromURl( completion: JSONDictionaryCompletion) {
        
        let request: NSURLRequest = NSURLRequest(URL: queryURL)
        let dataTask = session.dataTaskWithRequest(request) {
            (let data,let response,let request) in
            //1. Check http response for succesful get request
            
            if let httpResponse = response as? NSHTTPURLResponse {
                switch (httpResponse.statusCode){
                case 200: //successfull
                    //2. create JSON object with data
                    do {
                        let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! [String: AnyObject]
                        completion(jsonDictionary)
                    } catch {
                        print(error)
                    }
                default:
                    print("Http response status code: \(httpResponse.statusCode)")
                }
            } else {
                print("Not a valid http response")
            }
            
        }
        
        dataTask.resume()
    }
}
