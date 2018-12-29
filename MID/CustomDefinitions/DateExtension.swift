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
    public static let customDateFormat = "yyyy_MM_dd HH:mm:ss"
    
    public var toString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = Date.customDateFormat
        
        return formatter.string(from: self)
    }
}


public extension NSDate {
    public var toString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = Date.customDateFormat
        
        return formatter.string(from: self as Date)
    }
}


public extension String {
    /** Create a Date instance from a customDateFormat formatted String */
    public func toDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = Date.customDateFormat
        
        return formatter.date(from: self)
    }
}
