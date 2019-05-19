//
//  ResourcesForPostDetails.swift
//  MID
//
//  Created by 江宇揚 on 2019/05/18.
//  Copyright © 2019 Jiang Yuyang. All rights reserved.
//

import UIKit
import Firebase

class ResourcesForPostDetails: ProjectResource {
    let post: Post
    let selfSnsid: SNSID
    
    let nibForPostDetails = UINib(nibName: "\(PostDetailsCell.self)", bundle: nil)
    let reuseIdentifierForPostDetailsCell = "reusablePostCell"
    
    let segueIdentifierForAddReply = "addReply"
    
    // should be option because we'll ascynchronously generate it later.
    var replies: [Reply]! {
        didSet {
            ownerController.tableView.reloadData()
        }
    }
    
    var firebaseRoot: DatabaseReference {
        return post.ref.getFIRDatabaseReference
    }
    
    // may be nil
    weak var ownerController: PostDetailsTableViewController!
    
    
    
    init(post: Post, selfSnsid: SNSID, replies: [Reply]!=nil, ownerController: PostDetailsTableViewController) {
        self.post = post
        self.selfSnsid = selfSnsid
        self.replies = replies
        self.ownerController = ownerController
    }
}



// MARK: - adopt to DataSourceForAddReply

extension ResourcesForPostDetails: DataSourceForAddReply{
    func translateToResourcesForAddReply() -> ResourcesForAddReply {
        let newResources = ResourcesForAddReply(selfSnsid: self.selfSnsid, targetPost: self.post)
        return newResources
    }
}



protocol DataSourceForPostDetails {
    func translateToResourcesForPostDetails(post: Post, ownerController: PostDetailsTableViewController) -> ResourcesForPostDetails
}
