//
//  JSONDataForConnection.swift
//  MID
//
//  Created by 江宇揚 on 2018/12/14.
//  Copyright © 2018 Jiang Yuyang. All rights reserved.
//

import Foundation
import UIKit

public struct CodablePost: Codable {
    let speakerName: String
    let speakerID: Int64
    let content: String
    var replies: [CodableReply]?
    
    // Initializer direct for CoreData type 'Post'
    init(_ post: Post) {
        self.speakerName = post.speakerName
        self.speakerID = post.speakerID
        self.content = post.content
        self.replies = nil
    }
}


public struct CodableReply: Codable {
    let speakerName: String
    let speakerID: Int64
    let content: String
}
