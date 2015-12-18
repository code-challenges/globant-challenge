//
//  Map.swift
//  CrimeMap
//
//  Created by Julio César Guzman on 12/17/15.
//  Copyright © 2015 Julio. All rights reserved.
//

import Foundation
import MapKit
import LCCoolHUD

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

class MapViewDelegate : NSObject, MKMapViewDelegate {
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let annotation = annotation as? EventAnnotation {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            }
            view.pinTintColor = annotation.color
            return view
        }
        
        return nil
    }
}

class MapViewController : UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!

    var dataSource = EventsDataSource()
    var mapViewDelegate = MapViewDelegate()
    
    override func viewDidLoad() {
        self.title = "CrimeMap"
        mapView.centerMapOnLocation(sanFranciscoLocation, radius: regionRadius)
        mapView.delegate = self.mapViewDelegate
        self.showMoreAnnotationsOnMapView()
    }
    
    @IBAction func getMoreEventsAction(sender: AnyObject) {
        self.showMoreAnnotationsOnMapView()
    }
    
    func showMoreAnnotationsOnMapView () {
        LCCoolHUD.showLoading("Loading")
        self.dataSource.getMoreEvents { (eventArray, error) -> () in
            LCCoolHUD.hideInKeyWindow()
            if error == nil {
                let annotations = EventAnnotationFactory.getAnnotations(eventArray)
                self.mapView.removeAnnotations(self.mapView.annotations)
                self.mapView.addAnnotations(annotations)
            }
            else {
                UIAlertController.presentErrorMessage(error!, viewController: self, title: "Error", actionTitle: "Retry", handler: { () -> () in
                    self.showMoreAnnotationsOnMapView()
                })
            }
        }
    }
    

}
