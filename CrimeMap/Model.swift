//
//  Model.swift
//  CrimeMap
//
//  Created by Julio César Guzman on 12/16/15.
//  Copyright © 2015 Julio. All rights reserved.
//

import Foundation

struct Location {
    var humanAddress : NSString
    var latitude : Float
    var longitude : Float
    var needsRecording : Bool
}

struct Event {
    var address : NSString
    var category : NSString
    var date : NSTimeInterval
    var dayOfTheWeek : NSString
    var incidentNumber : Int
    var location : Location
    var pddistrict : NSString
    var resolution : NSString
    var time : NSTimeInterval
    var x : Float
    var y : Float
}