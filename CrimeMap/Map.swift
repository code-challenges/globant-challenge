//
//  Map.swift
//  CrimeMap
//
//  Created by Julio César Guzman on 12/17/15.
//  Copyright © 2015 Julio. All rights reserved.
//

import Foundation
import MapKit

let sanFranciscoLocation = CLLocation(latitude: 37.7833, longitude: -122.4167)
let regionRadius: CLLocationDistance = 10000

extension MKMapView {
    func centerMapOnLocation(location: CLLocation, radius: CLLocationDistance) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, radius * 2.0, radius * 2.0)
        self.setRegion(coordinateRegion, animated: true)
    }
}

extension UIAlertController {
    static func presentErrorMessage(error: NSError, viewController: UIViewController, title: String, actionTitle: String, handler: () -> ()) {
        let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: actionTitle, style: .Default) { (_) -> Void in
            handler()
        }
        alert.addAction(action)
        viewController.presentViewController(alert, animated: true, completion: nil)
    }
}

class EventAnnotation : NSObject, MKAnnotation {
    
    let event : Event?
    
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
    
    init(event: Event?) {
        self.event = event
        super.init()
    }
    
}

class EventAnnotationFactory : NSObject {
    static func getAnnotations(eventArray : EventArray) -> [EventAnnotation] {
        var annotations = Array<EventAnnotation>()
        for set in eventArray {
            for event in set {
                 annotations.append(EventAnnotation(event: event))
            }
        }
        return annotations
    }
}

class MapViewController : UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!

    var dataSource = EventsDataSource()
    
    override func viewDidLoad() {
        self.title = "CrimeMap"
        mapView.centerMapOnLocation(sanFranciscoLocation, radius: regionRadius)
        mapView.delegate = self
        self.dataSource.getMoreEvents { (eventArray, error) -> () in
            let annotations = EventAnnotationFactory.getAnnotations(eventArray)
            self.mapView.addAnnotations(annotations)
        }
    }
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? EventAnnotation {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
            }
            return view
        }
        return nil
    }
}
