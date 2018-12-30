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
    
    
    /** Designed initiater of Post */
//    public init(from newSNSID: CodableSNSID, owner: Account, insertInto context: NSManagedObjectContext) {
//        super.init(entity: SNSID.entity(), insertInto: context)
//        self.name = newSNSID.name
//        self.iDnumber = newSNSID.iDnumber
//        owner.addToSnsids(self)
//    }
    
    
    /** Public all terms initializer */
    public init(name: String, owner: Account, ref: String, insertInto context: NSManagedObjectContext) {
        super.init(entity: SNSID.entity(), insertInto: context)
        self.name = name
        self.iDnumber = Int64(name.hashValue)
        self.myPosts = nil
        self.publishedReplies = nil
        self.owner = owner
        self.ref = ref
        owner.addToSnsids(self)
    }
    
    
    public convenience init(from refString: String, insertInto context: NSManagedObjectContext) {
        let firebaseRef = Database.database().reference(fromURL: refString)
        var snsidInfo: JSONDATA = [:]
        
        firebaseRef.observe(.value, with: { snapshot in
            guard let value = snapshot.value else {
                raiseFatalError("snapshot's value is nil.")
                fatalError()
            }
            snsidInfo[snapshot.key] = value
            firebaseRef.removeAllObservers()
        })
        
        self.init(fromJSON: snsidInfo, owner: <#T##Account#>, ref: refString, insertInto: context)
    }
    
    
    /**
     From JSON data of a snapshot. Must contain **"name"** property (["posts": JSONDATA] for option).
     - parameter jsonData: a [String: Any]
    */
    public convenience init(fromJSON jsonData: JSONDATA, owner: Account, ref: String, insertInto context: NSManagedObjectContext) {
        guard let name = jsonData[SNSID.CodingKeysOfSNSID.name.rawValue] as? String else {
            raiseFatalError("Some keys are not matched to the properties of SNSID.")
            fatalError()
        }
        self.init(name: name, owner: owner, ref: ref, insertInto: context)
        
        // If any post exists
        if let myPosts = jsonData[SNSID.CodingKeysOfSNSID.myPosts.rawValue] as? JSONDATA {
            for myPost in myPosts {
                // Get postInformation from post. Mark that post.key = post.date; and post.value = ["content":"content", "date":"date"] dictionary
                guard let myPostInfo = myPost.value as? JSONDATA else {
                    raiseFatalError("Can't get postInfo from post.")
                    fatalError()
                }
                let newPost = Post(fromJSON: myPostInfo, speaker: self, ref: self.ref.addChild("\(SNSID.CodingKeysOfSNSID.myPosts.rawValue)/\(myPost.key)"), insertInto: context)
                self.addToMyPosts(newPost)
            }
        }
        
        // If any publishedReply exists
        if let publishedReplies = jsonData["publishedReplies"] as? JSONDATA {
            for publishedReply in publishedReplies {
                // Get repliesInformation from post. Mark that reply.key = reply.date; and reply.value = ["content":"content", "date":"date"] dictionary
                guard let replyInfo = publishedReply.value as? JSONDATA else {
                    raiseFatalError("Can't get publishedReplyInfo from publishedReply.")
                    fatalError()
                }
                // From SNSID, rather than create a full instance of belongingPost of the reply, we only store the reference of belongingPost.
                let newReply = Reply(fromJSON: replyInfo, insertInto: context)
                self.addToPublishedReplies(newReply)
            }
        }
    }
    
    
    // For Hashable
    static func ==(lhs: SNSID, rhs: SNSID) -> Bool {
        return (lhs.owner.iDnumber == rhs.owner.iDnumber) && (lhs.iDnumber == rhs.iDnumber)
    }
    
    
    
    // MARK: - For Codable
    
    enum CodingKeysOfSNSID: String, CodingKey {
        typealias RawValue = String
        case name
        case owner
        case myPosts
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
        self.iDnumber = Int64(self.name.hashValue)
        self.myPosts = try container.decodeIfPresent(Set<Post>.self, forKey: .myPosts) as NSSet?
        self.owner = try container.decode(Account.self, forKey: .owner)
    }
    
    
    /** For Encodable */
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeysOfSNSID.self)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.owner, forKey: .owner)
        if let nssetPosts = self.myPosts { // At least one SNSID exists
            // Check if NSSet is convertible to Set<SNSID>
            guard let setPosts = nssetPosts as? Set<Post> else {
                raiseFatalError("Can't convert NSSet into Set<Post> when encoding.")
                fatalError()
            }
            try container.encode(setPosts, forKey: .myPosts)
        }
    }
    
    
    /** Create JSON data */
//    var toJSON: Dictionary<String, Any> {
//        if let posts = self.posts {
//            return [
//                "name": self.name,
//                "owner": self.owner,
//                "posts": (posts.allObjects as! [Post]).map{ $0.toJSON }
//            ]
//        } else {
//            return [
//                "name": self.name,
//                "owner": self.owner,
//            ]
//        }
//    }
    
    
    var toJSON: Dictionary<String, Any> {
        return [
            "name": self.name
        ]
    }
}
