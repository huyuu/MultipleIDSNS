//
//  SNSIDClass.swift
//  MID
//
//  Created by 江宇揚 on 2019/03/15.
//  Copyright © 2019 Jiang Yuyang. All rights reserved.
//

import Foundation
import Firebase

public class SNSID: DecodableFromFIRReference {
    public let name: String
    public let owner: String
    public let ownerRef: String
    public var myPosts: JSONDATA?
    public var myReplies: JSONDATA?
    public var follows: JSONDATA?
    public var followers: JSONDATA?
    public var topics: JSONDATA
    public var myLikes: JSONDATA?
    public var focusingPosts: JSONDATA?
    public var settings: JSONDATA
    public var ref: String {
        let firebaseRoot = Database.rootReference()
        return firebaseRoot.child("snsidTank").child("\(owner)&&\(name)").url
    }
    
    /** Public all term init */
    public init(name: String, owner: String, ownerRef: String, myPosts: JSONDATA?, myReplies: JSONDATA?, follows: JSONDATA?,
                followers: JSONDATA?, topics: JSONDATA, myLikes: JSONDATA?, focusingPosts: JSONDATA?, settings: JSONDATA) {
        self.name = name
        self.owner = owner
        self.ownerRef = ownerRef
        self.myPosts = myPosts
        self.myReplies = myReplies
        self.follows = follows
        self.followers = followers
        self.topics = topics
        self.myLikes = myLikes
        self.focusingPosts = focusingPosts
        self.settings = settings
    }
    
    
    /** Required init for DecodableFromFIRReference */
    public required convenience init(fromJSON jsonData: JSONDATA) {        
        let commonErrorString = "when creating SNSID instance"
        
        guard let name = jsonData["name"] as? String else {
            raiseFatalError("KeyError: can't convert jsonData[name] to String \(commonErrorString).")
            fatalError()
        }
        
        guard let owner = jsonData["owner"] as? String else {
            raiseFatalError("KeyError: can't convert jsonData[owner] to String \(commonErrorString).")
            fatalError()
        }
        
        guard let ownerRef = jsonData["ownerRef"] as? String else {
            raiseFatalError("KeyError: can't convert jsonData[ownerRef] to String \(commonErrorString).")
            fatalError()
        }
        
        guard let topics = jsonData["topics"] as? JSONDATA else {
            raiseFatalError("KeyError: can't convert jsonData[topics] to JSONDATA \(commonErrorString).")
            fatalError()
        }
        
        guard let settings = jsonData["settings"] as? JSONDATA else {
            raiseFatalError("KeyError: can't convert jsonData[settings] to JSONDATA \(commonErrorString).")
            fatalError()
        }
        
        let myPosts: JSONDATA? = jsonData["myPosts"] == nil ? nil : jsonData["myPosts"] as? JSONDATA
        let myReplies: JSONDATA? = jsonData["myReplies"] == nil ? nil : jsonData["myReplies"] as? JSONDATA
        let follows: JSONDATA? = jsonData["follows"] == nil ? nil : jsonData["follows"] as? JSONDATA
        let followers: JSONDATA? = jsonData["followers"] == nil ? nil : jsonData["followers"] as? JSONDATA
        let myLikes: JSONDATA? = jsonData["myLikes"] == nil ? nil : jsonData["myLikes"] as? JSONDATA
        let focusingPosts: JSONDATA? = jsonData["focusingPosts"] == nil ? nil : jsonData["focusingPosts"] as? JSONDATA
        
        self.init(name: name, owner: owner, ownerRef: ownerRef, myPosts: myPosts, myReplies: myReplies, follows: follows, followers: followers, topics: topics, myLikes: myLikes, focusingPosts: focusingPosts, settings: settings)
    }
}



extension SNSID: EncodableToFIRReference {
    /** Translate all the elements to JSONDATA for communication. */
    public func toJSON() -> JSONDATA {
        let returnJSON: JSONDATA = [
            "name": self.name,
            "owner": self.owner,
            "ownerRef": self.ownerRef,
            "myPosts": self.myPosts?.expanded(),
            "myReplies": self.myReplies?.expanded(),
            "follows": self.follows?.expanded(),
            "followers": self.followers?.expanded(),
            "topics": self.topics.expanded(),
            "myLikes": self.myLikes?.expanded(),
            "focusingPosts": self.focusingPosts?.expanded(),
            "settings": self.settings.expanded()
        ]
        return returnJSON
    }
}



extension SNSID {
    public enum TimeLineType {
        case favor
        case fair
    }
    

    
    
    public func generateTimeLine(type: TimeLineType,
                                 runQueue: DispatchQueue=DispatchQueue(label: "timeLine", qos: .default, attributes: .concurrent),
                                 completionQueue: DispatchQueue=DispatchQueue.main,
                                 completionHandler: @escaping ([Post]) -> () ) {
        var postRefs: [String]? = []
        var timeLine: [Post] = []
        
        runQueue.async {
            /// whether favor or faire timeLine is inferred
            if type == TimeLineType.favor {
                /// if one has any following user
                if let follows = self.follows {
                    /// for every following user(snsid)
                    for follow in follows {
                        guard let refInfo = follow.value as? JSONDATA else {
                            raiseWeakError("KeyError: The item has no member name 'ref'")
                            fatalError()
                        }
                        
                        let followRef = refInfo["ref"] as! String
                        SNSID.initSelf(fromReference: followRef, completionHandler: { (snsidOfFollow: SNSID) in
                            
                            /// If he has posted anything.
                            if let myPosts = snsidOfFollow.myPosts {
                                for myPost in myPosts {
                                    guard let myPostInfo = myPost.value as? JSONDATA else {
                                        raiseWeakError("KeyError: The item has no member name 'ref'")
                                        fatalError()
                                    }
                                    let myPostRef = myPostInfo["ref"] as! String
                                    postRefs!.append(myPostRef)
                                    Post.initSelf(fromReference: myPostRef, completionHandler: { (post: Post) in
                                        timeLine.append(post)
                                        completionQueue.async {
                                            completionHandler(timeLine)
                                        }
                                        return
                                    })
                                }
                            }
                            
                        })
                    }
                } else { // If no follow
                }
            } else if type == TimeLineType.fair {
            }
            
            // update for any case
            completionQueue.async {
                completionHandler(timeLine)
            }
        }

    }
    
}
