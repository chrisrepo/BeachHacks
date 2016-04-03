//
//  UberViewController.swift
//  HackathonRideApp
//
//  Created by Chris on 4/2/16.
//  Copyright © 2016 Chris Repanich. All rights reserved.
//

import Foundation
import UIKit
import UberRides

class UberViewController : UIViewController {
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var estimateLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    typealias JSONDictionaryCompletion = ([ String: AnyObject]?) -> Void
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Extra Comment
    
        let button = RequestButton()
        view.addSubview(button)
        
        let estimateInfo = FetchEstimate();
        estimateInfo.getEstimate {
            (let estimate) in
            if let estimateDetails = estimate{
                
                dispatch_async(dispatch_get_main_queue()){
                    if let type = estimateDetails.vehicleType {
                        self.typeLabel?.text = type
                    }
                    if let estimate = estimateDetails.range {
                        self.estimateLabel?.text = estimate
                    }
                    if let duration = estimateDetails.duration {
                        let time = (duration/60)
                        var type = ""
                        if (time < 2){
                            type = "minute"
                        } else {
                            type = "minutes"
                        }
                        self.durationLabel?.text = ("\(time) \(type)")
                    }
                    
                    
                }
        
            }
        }
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}