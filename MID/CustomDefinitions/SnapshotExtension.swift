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
    public func decodeToSNSID(owner: Account, insertInto context: NSManagedObjectContext) -> [SNSID]? {
        var newInstances: [SNSID] = []
        
        // Check if snapshot contains a set of snsids
        if let instancesSet = self.value as? JSONDATA {
            // key: iDnumber, value: snsidInfo
            for instance in instancesSet {
                // Check if snsid.value contains snsidInfo
                if let instanceInfo = instance.value as? JSONDATA {
                    let newInstance = SNSID(fromJSON: instanceInfo, owner: owner, insertInto: context)
                    newInstances.append(newInstance)
                }
            }
            return newInstances
        } else {
            return nil
        }
    }
    
    public func decodeToPost(speaker: SNSID, insertInto context: NSManagedObjectContext) -> [Post]? {
        var newInstances: [Post] = []
        // Check if snapshot contains a set of posts
        if let instancesSet = self.value as? JSONDATA {
            // key: iDnumber, value: postInfo
            for instance in instancesSet {
                // Check if postInfo.value contains postInfo
                if let instanceInfo = instance.value as? JSONDATA {
                    let newInstance = Post(fromJSON: instanceInfo, speaker: speaker, insertInto: context)
                    newInstances.append(newInstance)
                }
            }
            return newInstances
        } else {
            return nil
        }
    }
}
