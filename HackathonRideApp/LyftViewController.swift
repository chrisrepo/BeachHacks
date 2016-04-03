//
//  LyftViewController.swift
//  HackathonRideApp
//
//  Created by Chris on 4/2/16.
//  Copyright © 2016 Chris Repanich. All rights reserved.
//

import Foundation
import UIKit

let Bearer_Token : String = "gAAAAABXAIYZCGKphx6dYLcCxqRRyUVkeHJGxFJ4Mhx1LTcFuKLleUE4hFhmkrAQgvHgjctIjLLLZMYMbsFf66wSUW7eeneqBPvZXwK_bIAX-31ZvYtAeDE7lSYUSxnc-iD2ieGlJ92GfgLiiAFUaiBFY8p0gsYzUkJ4OLWO0tgSBmp79c88IfZijmg5JyirKpPYNy6sNBUHJ0smZFA2EBl2eQrPEV2q0w=="
class LyftViewController : UIViewController {
    @IBOutlet var startAddressField: UITextField!
    @IBOutlet var endAddressField: UITextField!
    @IBOutlet var lyftTypeLabel: UILabel!
    @IBOutlet var lyftCostLabel: UILabel!
    @IBOutlet var lyftETALabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Extra Comment
        startAddressField.text = "1067 Grand Ave, Long Beach"
        endAddressField.text = "1250 Bellflower Blvd, Long Beach"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func estimateButtonPressed(sender: AnyObject) {
        let start_address = startAddressField.text!
        let end_address = endAddressField.text!
        if (start_address == "" || end_address == "") {
            
        } else {
            var estimatesETA = LyftHelper.getTimeEstimate(start_address)
            if let error = estimatesETA[0]["error"] {
                //if there's an error message, we figure it out
                //else, leggoooooo
            } else {
                //update labels with estimates
                let firstETA = estimatesETA[0] as [String: AnyObject]
                let secVal = firstETA["eta_seconds"] as! Int
                let minVal = secVal/60
                if (minVal < 2) {
                    lyftETALabel.text = "1 minute"
                } else {
                    lyftETALabel.text = "\(minVal) minutes"
                }
            }
            var estimatesCOST = LyftHelper.getCostEstimate(start_address, end_address: end_address)
            if let error = estimatesCOST[0]["error"] {
                //if there's an error message, we figure it out
                //else, leggoooooo
            } else {
                //update labels with estimates
                let firstCost = estimatesCOST[0] as [String: AnyObject]
                let type = firstCost["ride_type"] as? String
                lyftTypeLabel.text = "\(type!)"
                
                
                let costMax = firstCost["estimated_cost_cents_max"] as! Double
                let maxDollar = costMax/100
                let max = Double(round(100*maxDollar)/100)
                let costMin = firstCost["estimated_cost_cents_min"] as! Double
                let minDollar = costMin/100
                let min = Double(round(100*minDollar)/100)
                lyftCostLabel.text = "$\(min.format(".2"))-$\(max.format(".2"))"
            }
            
        }
    }
}

extension Double {
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}