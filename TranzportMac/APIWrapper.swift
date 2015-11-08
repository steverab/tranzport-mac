//
//  APIWrapper.swift
//  Tranzit
//
//  Created by Stephan Rabanser on 10/03/15.
//  Copyright (c) 2015 Stephan Rabanser. All rights reserved.
//

import Foundation
import Alamofire

class APIWrapper {
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let baseURL = "https://tranzport-api.herokuapp.com/"
    
    // MARK: - 
    
    func fetchDepartures(success: (departures:[Departure]) -> Void, failure: (error : NSError!) -> Void) {
        let station = defaults.objectForKey("station") as! String
        Alamofire.request(.GET, baseURL + "departures", parameters: ["station": station]).responseJSON { response in
            if let response = response.result.value as! [[String: AnyObject]]? {
                success(departures: Departure.departuresFromArray(response))
            } else {
                failure(error: NSError(domain: "com.steverab.Tranzport", code: 1, userInfo: nil))
            }
        }
    }
    
}
