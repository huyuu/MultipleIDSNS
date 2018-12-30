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
    public var speaker: SNSID!
    /** For belongingPost. This property must be set by the previous controller */
    public var belongingPost: Post!
    
    @IBOutlet weak var contentTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contentTextField.becomeFirstResponder()
    }
    


    // MARK: - Navigation
    
    @IBAction func addReplyDidCancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func replyDone(_ sender: UIBarButtonItem) {
        let content = contentTextField.text!
        /** Create a new Reply on CoreData */
        let newReply = Reply(of: belongingPost, content: content, insertInto: coreDataContext)
        /** Save new child to Firebase */
        let newChildReference = firebaseRoot.child(newReply.date.toString)
        newChildReference.setValue(newReply.toJSON)
        
        coreDataContext.delete(newReply)
        appDelegate.saveContext()
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
