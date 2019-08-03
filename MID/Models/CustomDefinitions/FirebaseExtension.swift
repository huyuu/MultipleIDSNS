//
//  SnapshotExtension.swift
//  MID
//
//  Created by 江宇揚 on 2018/12/29.
//  Copyright © 2018 Jiang Yuyang. All rights reserved.
//

import Foundation
import CoreData
import Firebase
import UIKit


public extension DataSnapshot {
//    public func decodeToSNSIDs(insertInto context: NSManagedObjectContext) -> [SNSID]? {
//        // Check if snapshot contains a set of snsids
//        if self.key == Account.CodingKeysOfAccount.snsids.rawValue,
//            let instancesSet = self.value as? JSONDATA {
//            // We choose an Array object here according to the return value
//            var newInstances: [SNSID] = []
//            // key: name, value: snsidInfo
//            for instance in instancesSet {
//                // Check if snsid.value contains snsidInfo
//                if let instanceInfo = instance.value as? JSONDATA {
//                    let newInstance = SNSID(fromJSON: instanceInfo, insertInto: context)
//                    newInstances.append(newInstance)
//                }
//            }
//            return newInstances
//        } else {
//            return nil
//        }
//    }
//
//
//    public func decodeToPosts(insertInto context: NSManagedObjectContext) -> [Post]? {
//        // Check if snapshot contains a set of posts
//        if self.key == SNSID.CodingKeysOfSNSID.myPosts.rawValue,
//            let instancesSet = self.value as? JSONDATA {
//            // We choose an Array object here according to the return value
//            var newInstances: [Post] = []
//            // key: date, value: postInfo
//            for instance in instancesSet {
//                // Check if postInfo.value contains postInfo
//                if let instanceInfo = instance.value as? JSONDATA {
//                    let newInstance = Post(fromJSON: instanceInfo, insertInto: context)
//                    newInstances.append(newInstance)
//                }
//            }
//            return newInstances
//        } else {
//            return nil
//        }
//    }
//
//
//    public func decodeToReplies(insertInto context: NSManagedObjectContext) -> [Reply]? {
//        // Check if snapshot contains a set of replies
//        if self.key == Post.CodingKeysOfPost.replies.rawValue,
//            let instancesSet = self.value as? JSONDATA {
//            // We choose an Array object here according to the return value
//            var newInstances: [Reply] = []
//            // key: date, value: replyInfo
//            for instance in instancesSet {
//                // Check if postInfo.value contains postInfo
//                if let instanceInfo = instance.value as? JSONDATA {
//                    let newInstance = Reply(fromJSON: instanceInfo, insertInto: context)
//                    newInstances.append(newInstance)
//                }
//            }
//            return newInstances
//        } else {
//            return nil
//        }
//    }
    
    
    /**
     Generate T from TList property. (example: get [SNSID] from snsids.)
    */
    func decodeToChildren<T: DecodableFromFIRReference>(runQueue: DispatchQueue=DispatchQueue.global(),
                                                               completionQueue: DispatchQueue,
                                                               completionHandler: @escaping ([T]) -> ()) {
//        let group = DispatchGroup()
        // We choose an Array object here according to the return value
        var newInstances: [T] = []
        
        runQueue.async {
            // Check if snapshot contains a set of replies
            if let instancesSet = self.value as? JSONDATA {
                // key: date, value: replyInfo
                for instance in instancesSet {
                    // Check if postInfo.value contains postInfo
                    if let instanceInfo = instance.value as? JSONDATA {
//                        group.enter()
                        T.initSelf(fromReference: instanceInfo["ref"] as! String, completionHandler: { (newInstance) in
                            newInstances.append(newInstance)
//                            group.leave()
                            completionQueue.async {
                                completionHandler(newInstances)
                            }
                        })
                    }
                }
            } else {
                newInstances = []
                completionQueue.async {
                    completionHandler(newInstances)
                }
            }
        }
        
        
    }
}



extension Database {
    public static func rootReference() -> DatabaseReference {
        return Database.database().reference()
    }
    
    public static let userTankReference: DatabaseReference = Database.database().reference().child("userTank")
    public static let snsidTankReference: DatabaseReference = Database.database().reference().child("snsidTank")
    public static let topicTankReference: DatabaseReference = Database.database().reference().child("topicTank")
}



extension DatabaseReference {
    public func addressNewPostReference(Of speaker: SNSID, at currentTime: Date) -> DatabaseReference {
        let childPath = "\(speaker.owner)&&\(speaker.name)&&\(currentTime.toString)"
        // if self is ../postTank
        if self.url == Database.rootReference().child("postTank").url {
            return self.child(childPath)
        } else {
            return Database.rootReference().child("postTank").child(childPath)
        }
    }
}



extension String {
    /// Generate FIRDatabaseReference from String.
    var getFIRDatabaseReference: DatabaseReference {
        let firebaseRef = Database.database().reference(fromURL: self)
        return firebaseRef
    }
}

