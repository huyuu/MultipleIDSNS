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
    public func decodeToSNSIDs(owner: Account, insertInto context: NSManagedObjectContext) -> [SNSID]? {
        var newInstances: [SNSID] = []
        // Check if snapshot contains a set of snsids
        if self.key == Account.CodingKeysOfAccount.snsids.rawValue,
            let instancesSet = self.value as? JSONDATA {
            // key: name, value: snsidInfo
            for instance in instancesSet {
                // Check if snsid.value contains snsidInfo
                if let instanceInfo = instance.value as? JSONDATA {
                    let newInstance = SNSID(fromJSON: instanceInfo, owner: owner, ref: instance.key, insertInto: context)
                    newInstances.append(newInstance)
                }
            }
            return newInstances
        } else {
            return nil
        }
    }

    
    
    public func decodeToPosts(speaker: SNSID, insertInto context: NSManagedObjectContext) -> [Post]? {
        var newInstances: [Post] = []
        // Check if snapshot contains a set of posts
        if self.key == SNSID.CodingKeysOfSNSID.myPosts.rawValue,
            let instancesSet = self.value as? JSONDATA {
            // key: date, value: postInfo
            for instance in instancesSet {
                // Check if postInfo.value contains postInfo
                if let instanceInfo = instance.value as? JSONDATA {
                    let newInstance = Post(fromJSON: instanceInfo, speaker: speaker, ref: self.ref.url, insertInto: context)
                    newInstances.append(newInstance)
                }
            }
            return newInstances
        } else {
            return nil
        }
    }
    
    
    public func decodeToReplies(belongingPost: Post, insertInto context: NSManagedObjectContext) -> [Reply]? {
        var newInstances: [Reply] = []
        // Check if snapshot contains a set of replies
        if self.key == Post.CodingKeysOfPost.replies.rawValue,
            let instancesSet = self.value as? JSONDATA {
            // key: date, value: replyInfo
            for instance in instancesSet {
                // Check if postInfo.value contains postInfo
                if let instanceInfo = instance.value as? JSONDATA {
                    let newInstance = Reply(fromJSON: instanceInfo, towards: belongingPost, insertInto: context)
                    newInstances.append(newInstance)
                }
            }
            return newInstances
        } else {
            return nil
        }
    }
}


public extension String {
    public func addChild(_ path: String) -> String {
        return "\(self)/\(path)"
    }
}
