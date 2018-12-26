//
//  Post+CoreDataClass.swift
//  MID
//
//  Created by 江宇揚 on 2018/12/12.
//  Copyright © 2018 Jiang Yuyang. All rights reserved.
//
//

import Foundation
import CoreData


public class Post: NSManagedObject {
    /** Designed initiater from Post */
    public init(from newPost: CodablePost, insertInto context: NSManagedObjectContext){
        super.init(entity: Post.entity(), insertInto: context)
        self.speakerName = newPost.speakerName
        self.speakerID = newPost.speakerID
        self.content = newPost.content
        self.date = Date() as NSDate
    }
    
    /** Designed initiater from all items, and insert into the coreDataContext */
    public init(name: String, ID iDnumber: Int64, content: String, date: Date = Date(), insertInto context: NSManagedObjectContext) {
        super.init(entity: Post.entity(), insertInto: context)
        self.speakerName = name
        self.speakerID = iDnumber
        self.content = content
        self.date = date as NSDate
    }
    
    /** Designed initiater of the superClass */
    override public init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
}

//extension Post: Codable {
//
//    static func ==(lhs: Post, rhs: Post) -> Bool {
//        return lhs.date == rhs.date
//    }
//}
