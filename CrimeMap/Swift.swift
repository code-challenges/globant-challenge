//
//  Swift.swift
//  CrimeMap
//
//  Created by Julio César Guzman on 12/16/15.
//  Copyright © 2015 Julio. All rights reserved.
//

import Foundation
import Alamofire

//TODO: FIX Query: "$where=date between '\(now)' and '\(aMonthAgo)'"
//Receiving: Error, could not parse SoQL query
//TODO: Add error handling

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
    
    public func performRequestOnPage(page: Int) {
        if self.endpoint == nil {
            return
        }
        
        let pageNumber = page
        let paginationQuery = "$limit=\(self.limitOfObjectsPerPage)&$offset=\(pageNumber)&"
        let sanitizedQuery = self.query?.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        
        var url = self.endpoint! + paginationQuery
        
        if (sanitizedQuery != nil) {
            url = url + sanitizedQuery!
        }
        
        let request = Alamofire.request(.GET, url)
        
        request.responseJSON { response in
            debugPrint(response)
        }
    }
}