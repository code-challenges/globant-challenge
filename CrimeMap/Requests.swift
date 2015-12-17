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

public typealias SODAAPIRequestManagerCompletionHandler = (NSArray, NSError?) -> ()

public class EventRequestManager : SODAAPIRequestManager {
    
    public convenience init(endpoint: NSString , limitOfObjectsPerPage: Int, monthsBack: Int) {
        let now = NSDate().asString()
        let aMonthAgo = NSDate().moveOnDate(-monthsBack).asString()
        let query = "$where=date < '\(now)' and date > '\(aMonthAgo)'"
        self.init(endpoint: endpoint, limitOfObjectsPerPage: limitOfObjectsPerPage, query: query)
    }
    
    override public func performRequestOnPage(page: Int, completionHandler: SODAAPIRequestManagerCompletionHandler) {
        super.performRequestOnPage(page) { (array, error) -> () in
            let eventArray = NSMutableArray()
            for object in array {
                if let dictionary = object as? NSDictionary {
                    let event = Event(dictionary: dictionary)
                    eventArray.addObject(event)
                }
            }
            completionHandler(eventArray, error)
        }
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
        
        let satinizedPaginationQuery = "$limit=\(self.limitOfObjectsPerPage)&$offset=\(page)".sanitizedString()
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