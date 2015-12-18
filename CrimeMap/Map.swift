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
let endpoint = "https://data.sfgov.org/resource/ritf-b9ki.json?"
let colors = UIColor.colorsWithHexadecimalArray([0xFF0000, 0xEB3600, 0xe54800, 0xd86d00, 0xd27f00, 0xc5a300, 0xb9c800, 0xa6ff00])

extension MKMapView {
    func centerMapOnLocation(location: CLLocation, radius: CLLocationDistance) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, radius * 2.0, radius * 2.0)
        self.setRegion(coordinateRegion, animated: true)
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hexadecimalNumber:Int) {
        self.init(red:(hexadecimalNumber >> 16) & 0xff, green:(hexadecimalNumber >> 8) & 0xff, blue:hexadecimalNumber & 0xff)
    }
    
    static func colorsWithHexadecimalArray(hexadecimalArray : [Int]) -> [UIColor] {
        var result = Array<UIColor>()
        for hex in hexadecimalArray {
            result.append(UIColor(hexadecimalNumber: hex))
        }
        return result
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

class MapViewDataSource : NSObject {
    
    var eventsByDistrict = Dictionary<String, Array<Event>>()
    
    func performRequestToGetEvents() {
        
    }
}

    
class MapViewController : UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!

    var dataSource = MapViewDataSource()
    
    override func viewDidLoad() {
        self.title = "CrimeMap"
        mapView.centerMapOnLocation(sanFranciscoLocation, radius: regionRadius)
        mapView.delegate = self
//        self.performRequestToAddAnnotations()
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
