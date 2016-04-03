//
//  PriceEstimate.swift
//  HackathonRideApp
//
//  Created by Vrezh Gulyan on 4/2/16.
//  Copyright © 2016 Chris Repanich. All rights reserved.
//

import Foundation

struct PriceEstimate {
    
    var vehicleType: String?
    var range: String?
    var duration: Int?
    var eta: Int?
    
    
    init(estimateDictionary: [String:AnyObject]?){
        if let estimates = estimateDictionary?["prices"]
        {
            if let estimate : [String: AnyObject] = estimates[0] as? [String: AnyObject]{
                vehicleType = estimate["localized_display_name"] as? String
                range = estimate["estimate"] as? String
                duration = estimate["duration"] as? Int
                
            }
        }
    }
}