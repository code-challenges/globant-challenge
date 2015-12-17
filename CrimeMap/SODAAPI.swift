//
//  Swift.swift
//  CrimeMap
//
//  Created by Julio César Guzman on 12/16/15.
//  Copyright © 2015 Julio. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

//TODO: FIX Query: "$where=date between '\(now)' and '\(aMonthAgo)'"
//Receiving: Error, could not parse SoQL query
//TODO: Add error handling

class ObjectConverter : NSObject {
    
    static func converter(dictionary : NSDictionary) -> Event {
        var event = Event()
        
        event.address = dictionary["address"] as! NSString
        event.category = dictionary["category"] as! NSString
        event.date = dictionary["date"] as! NSString
        event.dayOfTheWeek = dictionary["dayofweek"] as! NSString
        event.incidentNumber = dictionary["incidntnum"] as! NSString
        event.location = Location()
        
//        let humanAddressDictionary = dictionary["location"]!["human_address"] as! NSDictionary
//        event.location.humanAddress = Address()
//        event.location.humanAddress.address = humanAddressDictionary["address"] as! NSString
//        event.location.humanAddress.city = humanAddressDictionary["city"] as! NSString
//        event.location.humanAddress.state = humanAddressDictionary["state"] as! NSString
//        event.location.humanAddress.zip = humanAddressDictionary["zip"] as! NSString
        event.location.latitude = dictionary["location"]!["latitude"] as! NSString
        event.location.longitude = dictionary["location"]!["longitude"] as! NSString
        event.location.needsRecording = dictionary["location"]!["needs_recoding"] as! Bool
        event.pddistrict = dictionary["pddistrict"] as! NSString
        event.resolution = dictionary["resolution"] as! NSString
        event.time = dictionary["time"] as! NSString
        event.x = dictionary["x"] as! NSString
        event.y = dictionary["y"] as! NSString
        
        return event
    }
    
}

public typealias SODAAPIRequestManagerCompletionHandler = (NSArray, NSError?) -> ()

public class EventRequestManager : SODAAPIRequestManager {
    
    public convenience init(endpoint: NSString , limitOfObjectsPerPage: Int, monthsBack: Int) {
        let now = NSDate().asString()
        let aMonthAgo = NSDate().moveOnDate(-monthsBack).asString()
        let query = "$where=date < '\(now)' and date > '\(aMonthAgo)'"
        self.init(endpoint: endpoint, limitOfObjectsPerPage: limitOfObjectsPerPage, query: query)
    }
}

public class SODAAPIRequestManager: NSObject {
    
    private var endpoint : String?
    private var query : String?
    private var limitOfObjectsPerPage = 0
    
    override init() {
        assertionFailure("You shouldn't call SODAAPIRequestManager.init directly")
    }
    
    public init(endpoint : NSString, limitOfObjectsPerPage : Int, query : NSString ) {
        super.init()
        self.endpoint = String(endpoint)
        self.limitOfObjectsPerPage = limitOfObjectsPerPage
        self.query = String(query)
    }
    
    public func performRequestOnPage(page: Int, completionHandler : SODAAPIRequestManagerCompletionHandler) {
        if self.endpoint == nil {
            return
        }
        
        let pageNumber = page
        let satinizedPaginationQuery = "$limit=\(self.limitOfObjectsPerPage)&$offset=\(pageNumber)".sanitizedString()
        let sanitizedQuery = self.query?.sanitizedString()
        
        var url = self.endpoint! + satinizedPaginationQuery
        
        if (sanitizedQuery != nil) {
            url = url + "&" + sanitizedQuery!
        }
        
        let request = Alamofire.request(.GET, url)
        
        request.responseJSON { response in
            
            if response.result.isFailure {
                completionHandler( NSArray(), response.result.error!)
                return
            }
            
            let json = JSON(response.result.value!)
            
            if let responseArray = json.rawValue as? NSArray {
                completionHandler(responseArray, nil)
                return
            }
            
            let error = NSError(domain: "CrimeMap.API", code: 0, userInfo: [ NSLocalizedDescriptionKey : "Received type is not handled"])
            completionHandler(NSArray(), error)
            
        }
    }
}