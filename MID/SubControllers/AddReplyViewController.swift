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
    
    // Prepare coreDataContext
    var appDelegate: AppDelegate!
    var coreDataContext: NSManagedObjectContext!
    /** For FirebaseDatabase reference */
    public var firebaseRoot: DatabaseReference!
    /** For speaker. This property must be set by the previous controller */
    public var selfSNSID: SNSID!
    /** For belongingPost. This property must be set by the previous controller */
    public var targetPost: Post!
    
    
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var selfSNSIDNameLabel: UILabel!
    @IBOutlet weak var receiverNameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contentTextView.becomeFirstResponder()
        selfSNSIDNameLabel.text = selfSNSID.name
        receiverNameLabel.text = "replying to \(targetPost.speakerName)"
    }
    


    // MARK: - Navigation
    
    @IBAction func addReplyDidCancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func replyDone(_ sender: UIBarButtonItem) {
        let content = contentTextView.text!
        /** Save new child to Firebase */
        let now = Date()
        let newChildReference = firebaseRoot.child(now.toString)
        /** Create a new Reply on CoreData */
        let newReply = Reply(towards: targetPost.ref, content: content, date: now, selfSNSIDRef: selfSNSID.ref, selfSNSIDName: selfSNSID.name, ref: newChildReference.url, insertInto: coreDataContext)
        selfSNSID.addToPublishedReplies(newReply)

        newChildReference.setValue(newReply.toJSON)
        
        selfSNSID.addToPublishedReplies(newReply)
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
