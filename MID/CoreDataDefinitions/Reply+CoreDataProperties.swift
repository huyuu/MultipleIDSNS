//
//  Reply+CoreDataProperties.swift
//  MID
//
//  Created by 江宇揚 on 2018/12/30.
//  Copyright © 2018 Jiang Yuyang. All rights reserved.
//
//

import Foundation
import CoreData


extension Reply {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Reply> {
        return NSFetchRequest<Reply>(entityName: "Reply")
    }

    @NSManaged public var content: String
    @NSManaged public var date: NSDate
    @NSManaged public var belongingPostRef: String
    @NSManaged public var selfSNSIDRef: String
    @NSManaged public var belongingPost: Post?
    @NSManaged public var selfSNSID: SNSID?

}
