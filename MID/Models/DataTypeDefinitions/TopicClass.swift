//
//  TopicClass.swift
//  MID
//
//  Created by 江宇揚 on 2019/03/19.
//  Copyright © 2019 Jiang Yuyang. All rights reserved.
//

import Foundation
import Firebase


public class Topic: DecodableFromFIRReference {
    public let title: String
    public let adherents: JSONDATA
    public var ref: String {
        let firebaseRoot = Database.rootReference()
        return firebaseRoot.child("topicTank").child("\(title)").url
    }
    
    /** Public All-Term init */
    public init(title: String, adherents: JSONDATA) {
        self.title = title
        self.adherents = adherents
    }
    
    
    /** Required init for DecodableFromFIRReference */
    public required convenience init(fromJSON jsonData: JSONDATA) {
        guard let title = jsonData["title"] as? String,
        let adherents = jsonData["adherents"] as? JSONDATA else {
            raiseFatalError("KeyError during decoding to Topic.")
            fatalError()
        }
        self.init(title: title, adherents: adherents)
    }
}



extension Topic: EncodableToFIRReference {
    /** Translate all the elements to JSONDATA for communication. */
    public func toJSON() -> JSONDATA {
        let returnJSON: JSONDATA = [
            "title": self.title,
            "adherents": self.adherents.expanded()
        ]
        return returnJSON
    }
}
