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
    
    
    /** All terms initializer from reference Post */
    public convenience init(towards targetPostRef: String, content: String, date: Date = Date(), selfSNSIDRef: String, selfSNSIDName: String, ref: String, insertInto context: NSManagedObjectContext) {
        self.init(entity: Reply.entity(), insertInto: context)
        self.content = content
        self.date = date as NSDate
        self.selfSNSIDName = selfSNSIDName
        self.selfSNSIDRef = selfSNSIDRef
        self.targetPostRef = targetPostRef
        self.ref = ref
    }
    
    
    /** Translate JSON data to Reply type */
    public convenience init(fromJSON jsonData: JSONDATA, insertInto context: NSManagedObjectContext) {
        guard let content = jsonData[CodingKeysOfReply.content.rawValue] as? String,
            let dateString = jsonData[CodingKeysOfReply.date.rawValue] as? String,
            let date = dateString.toDate(),
            let targetPostRef = jsonData[CodingKeysOfReply.targetPostRef.rawValue] as? String,
            let selfSNSIDRef = jsonData[CodingKeysOfReply.selfSNSIDRef.rawValue] as? String,
            let selfSNSIDName = jsonData[CodingKeysOfReply.selfSNSIDName.rawValue] as? String,
            let ref = jsonData[CodingKeysOfReply.ref.rawValue] as? String else {
                raiseFatalError("Some keys are not matched to the properties of Reply.")
                fatalError()
        }
        self.init(towards: targetPostRef, content: content, date: date, selfSNSIDRef: selfSNSIDRef, selfSNSIDName: selfSNSIDName, ref: ref, insertInto: context)
    }
    
    
    /** From reference url */
    public convenience init(fromReference ref: String, insertInto context: NSManagedObjectContext) {
        // Get the reference object from Firebase
        let firebaseRef = Database.database().reference(fromURL: ref)
        // An empty JSONDATA container
        var replyInfo: JSONDATA = [:]
        // Observe at ref level
        firebaseRef.observe(.childAdded, with: { snapshot in
            // Check if value exists
            guard let value = snapshot.value else {
                raiseFatalError("snapshot's value is nil.")
                fatalError()
            }
            // Add JSONDATA into info
            replyInfo[snapshot.key] = value
        })
//        firebaseRef.removeAllObservers()
        self.init(fromJSON: replyInfo, insertInto: context)
    }
    
    
    
    // MARK: - For Codable
    // Fixme
    
    enum CodingKeysOfReply: String, CodingKey {
        typealias RawValue = String
        case content
        case date
        case targetPostRef
        case selfSNSIDRef
        case selfSNSIDName
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
        self.init(entity: Reply.entity(), insertInto: context)
        
        let container = try decoder.container(keyedBy: CodingKeysOfReply.self)
        self.content = try container.decode(String.self, forKey: .content)
        self.date = try container.decode(Date.self, forKey: .date) as NSDate
        self.ref = try container.decode(String.self, forKey: .ref)
        self.targetPostRef = try container.decode(String.self, forKey: .targetPostRef)
        self.selfSNSIDRef = try container.decode(String.self, forKey: .selfSNSIDRef)
        self.selfSNSIDName = try container.decode(String.self, forKey: .selfSNSIDName)
    }
    
    
    /** For Encodable */
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeysOfReply.self)
        try container.encode(self.content, forKey: .content)
        try container.encode(self.date as Date, forKey: .date)
        try container.encode(self.targetPostRef, forKey: .targetPostRef)
        try container.encode(self.selfSNSIDRef, forKey: .selfSNSIDRef)
        try container.encode(self.selfSNSIDName, forKey: .selfSNSIDName)
        try container.encode(self.ref, forKey: .ref)
    }
    
    
    /** Create JSON data */
    var toJSON: Dictionary<String, Any> {
        return [
            CodingKeysOfReply.content.rawValue: self.content,
            CodingKeysOfReply.date.rawValue: self.date.toString,
            CodingKeysOfReply.targetPostRef.rawValue: self.targetPostRef,
            CodingKeysOfReply.selfSNSIDRef.rawValue: self.selfSNSIDRef,
            CodingKeysOfReply.selfSNSIDName.rawValue: self.selfSNSIDName,
            CodingKeysOfReply.ref.rawValue: self.ref
        ]
    }
    
    
    
    // MARK: - Custom Functions
    
    func getSelfSNSIDInfo(for key: String, insertInto context: NSManagedObjectContext) -> Any? {
        let speaker = SNSID(fromReference: self.selfSNSIDRef, insertInto: context)
        if let value = speaker.value(forKey: key) {
            //            context.delete(speaker)
            return value
        } else {
            return nil
        }
    }
}
