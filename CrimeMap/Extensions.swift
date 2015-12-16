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
    func dateForQuery() -> NSString {
        return "2015-11-30T00:00:00"
    }
}
