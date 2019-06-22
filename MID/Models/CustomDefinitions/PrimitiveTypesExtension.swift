//
//  DateExtension.swift
//  MID
//
//  Created by 江宇揚 on 2018/12/29.
//  Copyright © 2018 Jiang Yuyang. All rights reserved.
//

import Foundation
import UIKit

public extension Date {
    public static let customDateFormatForTransmission = "yyyy_MM_dd HH:mm:ss"
    public static let customDateFormatForPresentation = "yyyy/MM/dd HH:mm:ss"
    
    /** To String type for remote connection */
    public var toString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = Date.customDateFormatForTransmission
        
        return formatter.string(from: self)
    }
    
    /** To String type for UI presentation */
    public var toStringForPresentation: String {
        let formatter = DateFormatter()
        formatter.dateFormat = Date.customDateFormatForPresentation
        
        return formatter.string(from: self)
    }
}


public extension NSDate {
    /** To String type for remote connection */
    public var toString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = Date.customDateFormatForTransmission
        
        return formatter.string(from: self as Date)
    }
    
    /** To String type for UI presentation */
    public var toStringForPresentation: String {
        let formatter = DateFormatter()
        formatter.dateFormat = Date.customDateFormatForPresentation
        
        return formatter.string(from: self as Date)
    }
}


public extension String {
    /** Create a Date instance from a customDateFormat formatted String */
    public func toDate() -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = Date.customDateFormatForTransmission
        
        return formatter.date(from: self)
    }
}



public extension CGPoint {
    func distance(from point: CGPoint, normalizedBy maxDistance: CGFloat=1.0) -> CGFloat {
        let X = self.x-point.x
        let Y = self.y-point.y
        return sqrt( X*X + Y*Y ) / maxDistance
    }
    
    
    func angle(from point: CGPoint, normalizedBy maxAngle: CGFloat=1.0) -> CGFloat {
        let vector = self.vector(from: point)
        var angle = atan2(vector.y, vector.x)
        if angle < 0 { angle += 2*CGFloat.pi }
        
        return angle / maxAngle
    }
    
    
    static func *(left: CGPoint, right: CGPoint) -> CGFloat {
        let x = left.x * right.x
        let y = left.y * right.y
        return x+y
    }
    
    
    static func *(left: CGPoint, right: CGFloat) -> CGPoint {
        let x = left.x * right
        let y = left.y * right
        return CGPoint(x: x, y: y)
    }
    
    
    static func *(left: CGFloat, right: CGPoint) -> CGPoint {
        let x = left * right.x
        let y = left * right.y
        return CGPoint(x: x, y: y)
    }
    
    
    static func -(left: CGPoint, right: CGPoint) -> CGPoint {
        let x = left.x - right.x
        let y = left.y - right.y
        return CGPoint(x: x, y: y)
    }
    
    
    static func +(left: CGPoint, right: CGPoint) -> CGPoint {
        let x = left.x + right.x
        let y = left.y + right.y
        return CGPoint(x: x, y: y)
    }
    
    
    func vector(from origin: CGPoint) -> CGPoint {
        let x = self.x - origin.x
        let y = self.y - origin.y
        return CGPoint(x: x, y: y)
    }
}
