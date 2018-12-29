//
//  Post+CoreDataProperties.swift
//  MID
//
//  Created by 江宇揚 on 2018/12/29.
//  Copyright © 2018 Jiang Yuyang. All rights reserved.
//
//

import Foundation
import CoreData


extension Post {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Post> {
        return NSFetchRequest<Post>(entityName: "Post")
    }

    @NSManaged public var content: String
    @NSManaged public var date: NSDate
    @NSManaged public var iDnumber: Int64
    @NSManaged public var replies: NSSet?
    @NSManaged public var speaker: SNSID

}

// MARK: Generated accessors for replies
extension Post {

    @objc(addRepliesObject:)
    @NSManaged public func addToReplies(_ value: Reply)

    @objc(removeRepliesObject:)
    @NSManaged public func removeFromReplies(_ value: Reply)

    @objc(addReplies:)
    @NSManaged public func addToReplies(_ values: NSSet)

    @objc(removeReplies:)
    @NSManaged public func removeFromReplies(_ values: NSSet)

}
