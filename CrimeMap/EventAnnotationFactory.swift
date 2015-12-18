//
//  EventAnnotationFactory.swift
//  CrimeMap
//
//  Created by Julio César Guzman on 12/18/15.
//  Copyright © 2015 Julio. All rights reserved.
//

import Foundation
import UIKit

let colors = UIColor.colorsWithHexadecimalArray([0xFF0000, 0xEB3600, 0xe54800, 0xd86d00, 0xd27f00, 0xc5a300, 0xb9c800, 0xa6ff00])

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

class EventAnnotationFactory : NSObject {
    static func getAnnotations(eventArray : EventArray) -> [EventAnnotation] {
        var annotations = Array<EventAnnotation>()
        for set in eventArray {
            for event in set {
                let color = EventAnnotationFactory.color(eventArray, eventSet: set, colorArray: colors)
                annotations.append(EventAnnotation(event: event, color: color))
            }
        }
        return annotations
    }
    
    static func color(events : Array<EventSet>, eventSet : EventSet, colorArray : Array<UIColor>) -> UIColor {
        if events.count == 1 {
            return colorArray.first!
        }
        let index = events.indexOf(eventSet)
        var colorIndex = Int(Float(index!) / Float(events.count - 1) * Float(colors.count))
        if (colorIndex == colorArray.count ){
            colorIndex = colorArray.count - 1
        }
        return colorArray[colorIndex]
    }
}
