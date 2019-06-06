//
//  ReplyClass.swift
//  MID
//
//  Created by 江宇揚 on 2019/03/15.
//  Copyright © 2019 Jiang Yuyang. All rights reserved.
//

import Foundation
import Firebase

public class Reply: DecodableFromFIRReference {
    public let speaker: String
    public let speakerName: String
    public var speakerRef: String {
        let firebaseRoot = Database.rootReference()
        return firebaseRoot.child("snsidTank").child("\(speaker)").url
    }
    public let toward: String
    public let contents: String
    public let date: Date
    public var ref: String {
        let firebaseRoot = Database.rootReference()
        return firebaseRoot.child("replyTank").child("\(speaker)&&\(date.toString)").url
    }
    public var identifier: String {
        return "\(self.speaker)&&\(self.date)"
    }
    
    
    /** Public all term init */
    public init(speaker: String, speakerName: String, toward: String, contents: String, date: Date) {
        self.speaker = speaker
        self.speakerName = speakerName
        self.toward = toward
        self.contents = contents
        self.date = date
    }
    
    
    public init(selfSnsid: SNSID, toward: String, contents: String, at currentTime: Date) {
        self.speaker = "\(selfSnsid.owner)&&\(selfSnsid.name)"
        self.speakerName = selfSnsid.name
        self.toward = toward
        self.contents = contents
        self.date = currentTime
    }
    
    
    /** Required init for DecodableFromFIRReference */
    public required convenience init(fromJSON jsonData: JSONDATA) {
        guard let speaker = jsonData["speaker"] as? String,
        let speakerName = jsonData["speakerName"] as? String,
        let toward = jsonData["toward"] as? String,
        let contents = jsonData["contents"] as? String,
        let date = (jsonData["date"] as? String)?.toDate() else {
            raiseFatalError("KeyError when decoding to Reply")
            fatalError()
        }
        
        self.init(speaker: speaker, speakerName: speakerName, toward: toward, contents: contents, date: date)
    }
}



extension Reply: EncodableToFIRReference {
    /** Translate all the elements to JSONDATA for communication. */
    public func toJSON() -> JSONDATA {
        let returnJSON: JSONDATA = [
            "speaker": self.speaker,
            "speakerName": self.speakerName,
            "date": self.date.toString,
            "contents": self.contents,
            "toward": self.toward
        ]
        return returnJSON
    }
}
