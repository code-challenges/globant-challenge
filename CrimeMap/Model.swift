//
//  Model.swift
//  CrimeMap
//
//  Created by Julio César Guzman on 12/16/15.
//  Copyright © 2015 Julio. All rights reserved.
//

import Foundation

struct Address {
    var address = NSString()
    var city = NSString()
    var state = NSString()
    var zip = NSString()
}

struct Location {
    var humanAddress = Address()
    var latitude = NSString()
    var longitude = NSString()
    var needsRecording = Bool()
}

public class Event : NSObject {
    var address = NSString()
    var category = NSString()
    var date = NSString()
    var dayOfTheWeek = NSString()
    var incidentNumber = NSString()
    var location = Location()
    var pddistrict = NSString()
    var resolution = NSString()
    var time = NSString()
    var x = Double()
    var y = Double()
    
    public init(dictionary: NSDictionary) {
        self.address = dictionary["address"] as! NSString
        self.category = dictionary["category"] as! NSString
        self.date = dictionary["date"] as! NSString
        self.dayOfTheWeek = dictionary["dayofweek"] as! NSString
        self.incidentNumber = dictionary["incidntnum"] as! NSString
        self.location = Location()
        self.location.latitude = dictionary["location"]!["latitude"] as! NSString
        self.location.longitude = dictionary["location"]!["longitude"] as! NSString
        self.location.needsRecording = dictionary["location"]!["needs_recoding"] as! Bool
        self.pddistrict = dictionary["pddistrict"] as! NSString
        self.resolution = dictionary["resolution"] as! NSString
        self.time = dictionary["time"] as! NSString
        self.x = Double(dictionary["x"] as! String)!
        self.y = Double(dictionary["y"] as! String)!
        super.init()
    }
}