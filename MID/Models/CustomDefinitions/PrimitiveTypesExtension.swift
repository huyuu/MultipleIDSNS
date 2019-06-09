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
