//
//  ResourcesForAddPost.swift
//  MID
//
//  Created by 江宇揚 on 2019/05/18.
//  Copyright © 2019 Jiang Yuyang. All rights reserved.
//

import UIKit
import Firebase

class ResourcesForAddPost: ProjectResource {
    
    let speaker: SNSID
    /// if there is a draft
    let draft: String?
    /// expectd to be ../postTank/
    let firebaseRoot = Database.rootReference().child("postTank")
    
    weak var ownerController: AddPostViewController!
    
    
    init(speaker: SNSID, draft: String?=nil, ownerController: AddPostViewController) {
        self.speaker = speaker
        self.draft = draft
        self.ownerController = ownerController
    }
}



protocol DataSourceForAddPost {
    func translateToResourcesForAddPost(ownerController: AddPostViewController) -> ResourcesForAddPost
}
