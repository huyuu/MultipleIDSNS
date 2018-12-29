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
    public init(name: String, owner: Account, insertInto context: NSManagedObjectContext) {
        super.init(entity: SNSID.entity(), insertInto: context)
        self.name = name
        self.iDnumber = Int64(name.hashValue)
        self.posts = nil
        self.owner = owner
        owner.addToSnsids(self)
    }
    
    
    /**
     From JSON data of a snapshot. Must contain **"name"** property (["posts": JSONDATA] for option).
     - parameter jsonData: a [String: Any]
    */
    public convenience init(fromJSON jsonData: JSONDATA, owner: Account, insertInto context: NSManagedObjectContext) {
        guard let name = jsonData["name"] as? String else {
            raiseFatalError("Some keys are not matched to the properties of SNSID.")
            fatalError()
        }
        self.init(name: name, owner: owner, insertInto: context)
        // If any post exists
        if let posts = jsonData["posts"] as? JSONDATA {
            for post in posts {
                // Get postInformation from post. Mark that post.key = post.iDnumber; and post.value = ["content":"content", "date":"date"] dictionary
                guard let postInfo = post.value as? JSONDATA else {
                    raiseFatalError("Can't get postInfo from post.")
                    fatalError()
                }
                let newPost = Post(fromJSON: postInfo, speaker: self, insertInto: context)
                self.addToPosts(newPost)
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
        case posts
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
        self.posts = try container.decodeIfPresent(Set<Post>.self, forKey: .posts) as NSSet?
        self.owner = try container.decode(Account.self, forKey: .owner)
    }
    
    
    /** For Encodable */
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeysOfSNSID.self)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.owner, forKey: .owner)
        if let nssetPosts = self.posts { // At least one SNSID exists
            // Check if NSSet is convertible to Set<SNSID>
            guard let setPosts = nssetPosts as? Set<Post> else {
                raiseFatalError("Can't convert NSSet into Set<Post> when encoding.")
                fatalError()
            }
            try container.encode(setPosts, forKey: .posts)
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
