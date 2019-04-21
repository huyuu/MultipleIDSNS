//
//  PostClass.swift
//  MID
//
//  Created by 江宇揚 on 2019/03/15.
//  Copyright © 2019 Jiang Yuyang. All rights reserved.
//

import Foundation
import Firebase

public class Post: DecodableFromFIRReference {
    public let speaker: String
    public let speakerName: String
    public let speakerRef: String
    public let date: Date
    public let contents: String
    public let replies: JSONDATA?
    public var ref: String {
        let firebaseRoot = Database.rootReference()
        return firebaseRoot.child("postTank").child("\(speaker)&&\(date.toString)").url
    }
    
    /** Public all term init */
    public init(speaker: String, speakerName: String, speakerRef: String, date: Date, contents: String, replies: JSONDATA?) {
        self.speaker = speaker
        self.speakerName = speakerName
        self.speakerRef = speakerRef
        self.date = date
        self.contents = contents
        self.replies = replies
    }
    
    
    /** Required init for DecodableFromFIRReference */
    public required convenience init(fromJSON jsonData: JSONDATA) {
        guard let speaker = jsonData["speaker"] as? String,
        let speakerName = jsonData["speakerName"] as? String,
        let speakerRef = jsonData["speakerRef"] as? String,
        let date = (jsonData["date"] as? String)?.toDate(),
        let contents = jsonData["contents"] as? String,
        let replies = jsonData["replies"] as? JSONDATA? else {
             raiseFatalError("KeyError when decoding to Post class.")
            fatalError()
        }
        
        self.init(speaker: speaker, speakerName: speakerName, speakerRef: speakerRef, date: date, contents: contents, replies: replies)
    }
}



extension Post: EncodableToFIRReference {
    
    /** Translate all the elements to JSONDATA for communication. */
    public func toJSON() -> JSONDATA {
        let returnJSON: JSONDATA = [
            "speaker": self.speaker,
            "speakerName": self.speakerName,
            "speakerRef": self.speakerRef,
            "date": self.date.toString,
            "contents": self.contents,
            "replies": self.replies?.expanded()
        ]
        return returnJSON
    }
}



extension Post {
    public func generateReplies(runQueue: DispatchQueue=DispatchQueue(label: "replies",
                                                                      qos: .default, attributes: .concurrent),
                                completionQueue: DispatchQueue=DispatchQueue.main,
                                completionHandler: @escaping ([Reply]?) -> ()) {
        var returnReplies: [Reply]? = []
        
        runQueue.async {
            /// If any reply exist
            if let replies = self.replies {
                for reply in replies {
                    guard let replyInfo = reply.value as? JSONDATA else {
                        raiseFatalError("ContentError: this reply doesn't contain propper items.")
                        fatalError()
                    }
                    let replyRef = replyInfo["ref"] as! String
                    Reply.initSelf(fromReference: replyRef, completionHandler: { (newReply) in
                        returnReplies!.append(newReply)
                        completionQueue.async {
                            completionHandler(returnReplies!)
                        }
                    })
                }
            } else {
                returnReplies = nil
                completionQueue.async {
                    completionHandler(nil)
                }
            }
        }
    }
}
