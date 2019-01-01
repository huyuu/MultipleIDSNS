//
//  JSONDataForConnection.swift
//  MID
//
//  Created by 江宇揚 on 2018/12/14.
//  Copyright © 2018 Jiang Yuyang. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import CoreData


/** Helper property to save coreDataContext manully */
public extension CodingUserInfoKey {
    static let coreDataContext = CodingUserInfoKey(rawValue: "coreDataContext")
}


public extension NSSet {
    public func toSet<T>() -> Set<T> {
        guard let valueInSet = self as? Set<T> else {
            raiseFatalError("Can't convert NSSet to Set<T> by NSSet.toSet property.")
            fatalError()
        }
        return valueInSet
    }
    
    public func toArray<T>() -> [T] {
        return self.allObjects as! [T]
    }
}


/** A Dictionary representing JSONDATA */
public typealias JSONDATA = [String: Any]



public extension Int {
    public func toString() -> String {
        return String(self)
    }
}

public extension Int64 {
    public func toString() -> String {
        return String(self)
    }
}



// MARK: - Protocal DecodableFromFIRReference
/**
 Decodable from Firebase Reference (which is basically a String) to JSONDATA.
 * init(from:insertInto): A required init for decoding.
*/
public protocol DecodableFromFIRReference {
    init(fromJSON: JSONDATA, insertInto: NSManagedObjectContext)
}

public extension DecodableFromFIRReference {
    /**
     Get an instance by completionHandler from corresponding Firebase reference.
     - parameter completionHandler: Get a new instance of type Self as parameter. ex: { SNSID in ... }
     - returns: Void. Please use the completion handler to update the UI.
    */
    public static func initFromReference(_ ref: String, insertInto context: NSManagedObjectContext,
                                         completionHandler: @escaping (Self) -> ()) {
        /// Get the reference object from Firebase
        let firebaseRef = Database.database().reference(fromURL: ref)
        /// Observe at ref level
        firebaseRef.observeSingleEvent(of: .value, with: { snapshot in
            // Check if value exists
            guard let instanceInfo = snapshot.value as? JSONDATA else {
                raiseFatalError("snapshot's value is nil.")
                fatalError()
            }
            // Create new Reply from replyInfo
            let newInstance = Self(fromJSON: instanceInfo, insertInto: context)
            // pass it to the completionHandler
            completionHandler(newInstance)
        })
    }
}
