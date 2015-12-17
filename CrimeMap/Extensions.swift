//
//  Extensions.swift
//  CrimeMap
//
//  Created by Julio César Guzman on 12/16/15.
//  Copyright © 2015 Julio. All rights reserved.
//

import Foundation

extension NSDate {
    func moveOnDate(monthOffset : Int) -> NSDate {
        let gregorian = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let offset = NSDateComponents()
        offset.month = monthOffset
        return gregorian!.dateByAddingComponents(offset, toDate: self, options: .MatchStrictly)!
    }
    
    //TODO: Fix this method
    func asString() -> NSString {
        return "2015-03-23T00:00:00.000"
    }
}

extension String {
    func sanitizedString() -> String {
        return self.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
    }
}