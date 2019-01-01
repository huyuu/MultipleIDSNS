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


public protocol DecodableFromFIRReference {
    init(fromJSON: JSONDATA, insertInto: NSManagedObjectContext)
}

public extension DecodableFromFIRReference {
    public static func initFromReference(_ ref: String, insertInto context: NSManagedObjectContext,
                                         completionHandler: @escaping (Reply) -> ()) {
        /// Get the reference object from Firebase
        let firebaseRef = Database.database().reference(fromURL: ref)
        /// Observe at ref level
        firebaseRef.observeSingleEvent(of: .value, with: { snapshot in
            // Check if value exists
            guard let replyInfo = snapshot.value as? JSONDATA else {
                raiseFatalError("snapshot's value is nil.")
                fatalError()
            }
            // Add Create new Reply from replyInfo
            let newReply = Reply(fromJSON: replyInfo, insertInto: context)
            // pass it to the completionHandler
            completionHandler(newReply)
        })
    }
}
