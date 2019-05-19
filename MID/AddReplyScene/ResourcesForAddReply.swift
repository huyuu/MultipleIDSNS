//
//  ResourcesForAddReply.swift
//  MID
//
//  Created by 江宇揚 on 2019/05/18.
//  Copyright © 2019 Jiang Yuyang. All rights reserved.
//

import UIKit
import Firebase


class ResourcesForAddReply: ProjectResource {
    /** For FirebaseDatabase reference, expected to be ../replyTank  */
    let firebaseRoot = Database.rootReference().child("replyTank")
    let selfSnsid: SNSID
    /** For belongingPost. This property must be set by the previous controller */
    let targetPost: Post
    
    
    init(selfSnsid: SNSID, targetPost: Post) {
        self.selfSnsid = selfSnsid
        self.targetPost = targetPost
    }
}




protocol DataSourceForAddReply {
    func translateToResourcesForAddReply() -> ResourcesForAddReply
}
