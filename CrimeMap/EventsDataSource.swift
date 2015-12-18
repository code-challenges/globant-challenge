//
//  EventsDataSource.swift
//  CrimeMap
//
//  Created by Julio César Guzman on 12/18/15.
//  Copyright © 2015 Julio. All rights reserved.
//

import Foundation
import UIKit

let endpoint = "https://data.sfgov.org/resource/ritf-b9ki.json?"

typealias DataSourceCompletedRetrievalFromPage = (EventArray, NSError?) -> ()
typealias EventSet = Set<Event>
typealias EventDictionary = Dictionary<String, EventSet>
typealias EventArray = Array<EventSet>

class EventsDataSource : NSObject {
    
    private var events = Set<Event>()
    
    private var eventsByDistrictDictionary = EventDictionary()
    
    private var eventsByDistrict = EventArray()
    
    private var eventsBySharedEventsByDistrict = EventArray()
    
    var currentPage = 0
    
    private let requestManager = EventRequestManager(endpoint: endpoint, limitOfObjectsPerPage: 1, monthsBack: 1)
    
    func getMoreEvents(handler: DataSourceCompletedRetrievalFromPage) {
        self .performRequestToGetEvents(currentPage) { (arrayOfSetOfEvents, error) -> () in
            if(error == nil) {
                self.currentPage = self.currentPage + 1
            }
            handler(arrayOfSetOfEvents, error)
        }
    }
    
    private func performRequestToGetEvents(page: Int, handler: DataSourceCompletedRetrievalFromPage ) {
        
        self.requestManager.performRequestOnPage(page) { [unowned self] (events, error) -> () in
            
            if (error != nil) {
                handler(self.eventsBySharedEventsByDistrict, error)
                return;
            }
            
            self.events = events
            
            for event in events {
                
                var eventsOfDistrict = self.eventsByDistrictDictionary[event.pddistrict!]
                
                if eventsOfDistrict == nil {
                    eventsOfDistrict = [event]
                } else {
                    eventsOfDistrict?.insert(event)
                }
                
                self.eventsByDistrictDictionary[event.pddistrict!] = eventsOfDistrict
            }
            
            
            //Reset
            self.eventsByDistrict = EventArray()
            
            for (_, eventSet) in self.eventsByDistrictDictionary {
                self.eventsByDistrict.append(eventSet)
            }
            
            self.eventsByDistrict.sortInPlace({ (setA, setB) -> Bool in
                return setA.count > setB.count
            })
            
            //Reset
            self.eventsBySharedEventsByDistrict = EventArray()
            
            var eventsBySharedNumberOfEventsInDistrict = Dictionary<String, Set<Event>>()
            
            for set in self.eventsByDistrict {
                let numberOfEventsPerDistrict = String(set.count)
                let setOnDictionary = eventsBySharedNumberOfEventsInDistrict[numberOfEventsPerDistrict]
                if setOnDictionary != nil {
                    let currentEventsInDictionary = setOnDictionary! as Set<Event>
                    eventsBySharedNumberOfEventsInDistrict[numberOfEventsPerDistrict] = set.union(currentEventsInDictionary)
                }
                else{
                    eventsBySharedNumberOfEventsInDistrict[numberOfEventsPerDistrict] = set
                }
                
            }
            
            let sortedEventsBySharedNumberOfEventsInDistrict = eventsBySharedNumberOfEventsInDistrict.sort { $0.0 < $1.0 }
            
            for (_, set) in sortedEventsBySharedNumberOfEventsInDistrict {
                self.eventsBySharedEventsByDistrict.append(set)
            }
            
            handler(self.eventsBySharedEventsByDistrict, error)
        }
    }
}

