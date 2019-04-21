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
    
    /** For FirebaseDatabase reference, expected to be ../replyTank  */
    public var firebaseRoot = Database.rootReference().child("replyTank")
    /** For speaker. This property must be set by the previous controller */
    public var selfSNSID: SNSID!
    /** For belongingPost. This property must be set by the previous controller */
    public var targetPost: Post!
    
    
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
        contentTextView.text! = ""
        // Set self name to selfSNSIDName label
        selfSNSIDNameLabel.text = selfSNSID.name
        // present receiver name in the receiverName label
        receiverNameLabel.text = "@ \(targetPost.speakerName)"
    }

    

    // MARK: - Navigation
    
    @IBAction func addReplyDidCancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func replyDone(_ sender: UIBarButtonItem) {
        let contents = contentTextView.text!
        /** Save new child to Firebase */
        let now = Date()
        let newChildReference = firebaseRoot.child("\(selfSNSID.owner)&&\(selfSNSID.name)&&\(now.toString)")
        /** Create a new Reply on CoreData */
        let newReply = Reply(speaker: "\(selfSNSID.owner)&&\(selfSNSID.name)",
            speakerName: selfSNSID.name,
            toward: targetPost.ref,
            contents: contents,
            date: now)

        newChildReference.setValue(newReply.toJSON())
        /// Set new reply to target post
        targetPost.ref.getFIRDatabaseReference.child("replies").child("\(selfSNSID.owner)&&\(selfSNSID.name)&&\(now.toString)").setValue(
            ["date": now.toString, "ref": newChildReference.url]
        )
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
