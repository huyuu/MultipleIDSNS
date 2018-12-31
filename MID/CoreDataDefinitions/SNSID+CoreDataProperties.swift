//
//  SNSID+CoreDataProperties.swift
//  MID
//
//  Created by 江宇揚 on 2018/12/31.
//  Copyright © 2018 Jiang Yuyang. All rights reserved.
//
//

import Foundation
import CoreData


extension SNSID {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SNSID> {
        return NSFetchRequest<SNSID>(entityName: "SNSID")
    }

    @NSManaged public var name: String
    @NSManaged public var ref: String
    @NSManaged public var ownerRef: String
    @NSManaged public var myPosts: NSSet?
    @NSManaged public var publishedReplies: NSSet?

}

// MARK: Generated accessors for myPosts
extension SNSID {

    @objc(addMyPostsObject:)
    @NSManaged public func addToMyPosts(_ value: Post)

    @objc(removeMyPostsObject:)
    @NSManaged public func removeFromMyPosts(_ value: Post)

    @objc(addMyPosts:)
    @NSManaged public func addToMyPosts(_ values: NSSet)

    @objc(removeMyPosts:)
    @NSManaged public func removeFromMyPosts(_ values: NSSet)

}

// MARK: Generated accessors for publishedReplies
extension SNSID {

    @objc(addPublishedRepliesObject:)
    @NSManaged public func addToPublishedReplies(_ value: Reply)

    @objc(removePublishedRepliesObject:)
    @NSManaged public func removeFromPublishedReplies(_ value: Reply)

    @objc(addPublishedReplies:)
    @NSManaged public func addToPublishedReplies(_ values: NSSet)

    @objc(removePublishedReplies:)
    @NSManaged public func removeFromPublishedReplies(_ values: NSSet)

}
