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
    
    
    /** All terms initializer from real Post */
    public convenience init(to belongingPost: Post, content: String, date: Date = Date(), selfSNSIDRef: String, insertInto context: NSManagedObjectContext) {
        self.init(entity: Reply.entity(), insertInto: context)
        self.content = content
        self.date = date as NSDate
        self.selfSNSID = nil
        self.selfSNSIDRef = selfSNSIDRef
        self.belongingPost = belongingPost
        self.belongingPostRef = belongingPost.ref
        belongingPost.addToReplies(self)
    }
    
    
    /** All terms initializer from reference Post */
    public convenience init(to belongingPostRef: String, content: String, date: Date = Date(), selfSNSIDRef: String, insertInto context: NSManagedObjectContext) {
        self.init(entity: Reply.entity(), insertInto: context)
        self.content = content
        self.date = date as NSDate
        self.selfSNSID = nil
        self.selfSNSIDRef = selfSNSIDRef
        self.belongingPostRef = belongingPostRef
        self.belongingPost = nil
    }
    
    
    /** For JSON data of snapshot */
    public convenience init(fromJSON jsonData: [String: Any], towards belongingPost: Post? = nil, insertInto context: NSManagedObjectContext) {
        guard let content = jsonData[CodingKeysOfReply.content.rawValue] as? String,
            let date = jsonData[CodingKeysOfReply.date.rawValue] as? Date,
            let belongingPostRef = jsonData[CodingKeysOfReply.belongingPostRef.rawValue] as? String,
            let selfSNSIDRef = jsonData[CodingKeysOfReply.selfSNSIDRef.rawValue] as? String else {
                raiseFatalError("Some keys are not matched to the properties of Reply.")
                fatalError()
        }
        // Check whether real post exists
        if let belongingPost = belongingPost {
            // Use real post for initialization
            self.init(to: belongingPost, content: content, date: date, selfSNSIDRef: selfSNSIDRef, insertInto: context)
        } else {
            // Use reference post for initialization
            self.init(to: belongingPostRef, content: content, date: date, selfSNSIDRef: selfSNSIDRef, insertInto: context)
        }
    }
    
    
    
    // MARK: - For Codable
    // Fixme
    
    enum CodingKeysOfReply: String, CodingKey {
        typealias RawValue = String
        case content
        case date
        case belongingPostRef
        case selfSNSIDRef
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
        self.belongingPostRef = try container.decode(String.self, forKey: .belongingPostRef)
        self.selfSNSIDRef = try container.decode(String.self, forKey: .selfSNSIDRef)
    }
    
    
    /** For Encodable */
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeysOfReply.self)
        try container.encode(self.content, forKey: .content)
        try container.encode(self.date as Date, forKey: .date)
        try container.encode(self.belongingPostRef, forKey: .belongingPostRef)
        try container.encode(self.selfSNSIDRef, forKey: .selfSNSIDRef)
    }
    
    
    /** Create JSON data */
    var toJSON: Dictionary<String, Any> {
        return [
            CodingKeysOfReply.content.rawValue: self.content,
            CodingKeysOfReply.date.rawValue: self.date,
            CodingKeysOfReply.belongingPostRef.rawValue: self.belongingPostRef,
            CodingKeysOfReply.selfSNSIDRef.rawValue: self.selfSNSIDRef
        ]
    }
}
