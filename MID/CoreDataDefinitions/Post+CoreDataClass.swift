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
    // Designed initiater of Post
    public init(of newPost: CodablePost, insertInto context: NSManagedObjectContext){
        super.init(entity: Post.entity(), insertInto: context)
        self.speakerName = newPost.speakerName
        self.speakerID = newPost.speakerID
        self.content = newPost.content
    }
    
    // Designed initiater of the superClass of Post
    override public init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
}

