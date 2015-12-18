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

private extension NSDate {
    func moveOnDate(monthOffset : Int) -> NSDate {
        let gregorian = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let offset = NSDateComponents()
        offset.month = monthOffset
        return gregorian!.dateByAddingComponents(offset, toDate: self, options: .MatchStrictly)!
    }
    
    func asString() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-ddTHH:mm:ss"
        return dateFormatter.stringFromDate(self)
    }
}

private extension String {
    func sanitizedString() -> String {
        return self.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
    }
}

typealias EventRequestManagerCompletionHandler = (Set<Event>, NSError?) -> ()
typealias SODAAPIRequestManagerCompletionHandler = (Array<Dictionary<String,AnyObject>>, NSError?) -> ()

class EventRequestManager : SODAAPIRequestManager {
    
    convenience init(endpoint: String , limitOfObjectsPerPage: Int, monthsBack: Int) {
        let now = NSDate().asString()
        let monthsAgo = NSDate().moveOnDate(-monthsBack).asString()
        let query = "$where=date < '\(now)' and date > '\(monthsAgo)'"
        self.init(endpoint: endpoint, limitOfObjectsPerPage: limitOfObjectsPerPage, query: query)
    }
    
    func performRequestOnPage(page: Int, completionHandler: EventRequestManagerCompletionHandler) {
        super.performRequestOnPage(page) { (array, error) -> () in
            if error != nil {
                completionHandler(Set(), error)
                return
            }
            
            var eventSet = Set<Event>()
            for dictionary in array {
                let event = Event(dictionary: dictionary)
                eventSet.insert(event)
            }
            completionHandler(eventSet, error)
        }
    }
}

class SODAAPIRequestManager: NSObject {
    
    private var endpoint : String?
    private var query : String?
    private var limitOfObjectsPerPage = 0
    
    override init() {
        assertionFailure("You shouldn't call SODAAPIRequestManager.init directly")
    }
    
    init(endpoint : String, limitOfObjectsPerPage : Int, query : String ) {
        super.init()
        self.endpoint = String(endpoint)
        self.limitOfObjectsPerPage = limitOfObjectsPerPage
        self.query = String(query)
    }
    
    private func performRequestOnPage(page: Int, completionHandler : SODAAPIRequestManagerCompletionHandler) {
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
                completionHandler( Array(), response.result.error!)
                return
            }
            
            let json = JSON(response.result.value!)
            
            if let responseArray = json.rawValue as? Array<Dictionary<String,AnyObject>> {
                completionHandler(responseArray, nil)
                return
            }
            
            let error = NSError(domain: "CrimeMap.API", code: 0, userInfo: [ NSLocalizedDescriptionKey : "Received type is not handled"])
            completionHandler(Array(), error)
            
        }
    }
}