//
//  ResourcesForTimeLineScene.swift
//  MID
//
//  Created by 江宇揚 on 2019/05/12.
//  Copyright © 2019 Jiang Yuyang. All rights reserved.
//

import UIKit
import Firebase


public class ResourcesForTimeLineScene: ProjectResource {
    /** For tabbed SNSID */
    var snsid: SNSID
    /** For Firebase, expected to be .../tabbedSNSIDKey, first been set when snsid is asigned by delegate controller  */
    var firebaseRoot: DatabaseReference {
        return self.snsid.ref.getFIRDatabaseReference
    }
    /// should be set by delegate in navigation
    var favorTimeLine: [Post]
    
    var ownerController: TimeLineTableViewController!
    
    let nibForTimeLineTableViewCell = UINib(nibName: "\(TimeLineTableViewCell.self)", bundle: nil)
    let reuseIdentifier = "reusableTimeLineTableViewCell"
    let segueIdentifierForPostDetails = "showPostDetails"
    let segueIdentifierForAddPost = "addPost"
    
    let spaceToBottom: CGFloat = 20.0
    let spaceToTop: CGFloat = 20.0
    
    
    /// all-term initializer
    init(snsid: SNSID, favorTimeLine: [Post], ownerController: TimeLineTableViewController) {
        self.snsid = snsid
        self.favorTimeLine = favorTimeLine
        self.ownerController = ownerController
    }
}



// Adopt DataSourceForPostDetails protocol

extension ResourcesForTimeLineScene: DataSourceForPostDetails, DataSourceForAddPost {
    func translateToResourcesForPostDetails(post: Post, ownerController: PostDetailsTableViewController) -> ResourcesForPostDetails {
        let newResources = ResourcesForPostDetails(post: post,
                                                   selfSnsid: self.snsid,
                                                   ownerController: ownerController)
        // get new replies
        post.generateReplies(completionHandler: { (newReplies: [Reply]?) in
            // sort replies here!!!
            newResources.replies = newReplies?.sorted(by: { $0.date > $1.date })
        })
        return newResources
    }
    
    
    func translateToResourcesForAddPost(ownerController: AddPostViewController) -> ResourcesForAddPost {
        let newResources = ResourcesForAddPost(speaker: self.snsid, ownerController: ownerController)
        return newResources
    }
}



// DataSourceForTimeLineScene protocol

protocol DataSourceForTimeLineScene {
    func translateToResourcesForTimeLineScene(forRow row: Int, ownerController: TimeLineTableViewController) -> ResourcesForTimeLineScene
}
