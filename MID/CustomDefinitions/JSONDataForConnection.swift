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






//public struct CodablePost: Codable {
//    let speakerName: String
//    let speakerID: Int64
//    let content: String
//    let date: Date
//    var replies: [CodableReply]?
//    
//    // Initializer direct for CoreData type 'Post'
//    init(_ post: Post) {
//        self.speakerName = post.speakerName
//        self.speakerID = post.speakerID
//        self.content = post.content
//        self.date = Date()
//        self.replies = nil
//    }
//}
//
//
//public struct CodableReply: Codable {
//    let speakerName: String
//    let speakerID: Int64
//    let content: String
//}
//
//
//public struct CodableSNSID: Codable {
//    let name: String
//    let iDnumber: Int64
//    let posts: [CodablePost]?
//}
