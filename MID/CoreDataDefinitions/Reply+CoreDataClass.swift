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
import Firebase


public class Reply: NSManagedObject, Codable {
    // Designed initiater of the superClass of Post
    override public init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    
    /** All terms initializer */
    public convenience init(of belongingPost: Post, content: String, date: Date = Date(), insertInto context: NSManagedObjectContext) {
        self.init(entity: Reply.entity(), insertInto: context)
        self.content = content
        self.date = date as NSDate
        self.belongingPost = belongingPost
        belongingPost.addToReplies(self)
    }
    
    
    /** For JSON data of snapshot */
    public convenience init(fromJSON jsonData: [String: Any], belongsTo belongingPost: Post, insertInto context: NSManagedObjectContext) {
        guard let content = jsonData["content"] as? String,
            let date = jsonData["date"] as? Date else {
                raiseFatalError("Some keys are not matched to the properties of Reply.")
                fatalError()
        }
        
        self.init(of: belongingPost, content: content, date: date, insertInto: context)
    }
    
    
    
    // MARK: - For Codable
    
    enum CodingKeysOfReply: String, CodingKey {
        typealias RawValue = String
        case content
        case date
        case belongingPost
    }
    
    
    /** Required init for Decodable */
    public required convenience init(from decoder: Decoder) throws {
        // Get coreDataContext from CodingUserInfoKey
        guard let codingUserInfoKeyCoreDataContext = CodingUserInfoKey.coreDataContext,
            let context = decoder.userInfo[codingUserInfoKeyCoreDataContext] as? NSManagedObjectContext else {
                raiseFatalError("Can't get coreDataContext from CodingUserInfoKey")
                fatalError()
        }
        
        // At this moment, the instance is firstly initiated
        self.init(entity: Reply.entity(), insertInto: context)
        
        let container = try decoder.container(keyedBy: CodingKeysOfReply.self)
        self.content = try container.decode(String.self, forKey: .content)
        self.date = try container.decode(Date.self, forKey: .date) as NSDate
        self.belongingPost = try container.decode(Post.self, forKey: .belongingPost)
    }
    
    
    /** For Encodable */
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeysOfReply.self)
        try container.encode(self.content, forKey: .content)
        try container.encode(self.date as Date, forKey: .date)
        try container.encode(self.belongingPost, forKey: .belongingPost)
    }
    
    
    /** Create JSON data */
    var toJSON: Dictionary<String, Any> {
        return [
            "content": self.content,
            "date": self.date,
            "belongingPost": self.belongingPost
        ]
    }
}
