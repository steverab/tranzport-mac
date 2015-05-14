//
//  StationFormatter.swift
//  TranzportMac
//
//  Created by Stephan Rabanser on 14/05/15.
//  Copyright (c) 2015 Stephan Rabanser. All rights reserved.
//

import Foundation

extension String {
    public func indexOfCharacter(char: Character) -> Int? {
        if let idx = find(self, char) {
            return distance(self.startIndex, idx)
        }
        return nil
    }
}

class StationFormatter {
    
    class func shortenStationName(sName: String) -> String {
        var needle: Character = "("
        var shortenedString = sName
        if find(sName, needle) == nil {
            needle = " "
            if let idx = find(sName, needle) {
                let pos = distance(sName.startIndex, idx)
                shortenedString = sName.substringWithRange(Range<String.Index>(start: sName.startIndex, end: advance(sName.startIndex, pos + 2)))
                shortenedString = shortenedString + ["."]
            } else {
                needle = "-"
                if let idx = find(sName, needle) {
                    let pos = distance(sName.startIndex, idx)
                    shortenedString = sName.substringWithRange(Range<String.Index>(start: sName.startIndex, end: advance(sName.startIndex, pos + 2)))
                    shortenedString = shortenedString + ["."]
                }
            }
        }
        return shortenedString
    }
    
}