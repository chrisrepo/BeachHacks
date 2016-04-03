//
//  FetchEstimate.swift
//  HackathonRideApp
//
//  Created by Vrezh Gulyan on 4/2/16.
//  Copyright © 2016 Chris Repanich. All rights reserved.
//

import Foundation

struct FetchEstimate{

    func getEstimate(completion: (PriceEstimate? -> Void)) {
        
        if let url = NSURL(string: "https://api.uber.com/v1/estimates/price?start_latitude=33.785537&server_token=xHire5cK16V9eQgU_MhA-y6vs2OZqHKLTtk0YiBF&start_longitude=-118.108602&end_latitude=33.781959&end_longitude=-118.129072"){
            let networkOperation = NetworkOperation(url: url)
    
            networkOperation.downloadJSONFromURl{
                (let JSONDictionary) in
                let estimate = PriceEstimate(estimateDictionary: JSONDictionary)
                    completion(estimate)
        
            }
    
            } else {
            
            print("Could not construct a valid URL")
        }
    }
}