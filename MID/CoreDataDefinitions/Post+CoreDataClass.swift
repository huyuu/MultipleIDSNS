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
    // MARK: - Initializers
    /** Designed initiater of the superClass */
    override public init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    
    /** Designed initiater from all items, and insert into the coreDataContext */
    public convenience init(speakerRef: String, speakerName: String, content: String, date: Date = Date(), replies: Set<Reply>? = nil, ref: String, insertInto context: NSManagedObjectContext) {
        self.init(entity: Post.entity(), insertInto: context)
        self.content = content
        self.date = date as NSDate
        self.speakerRef = speakerRef
        self.speakerName = speakerName
        self.ref = ref
        // If there exists any reply
        self.replies = replies as NSSet?
    }
    
    
    
    /**  For JSON data of snapshot */
    public required convenience init(fromJSON jsonData: JSONDATA, insertInto context: NSManagedObjectContext) {
        guard let content = jsonData[CodingKeysOfPost.content.rawValue] as? String,
            let dateString = jsonData[CodingKeysOfPost.date.rawValue] as? String ,
            let date = dateString.toDate(),
            let speakerRef = jsonData[CodingKeysOfPost.speakerRef.rawValue] as? String,
            let speakerName = jsonData[CodingKeysOfPost.speakerName.rawValue] as? String,
            let ref = jsonData[CodingKeysOfPost.ref.rawValue] as? String else {
                raiseFatalError("Some keys are not matched to the properties of Post.")
                fatalError()
        }
        // If any reply exists
        if let replies = jsonData[CodingKeysOfPost.replies.rawValue] as? JSONDATA {
            var repliesContainer: Set<Reply> = []
            for reply in replies {
                // Get replyInformation from reply. Mark that reply.key = reply.iDnumber; and reply.value = [String: Any] dictionary
                if let replyInfo = reply.value as? JSONDATA {
                    repliesContainer.insert(Reply(fromJSON: replyInfo, insertInto: context))
                }
            }
            self.init(speakerRef: speakerRef, speakerName: speakerName, content: content, date: date, replies: repliesContainer, ref: ref, insertInto: context)
        } else {
            self.init(speakerRef: speakerRef, speakerName: speakerName, content: content, date: date, ref: ref, insertInto: context)
        }
        
    }

        
    
    // MARK: - For Codable
    
    enum CodingKeysOfPost: String, CodingKey {
        typealias RawValue = String
        case content
        case date
        case replies
        case speakerRef
        case speakerName
        case ref
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
        self.speakerRef = try container.decode(String.self, forKey: .speakerRef)
        self.speakerName = try container.decode(String.self, forKey: .speakerName)
        self.replies = try container.decodeIfPresent(Set<Reply>.self, forKey: .replies) as NSSet?
    }
    
    
    /** For Encodable */
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeysOfPost.self)
        try container.encode(self.content, forKey: .content)
        try container.encode(self.date as Date, forKey: .date)
        try container.encode(self.speakerRef, forKey: .speakerRef)
        try container.encode(self.speakerName, forKey: .speakerName)
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
    var toJSON: JSONDATA {
        var returnJSON: JSONDATA = [
            CodingKeysOfPost.content.rawValue: self.content,
            CodingKeysOfPost.date.rawValue: self.date.toString,
            CodingKeysOfPost.speakerRef.rawValue: self.speakerRef,
            CodingKeysOfPost.speakerName.rawValue: self.speakerName,
            CodingKeysOfPost.ref.rawValue: self.ref
        ]
        // If any reply exists
        if let replies = self.replies {
            var repliesJSONContainer: JSONDATA = [:]
            for reply in (replies as! Set<Reply>) {
                // Store every reply as [date: JSONDATA]
                repliesJSONContainer[reply.date.toString] = reply.toJSON
            }
            returnJSON[CodingKeysOfPost.replies.rawValue] = repliesJSONContainer
        }
        
        return returnJSON
    }
    
    
    
    // MARK: - Custom Functions
    
    func getSpeakerInfo(for key: String, insertInto context: NSManagedObjectContext, tableView: UITableView) -> Any? {
        // Get the reference object from Firebase
        let firebaseRef = Database.database().reference(fromURL: self.speakerRef)
        // An empty JSONDATA container
        var snsidInfo: JSONDATA = [:]

        let speaker = SNSID(fromJSON: snsidInfo, insertInto: context)
        if let value = speaker.value(forKey: key) {
            return value
        } else {
            return nil
        }
    }
}


extension Post: DecodableFromFIRReference {}
