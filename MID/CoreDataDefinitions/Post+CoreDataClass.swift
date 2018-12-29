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
import Firebase


public class Post: NSManagedObject, Codable {
    
    /** Designed initiater from all items, and insert into the coreDataContext */
    public convenience init(of speaker: SNSID, content: String, date: Date = Date(), insertInto context: NSManagedObjectContext) {
        self.init(entity: Post.entity(), insertInto: context)
        self.content = content
        self.date = date as NSDate
        self.speaker = speaker
        self.iDnumber = Int64(date.toString.hashValue)
        speaker.addToPosts(self)
    }
    
    
    /** Designed initiater of the superClass */
    override public init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    
    /**  For JSON data of snapshot */
    public convenience init(fromJSON jsonData: JSONDATA, speaker: SNSID, insertInto context: NSManagedObjectContext) {
        guard let content = jsonData["content"] as? String,
            let dateString = jsonData["date"] as? String ,
            let date = dateString.toDate() else {
                raiseFatalError("Some keys are not matched to the properties of Post.")
                fatalError()
        }
        self.init(of: speaker, content: content, date: date, insertInto: context)
        // If any reply exists
        if let replies = jsonData["replies"] as? JSONDATA {
            for reply in replies {
                // Get replyInformation from reply. Mark that reply.key = reply.iDnumber; and reply.value = [String: Any] dictionary
                if let replyInfo = reply.value as? JSONDATA {
                    let newReply = Reply(fromJSON: replyInfo, belongsTo: self, insertInto: context)
                    self.addToReplies(newReply)
                }
            }
        }
    }
    
    
    
    // MARK: - For Codable
    
    enum CodingKeysOfPost: String, CodingKey {
        typealias RawValue = String
        case content
        case date
        case replies
        case speaker
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
        self.init(entity: Post.entity(), insertInto: context)
        
        let container = try decoder.container(keyedBy: CodingKeysOfPost.self)
        self.content = try container.decode(String.self, forKey: .content)
        self.date = try container.decode(Date.self, forKey: .date) as NSDate
        self.speaker = try container.decode(SNSID.self, forKey: .speaker)
        self.replies = try container.decodeIfPresent(Set<Reply>.self, forKey: .replies) as NSSet?
    }
    
    
    /** For Encodable */
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeysOfPost.self)
        try container.encode(self.content, forKey: .content)
        try container.encode(self.date as Date, forKey: .date)
        try container.encode(self.speaker, forKey: .speaker)
        if let nssetReplies = self.replies { // At least one reply exists
            // Check if NSSet is convertible to Set<Reply>
            guard let setReplies = nssetReplies as? Set<Reply> else {
                raiseFatalError("Can't convert NSSet into Set<Reply> when encoding.")
                fatalError()
            }
            try container.encode(setReplies, forKey: .replies)
        }
    }
    
    
    /** Create JSON data */
//    var toJSON: Dictionary<String, Any> {
//        if let replies = self.replies {
//            return [
//                "content": self.content,
//                "date": self.date,
//                "speaker": self.speaker,
//                "replies": (replies.allObjects as! [Reply]).map{ $0.toJSON }
//            ]
//        } else {
//            return [
//                "content": self.content,
//                "date": self.date,
//                "speaker": self.speaker,
//            ]
//        }
//    }
    
    
    var toJSON: Dictionary<String, Any> {
        return [
            "content": self.content,
            "date": (self.date as Date).toString
        ]
    }
}


