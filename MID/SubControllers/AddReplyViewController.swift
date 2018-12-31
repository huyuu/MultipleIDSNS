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
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let coreDataContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    /** For FirebaseDatabase reference */
    public var firebaseRoot: DatabaseReference!
    /** For speaker. This property must be set by the previous controller */
    public var selfSNSID: SNSID!
    /** For belongingPost. This property must be set by the previous controller */
    public var targetPost: Post!
    
    @IBOutlet weak var contentTextField: UITextField!
    @IBOutlet weak var selfSNSIDNameLabel: UILabel!
    @IBOutlet weak var receiverNameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contentTextField.becomeFirstResponder()
        selfSNSIDNameLabel.text = selfSNSID.name
        receiverNameLabel.text = "replying to \(targetPost.speakerName)"
    }
    


    // MARK: - Navigation
    
    @IBAction func addReplyDidCancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func replyDone(_ sender: UIBarButtonItem) {
        let content = contentTextField.text!
        /** Save new child to Firebase */
        let newChildReference = firebaseRoot.child(Date().toString)
        /** Create a new Reply on CoreData */
        let newReply = Reply(towards: targetPost.ref, content: content, selfSNSIDRef: selfSNSID.ref, selfSNSIDName: selfSNSID.name, ref: newChildReference.url, insertInto: coreDataContext)
        selfSNSID.addToPublishedReplies(newReply)

        newChildReference.setValue(newReply.toJSON)
        
//        coreDataContext.delete(newReply)
        appDelegate.saveContext()
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
