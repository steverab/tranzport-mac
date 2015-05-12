//
//  APIWrapper.swift
//  Tranzit
//
//  Created by Stephan Rabanser on 10/03/15.
//  Copyright (c) 2015 Stephan Rabanser. All rights reserved.
//

import Foundation

class APIWrapper {
    
    let baseURL = "https://tranzit-api.herokuapp.com/"
    
    func fetchDepartures(success: (departures:[Departure]) -> Void, failure: (error : NSError!) -> Void) {
        request(.GET, baseURL + "departures/Garching").responseJSON { (_, _, JSON, error) in
            if let err = error {
                
            } else {
                if let response = JSON as! [[String: AnyObject]]? {
                    success(departures: Departure.departuresFromArray(response))
                }
            }
        }
    }
    
}
