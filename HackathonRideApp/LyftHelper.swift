//
//  LyftHelper.swift
//  HackathonRideApp
//
//  Created by Chris on 4/2/16.
//  Copyright © 2016 Chris Repanich. All rights reserved.
//

import Foundation

class LyftHelper {
    
    static func getCostEstimate(address: String, end_address: String) -> [[String: AnyObject]] {
        var result = [[String: AnyObject]]()
        var start_lat: Float
        var start_long: Float
        (start_lat, start_long) = LocationHelper.getLatLongFromAddress(address)
        var end_lat, end_long : Float
        (end_lat, end_long) = LocationHelper.getLatLongFromAddress(end_address)
        let semaphore = dispatch_semaphore_create(0)
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)){
            if let url = NSURL(string: "https://api.lyft.com/v1/cost?start_lat=\(start_lat)&start_lng=\(start_long)&end_lat=\(end_lat)&end_lng=\(end_long)"){
                let request = NSMutableURLRequest(URL: url)
                request.HTTPMethod = "GET" //Or GET if that's what you need
                request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")  //This is where you add your HTTP headers like Content-Type, Accept and so on
                request.addValue("Bearer \(Bearer_Token)", forHTTPHeaderField: "Authorization")
                let session = NSURLSession.sharedSession()
                session.dataTaskWithRequest(request, completionHandler: { (returnData, response, error) -> Void in
                    let strData = NSString(data: returnData!, encoding: NSUTF8StringEncoding)
                    print("\(strData)")
                    result = getEstimateArray(returnData!)
                    dispatch_semaphore_signal(semaphore)
                }).resume() //Remember this one or nothing will happen :-)
            }
        }//end async dispatch
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        return result
    }
    
    static func getTimeEstimate(address: String) -> [[String: AnyObject]]{
        var result = [[String: AnyObject]]()
        var lat: Float
        var long: Float
        (lat, long) = LocationHelper.getLatLongFromAddress(address)
        let semaphore = dispatch_semaphore_create(0)
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)){
            if let url = NSURL(string: "https://api.lyft.com/v1/eta?lat=\(lat)&lng=\(long)"){
                let request = NSMutableURLRequest(URL: url)
                request.HTTPMethod = "GET" //Or GET if that's what you need
                request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")  //This is where you add your HTTP headers like Content-Type, Accept and so on
                request.addValue("Bearer \(Bearer_Token)", forHTTPHeaderField: "Authorization")
                let session = NSURLSession.sharedSession()
                session.dataTaskWithRequest(request, completionHandler: { (returnData, response, error) -> Void in
                    let strData = NSString(data: returnData!, encoding: NSUTF8StringEncoding)
                    print("\(strData)")
                    result = getEstimateArray(returnData!)
                    dispatch_semaphore_signal(semaphore)
                }).resume() //Remember this one or nothing will happen :-)
            }
        }//end async dispatch
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        return result
    }
    
    static func getEstimateArray(data: NSData) -> [[String: AnyObject]] {
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! [String: AnyObject]
            if let results = json["eta_estimates"] as? [[String: AnyObject]] {
                return results
            }
            if let results = json["cost_estimates"] as? [[String: AnyObject]] {
                return results
            }
        }catch {
            print("Error with Json: \(error)")
        }
        return [["error":"empty"]]///return empty object if no
    }
}