//
//  Reply+CoreDataClass.swift
//  MID
//
//  Created by 江宇揚 on 2018/12/23.
//  Copyright © 2018 Jiang Yuyang. All rights reserved.
//
//

import Foundation
import CoreData


public class Reply: NSManagedObject {
    // Designed initiater of the superClass of Post
    override public init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    // Designed initiater of Post
    public init(from newReply: CodableReply, insertInto context: NSManagedObjectContext) {
        super.init(entity: Reply.entity(), insertInto: context)
        self.speakerID = newReply.speakerID
        self.speakerName = newReply.speakerName
        self.content = newReply.content
    }
}
