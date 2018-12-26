//
//  SNSID+CoreDataProperties.swift
//  MID
//
//  Created by 江宇揚 on 2018/12/25.
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
    @NSManaged public var iDnumber: Int64
    @NSManaged public var posts: NSSet?

}

// MARK: Generated accessors for posts
extension SNSID {

    @objc(addPostsObject:)
    @NSManaged public func addToPosts(_ value: Post)

    @objc(removePostsObject:)
    @NSManaged public func removeFromPosts(_ value: Post)

    @objc(addPosts:)
    @NSManaged public func addToPosts(_ values: NSSet)

    @objc(removePosts:)
    @NSManaged public func removeFromPosts(_ values: NSSet)

}
