//
//  Departure.swift
//  Tranzit
//
//  Created by Stephan Rabanser on 10/03/15.
//  Copyright (c) 2015 Stephan Rabanser. All rights reserved.
//

import Foundation

@objc(Departure)
class Departure: NSObject, NSCoding {
    
    var line = ""
    var destination = ""
    var destinationShort = ""
    var minutes = ""
    
    override var description: String {
        return line + " → " + destination + " in " + minutes + " min"
    }
    
    var shortenedDescription: String {
        return line + " → " + destinationShort + " (" + minutes + " min)"
    }
    
    override init() {
    }
    
    required init(coder aDecoder: NSCoder) {
        self.line = aDecoder.decodeObjectForKey("line") as! String
        self.destination = aDecoder.decodeObjectForKey("destination") as! String
        self.destinationShort = aDecoder.decodeObjectForKey("destinationShort") as! String
        self.minutes = aDecoder.decodeObjectForKey("minutes") as! String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(line, forKey: "line")
        aCoder.encodeObject(destination, forKey: "destination")
        aCoder.encodeObject(destinationShort, forKey: "destinationShort")
        aCoder.encodeObject(minutes, forKey: "minutes")
    }
    
    init(line: String, destination: String, destinationShort: String, minutes: String) {
        self.line = line
        self.destination = destination
        self.destinationShort = destinationShort
        self.minutes = minutes
    }
    
    class func departureFromDictionary(dict: [String : AnyObject]) -> Departure {
        return Departure(line: dict["line"] as! String, destination: dict["destination"] as! String, destinationShort: dict["destination_short"] as! String, minutes: String(dict["minutes"] as! Int))
    }
    
    class func departuresFromArray(array: [[String : AnyObject]]) -> [Departure] {
        var departures = [Departure]()
        for dict in array {
            departures.append(Departure.departureFromDictionary(dict))
        }
        return departures
    }
    
}