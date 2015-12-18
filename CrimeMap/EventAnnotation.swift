//
//  EventAnnotation.swift
//  CrimeMap
//
//  Created by Julio César Guzman on 12/18/15.
//  Copyright © 2015 Julio. All rights reserved.
//

import Foundation
import MapKit

class EventAnnotation : NSObject, MKAnnotation {
    
    let event : Event?
    let color : UIColor?
    var coordinate: CLLocationCoordinate2D {
        get{
            let latitude : Double = (event?.y)!
            let longitude : Double = (event?.x)!
            return CLLocationCoordinate2DMake(latitude, longitude)
        }
    }
    
    var title: String? {
        get{
            return String(self.event?.category)
        }
    }
    
    var subtitle: String? {
        get {
            return String(self.event?.date)
        }
    }
    
    init(event: Event?, color : UIColor?) {
        self.event = event
        self.color = color
        super.init()
    }
    
}