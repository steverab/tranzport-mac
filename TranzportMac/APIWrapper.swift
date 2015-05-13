//
//  APIWrapper.swift
//  Tranzit
//
//  Created by Stephan Rabanser on 10/03/15.
//  Copyright (c) 2015 Stephan Rabanser. All rights reserved.
//

import Foundation

class APIWrapper {
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    let baseURL = "https://tranzport-api.herokuapp.com/"
    
    func fetchDepartures(success: (departures:[Departure]) -> Void, failure: (error : NSError!) -> Void) {
        let station = defaults.objectForKey("station") as! String
        request(.GET, baseURL + "departures", parameters: ["station": station]).responseJSON { (_, _, JSON, error) in
            if let err = error {
                
            } else {
                if let response = JSON as! [[String: AnyObject]]? {
                    success(departures: Departure.departuresFromArray(response))
                }
            }
        }
    }
    
}
