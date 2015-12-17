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
    var latitude = String()
    var longitude = String()
    var needsRecording = Bool()
}

public class Event : NSObject {
    var address : String?
    var category : String?
    var date : String?
    var dayOfTheWeek : String?
    var incidentNumber : String?
    var location = Location()
    var pddistrict : String?
    var resolution : String?
    var time : String?
    var x = Double()
    var y = Double()
    
    public init(dictionary: Dictionary<String, AnyObject>) {
        self.address = dictionary["address"] as? String
        self.category = dictionary["category"] as? String
        self.date = dictionary["date"] as? String
        self.dayOfTheWeek = dictionary["dayofweek"] as? String
        self.incidentNumber = dictionary["incidntnum"] as? String
        self.location = Location()
        self.location.latitude = dictionary["location"]!["latitude"] as! String
        self.location.longitude = dictionary["location"]!["longitude"] as! String
        self.location.needsRecording = dictionary["location"]!["needs_recoding"] as! Bool
        self.pddistrict = dictionary["pddistrict"] as? String
        self.resolution = dictionary["resolution"] as? String
        self.time = dictionary["time"] as? String
        self.x = Double(dictionary["x"] as! String)!
        self.y = Double(dictionary["y"] as! String)!
        super.init()
    }
}