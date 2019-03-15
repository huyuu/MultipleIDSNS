//
//  SNSID+CoreDataClass.swift
//  MID
//
//  Created by 江宇揚 on 2018/12/11.
//  Copyright © 2018 Jiang Yuyang. All rights reserved.
//
//

import Foundation
import CoreData
import Firebase


public class SNSID: NSManagedObject, Codable {
    /** Designed initializer of the superClass of Post */
    override public init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    
    /** Public all terms initializer */
    public init(name: String, ownerRef: String, myPosts: Set<Post>? = nil, publishedReplies: Set<Reply>? = nil, ref: String, insertInto context: NSManagedObjectContext) {
        super.init(entity: SNSID.entity(), insertInto: context)
        self.name = name
        self.myPosts = myPosts as NSSet?
        self.publishedReplies = publishedReplies as NSSet?
        self.ownerRef = ownerRef
        self.ref = ref
    }
    
    
    /**
     From JSON data of a snapshot. Must contain **"name"** property (["posts": JSONDATA] for option).
     - parameter jsonData: a [String: Any]
    */
    public required convenience init(fromJSON jsonData: JSONDATA, insertInto context: NSManagedObjectContext) {
        guard let name = jsonData[CodingKeysOfSNSID.name.rawValue] as? String,
            let ownerRef = jsonData[CodingKeysOfSNSID.ownerRef.rawValue] as? String,
            let ref = jsonData[CodingKeysOfSNSID.ref.rawValue] as? String else {
            raiseFatalError("Some keys are not matched to the properties of SNSID.")
            fatalError()
        }
        // Container of publishedReplies
        var publishedRepliesContainer: Set<Reply>? = nil
        // If any publishedReply exists
        if let publishedReplies = jsonData[CodingKeysOfSNSID.publishedReplies.rawValue] as? JSONDATA {
            publishedRepliesContainer = Set<Reply>()
            for publishedReply in publishedReplies {
                if let publishedReplyInfo = publishedReply.value as? JSONDATA {
                    publishedRepliesContainer!.insert(Reply(fromJSON: publishedReplyInfo, insertInto: context))
                }
            }
        }
        // Container of myPosts
        var myPostsContainer: Set<Post>? = nil
        // If any publishedReply exists
        if let myPosts = jsonData[CodingKeysOfSNSID.myPosts.rawValue] as? JSONDATA {
            myPostsContainer = Set<Post>()
            for myPost in myPosts {
                if let myPostInfo = myPost.value as? JSONDATA {
                    myPostsContainer!.insert(Post(fromJSON: myPostInfo, insertInto: context))
                }
            }
        }
        
        self.init(name: name, ownerRef: ownerRef, myPosts: myPostsContainer, publishedReplies: publishedRepliesContainer, ref: ref, insertInto: context)
    }

    
    
    
    // MARK: - For Codable
    
    enum CodingKeysOfSNSID: String, CodingKey {
        typealias RawValue = String
        case name
        case ownerRef
        case myPosts
        case publishedReplies
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
        self.init(entity: SNSID.entity(), insertInto: context)
        
        let container = try decoder.container(keyedBy: CodingKeysOfSNSID.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.myPosts = try container.decodeIfPresent(Set<Post>.self, forKey: .myPosts)! as NSSet
        self.ownerRef = try container.decode(String.self, forKey: .ownerRef)
        self.publishedReplies = try container.decodeIfPresent(Set<Reply>.self, forKey: .publishedReplies)! as NSSet
        self.ref = try container.decode(String.self, forKey: .ref)
    }
    
    
    /** For Encodable */
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeysOfSNSID.self)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.ownerRef, forKey: .ownerRef)
        try container.encode(self.ref, forKey: .ref)
        if let nssetMyPosts = self.myPosts { // At least one reply exists
            // Check if NSSet is convertible to Set<Reply>
            guard let setMyPosts = nssetMyPosts as? Set<Post> else {
                raiseFatalError("Can't convert NSSet into Set<Post> when encoding.")
                fatalError()
            }
            try container.encode(setMyPosts, forKey: .myPosts)
        }
        
        if let nssetPublishedReplies = self.publishedReplies { // At least one reply exists
            // Check if NSSet is convertible to Set<Reply>
            guard let setPublishedReplies = nssetPublishedReplies as? Set<Reply> else {
                raiseFatalError("Can't convert NSSet into Set<Reply> when encoding.")
                fatalError()
            }
            try container.encode(setPublishedReplies, forKey: .publishedReplies)
        }
    }
    
    
    /** Create JSON data */
    var toJSON: JSONDATA {
        var returnJSON: JSONDATA = [
            CodingKeysOfSNSID.name.rawValue: self.name,
            CodingKeysOfSNSID.ownerRef.rawValue: self.ownerRef,
            CodingKeysOfSNSID.ref.rawValue: self.ref
        ]
        // If any myPost exists
        if let myPosts = self.myPosts {
            var myPostsJSONContainer: JSONDATA = [:]
            for myPost in (myPosts as! Set<Post>) {
                // Store every myPost as [date: JSONDATA]
                myPostsJSONContainer[myPost.date.toString] = myPost.toJSON
            }
            returnJSON[CodingKeysOfSNSID.myPosts.rawValue] = myPostsJSONContainer
        }
        // If any publishedReply exists
        if let publishedReplies = self.publishedReplies {
            var publishedRepliesJSONContainer: JSONDATA = [:]
            for publishedReply in (publishedReplies as! Set<Reply>) {
                // Store every reply as [date: JSONDATA]
                publishedRepliesJSONContainer[publishedReply.date.toString] = publishedReply.toJSON
            }
            returnJSON[CodingKeysOfSNSID.publishedReplies.rawValue] = publishedRepliesJSONContainer
        }
        
        return returnJSON
    }
}


extension SNSID: DecodableFromFIRReference {}
