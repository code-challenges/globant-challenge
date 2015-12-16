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

struct Event {
    var address = NSString()
    var category = NSString()
    var date = NSString()
    var dayOfTheWeek = NSString()
    var incidentNumber = NSString()
    var location = Location()
    var pddistrict = NSString()
    var resolution = NSString()
    var time = NSString()
    var x = NSString()
    var y = NSString()
}