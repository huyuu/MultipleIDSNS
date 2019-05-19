//
//  AddReplyViewController.swift
//  MID
//
//  Created by 江宇揚 on 2018/12/30.
//  Copyright © 2018 Jiang Yuyang. All rights reserved.
//

import UIKit
import CoreData
import Firebase


class AddReplyViewController: UIViewController {
    
    public var resources: ResourcesForAddReply!
    
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var selfSNSIDNameLabel: UILabel!
    @IBOutlet weak var receiverNameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.initalizeView()
    }
    
    
    
    // MARK: - Custom Actions
    
    private func initalizeView() {
        // let contexntTextView become first responser, and set its text to default
        contentTextView.becomeFirstResponder()
        contentTextView.text = ""
        // Set self name to selfSNSIDName label
        selfSNSIDNameLabel.text = resources.selfSnsid.name
        // present receiver name in the receiverName label
        receiverNameLabel.text = "@ \(resources.targetPost.speakerName)"
    }

    

    // MARK: - Navigation
    
    @IBAction func addReplyDidCancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func replyDone(_ sender: UIBarButtonItem) {
        let contents = contentTextView.text!
        /** Save new child to Firebase */
        let now = Date()
//        let newChildReference = firebaseRoot.child("\(selfSNSID.owner)&&\(selfSNSID.name)&&\(now.toString)")
        /** Create a new Reply on CoreData */
        let newReply = Reply(selfSnsid: resources.selfSnsid, toward: resources.targetPost.ref, contents: contents, at: now)
        let newChildReference = newReply.ref.getFIRDatabaseReference

        newChildReference.setValue(newReply.toJSON())
        /// Set new reply to target post
        resources.targetPost.ref.getFIRDatabaseReference.child("replies").child("\(resources.targetPost.identifier)").setValue(
            ["date": now.toString, "ref": newChildReference.url]
        )
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
