//
//  Post+CoreDataProperties.swift
//  MID
//
//  Created by 江宇揚 on 2018/12/12.
//  Copyright © 2018 Jiang Yuyang. All rights reserved.
//
//

import Foundation
import CoreData


extension Post {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Post> {
        return NSFetchRequest<Post>(entityName: "Post")
    }

    @NSManaged public var speakerID: Int64
    @NSManaged public var speakerName: String
    @NSManaged public var content: String

}
