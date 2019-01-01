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
    public func decodeToSNSIDs(insertInto context: NSManagedObjectContext) -> [SNSID]? {
        // Check if snapshot contains a set of snsids
        if self.key == Account.CodingKeysOfAccount.snsids.rawValue,
            let instancesSet = self.value as? JSONDATA {
            // We choose an Array object here according to the return value
            var newInstances: [SNSID] = []
            // key: name, value: snsidInfo
            for instance in instancesSet {
                // Check if snsid.value contains snsidInfo
                if let instanceInfo = instance.value as? JSONDATA {
                    let newInstance = SNSID(fromJSON: instanceInfo, insertInto: context)
                    newInstances.append(newInstance)
                }
            }
            return newInstances
        } else {
            return nil
        }
    }
    
    
    public func decodeToPosts(insertInto context: NSManagedObjectContext) -> [Post]? {
        // Check if snapshot contains a set of posts
        if self.key == SNSID.CodingKeysOfSNSID.myPosts.rawValue,
            let instancesSet = self.value as? JSONDATA {
            // We choose an Array object here according to the return value
            var newInstances: [Post] = []
            // key: date, value: postInfo
            for instance in instancesSet {
                // Check if postInfo.value contains postInfo
                if let instanceInfo = instance.value as? JSONDATA {
                    let newInstance = Post(fromJSON: instanceInfo, insertInto: context)
                    newInstances.append(newInstance)
                }
            }
            return newInstances
        } else {
            return nil
        }
    }
    
    
    public func decodeToReplies(insertInto context: NSManagedObjectContext) -> [Reply]? {
        // Check if snapshot contains a set of replies
        if self.key == Post.CodingKeysOfPost.replies.rawValue,
            let instancesSet = self.value as? JSONDATA {
            // We choose an Array object here according to the return value
            var newInstances: [Reply] = []
            // key: date, value: replyInfo
            for instance in instancesSet {
                // Check if postInfo.value contains postInfo
                if let instanceInfo = instance.value as? JSONDATA {
                    let newInstance = Reply(fromJSON: instanceInfo, insertInto: context)
                    newInstances.append(newInstance)
                }
            }
            return newInstances
        } else {
            return nil
        }
    }
}


