//
//  APIWrapper.swift
//  Tranzit
//
//  Created by Stephan Rabanser on 10/03/15.
//  Copyright (c) 2015 Stephan Rabanser. All rights reserved.
//

import Foundation
import Alamofire

class SynchronousRequest : NSObject {
    func send(url: String) -> NSData? {
        var request = NSURLRequest(URL: NSURL(string: url)!)
        var response: NSURLResponse?
        var error: NSError?
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error)
        
        if error != nil {
            println(error?.description)
        }
        
        return data
    }
}

class APIWrapper {
    
    let baseURL = "https://tranzit-api.herokuapp.com/"
    
    func fetchDepartures(success: (departures:[Departure]) -> Void, failure: (error : NSError!) -> Void) {
        Alamofire.request(.GET, baseURL + "departures/Garching").responseJSON { (_, _, JSON, error) in
            if let err = error {
                
            } else {
                if let response = JSON as [[String: AnyObject]]? {
                    success(departures: Departure.departuresFromArray(response))
                }
            }
        }
    }
    
    func fetchDeparturesSynchronous(stationName: String) -> [Departure]? {
        var request = SynchronousRequest()
        if let res = request.send(baseURL + "departures/" + stationName) {
            let jsonDict = NSJSONSerialization.JSONObjectWithData(res, options: nil, error: nil) as [[String: AnyObject]]
            return Departure.departuresFromArray(jsonDict)
        }
        
        return nil
    }
    
}
