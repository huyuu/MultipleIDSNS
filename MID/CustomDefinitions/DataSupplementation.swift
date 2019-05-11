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
//public extension CodingUserInfoKey {
//    static let coreDataContext = CodingUserInfoKey(rawValue: "coreDataContext")
//}
//
//
//public extension NSSet {
//    public func toSet<T>() -> Set<T> {
//        guard let valueInSet = self as? Set<T> else {
//            raiseFatalError("Can't convert NSSet to Set<T> by NSSet.toSet property.")
//            fatalError()
//        }
//        return valueInSet
//    }
//
//    public func toArray<T>() -> [T] {
//        return self.allObjects as! [T]
//    }
//}


/** A Dictionary representing JSONDATA */
public typealias JSONDATA = [String: Any]


extension Dictionary where Key == String, Value == Any {
    /** Expand a JSONDATA to its bottom level. */
    public func expanded() -> JSONDATA {
        var returnJSON: JSONDATA = [:]
        for (key, value) in self {
            if let stringValue = value as? String {
                returnJSON[key] = stringValue
            } else if let jsonData = value as? JSONDATA {
                returnJSON[key] = jsonData.expanded()
            } else {
                raiseFatalError("ValueError occured in 'expanded' method. Value is neither String nor JSONDATA.")
            }
        }
        return returnJSON
    }
}



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
    init(fromJSON: JSONDATA)
    var ref: String { get }
}

public extension DecodableFromFIRReference {    
    /**
     Get an instance by completionHandler from corresponding Firebase reference.
     - parameter completionHandler: Get a new instance of type Self as parameter. ex: { SNSID in ... }
     - returns: Void. Please use the completion handler to update the UI.
    */
    public static func initSelf(fromReference ref: String,
                                runQueue: DispatchQueue=DispatchQueue.global(),
                                completionQueue: DispatchQueue=DispatchQueue.main,
                                completionHandler: @escaping (Self) -> ()) {
        runQueue.async {
            /// Get the reference object from Firebase
            let firebaseRef = Database.database().reference(fromURL: ref)
            /// Observe at ref level
            firebaseRef.observeSingleEvent(of: .value, with: { snapshot in
                /// Check if value exists
                guard let instanceInfo = snapshot.value as? JSONDATA else {
                    raiseFatalError("snapshot's value is nil.")
                    fatalError()
                }
                
                /// Create new Reply from replyInfo
                let newInstance = Self(fromJSON: instanceInfo)
                /// pass it to the completionHandler
                completionQueue.async {
                    completionHandler(newInstance)
                }
            })
        }
    }
    
    /**
     Return sa DecodableFromFIRReference type. _Note_ that returnValue must be declare as a explicity type.
     ***
     Example:
     ```
     newAccount.initChildren(for: Account.CodingKeysOfAccount.snsids.rawValue, insertInto: self.coreDataContext,
        completionHandler: { (snsids: [SNSID]?) in
        self.localStoredIDs = snsids
        self.tableView.reloadData()
     })
     ```
    */
    public func initChildren<T: DecodableFromFIRReference>(for key: String,
                                                           completionQueue: DispatchQueue=DispatchQueue.main,
                                                           completionHandler: @escaping ([T]) -> ()) {
        /// Get the reference object from Firebase
        let firebaseRef = Database.database().reference(fromURL: self.ref)
        /// Observe at ref level
        firebaseRef.observeSingleEvent(of: .value, with: { snapshot in
            // Check if value exists
            guard let _ = snapshot.value as? JSONDATA else {
                raiseFatalError("snapshot's value is nil.")
                fatalError()
            }
            // Create new children
//            if let children: [T] = snapshot.childSnapshot(forPath: key).decodeToChildren() {
//                completionQueue.async {
//                    completionHandler(children)
//                }
//            } else {
//                completionQueue.async {
//                    completionHandler(nil)
//                }
//            }
            snapshot.childSnapshot(forPath: key).decodeToChildren(completionQueue: completionQueue,
                                                                  completionHandler: { (children) in
                completionHandler(children)
            })
        })
    }
}



public protocol EncodableToFIRReference {
    func toJSON() -> JSONDATA
}

extension EncodableToFIRReference {
    /// Presume FIRReference string of a specific member.
    public static func presumeRefOf(tankType: TankType, member: String) -> String {
        let firebaseRoot = Database.database().reference(withPath: "")
        return firebaseRoot.child("\(tankType.rawValue)Tank").child(member).url
    }
}



// MARK: - Support enum for EncodableToFIRReference
/// Tell the compiler which type is the data
public enum TankType: String {
    public typealias RawValue = String
    case user
    case snsid
    case post
    case reply
    case topic
}
