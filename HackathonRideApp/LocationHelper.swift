//
//  LocationHelper.swift
//  HackathonRideApp
//
//  Created by Chris on 4/2/16.
//  Copyright © 2016 Chris Repanich. All rights reserved.
//

import Foundation
//constants
let Google_API_Key: String = "AIzaSyAVcHewijRPDnqIuk-sH4enK4SReef5bl0"

class LocationHelper {
    //Get Latitude and Longitude from a String Address
    static func getLatLongFromAddress(address: String)-> (Float,Float) {
      //maps.googleapis.com/maps/api/geocode/json?address=1600+Amphitheatre+Parkway,+Mountain+View,+CA&key=YOUR_API_KEY
        //trim outer whitespace, then replace inner whitespace with + signs
        let outerTrim = address.stringByTrimmingCharactersInSet(
            NSCharacterSet.whitespaceAndNewlineCharacterSet()
        )
        let components = outerTrim.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let filtered = components.filter({!$0.isEmpty})
        let finAddress = filtered.joinWithSeparator("+")
        
        //send request
        var lat: Float = FLT_MAX
        var long: Float = FLT_MAX
        let semaphore = dispatch_semaphore_create(0)
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)){
            if let url = NSURL(string: "https://maps.googleapis.com/maps/api/geocode/json?address=\(finAddress)&key=\(Google_API_Key)"){
                let request = NSMutableURLRequest(URL: url)
                request.HTTPMethod = "GET" //Or GET if that's what you need
                request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")  //This is where you add your HTTP headers like Content-Type, Accept and so on
                request.addValue("Bearer \(Bearer_Token)", forHTTPHeaderField: "Authorization")
                let session = NSURLSession.sharedSession()
                session.dataTaskWithRequest(request, completionHandler: { (returnData, response, error) -> Void in
                    let strData = NSString(data: returnData!, encoding: NSUTF8StringEncoding)
                    print("\(strData)")
                    (lat, long) = getLatLongFromJSONResponse(strData as! String)
                    dispatch_semaphore_signal(semaphore)
                }).resume() //Remember this one or nothing will happen :-)
            }
        }//end async dispatch
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        return (lat, long)
    }
    
    static func getLatLongFromJSONResponse(data: String)-> (Float, Float) {
        var lat: Float = 0
        var long: Float = 0
        do {
            let dataFromString = data.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion:  false)!
            let json = try NSJSONSerialization.JSONObjectWithData(dataFromString, options: .AllowFragments) as! [String: AnyObject]
            if let results = json["results"] as? [[String: AnyObject]] {
                if let geometry = results[0]["geometry"] as? [String: AnyObject] {
                    if let location = geometry["location"] as? [String: AnyObject] {
                        lat = location["lat"] as! Float
                        long = location["lng"] as! Float
                        return (lat, long)
                    }
                }
            }
            
        }catch {
            print("Error with Json: \(error)")
        }
        return (FLT_MAX, FLT_MAX)
    }
}