//
//  AddPostViewController.swift
//  MID
//
//  Created by 江宇揚 on 2018/12/28.
//  Copyright © 2018 Jiang Yuyang. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class AddPostViewController: UIViewController {

    /** For FirebaseDatabase reference, expected to be ../postTank  */
    public var firebaseRoot: DatabaseReference = Database.rootReference().child("postTank")
    /** For speaker. This property must be set by the previous controller */
    public var speaker: SNSID!
    /** Post content text input textField */
    @IBOutlet weak var contentTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Check if speaker exists
        guard let _ = speaker else {
            raiseFatalError("Speaker doesn't exists when calling AddPostViewController.")
            fatalError()
        }
        // ContentTextField is the first responder
        contentTextField.becomeFirstResponder()
    }
    


    // MARK: - Navigation
    
    @IBAction func postDidCancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func postDone(_ sender: Any) {
        let contents = contentTextField.text!
        /** Save new child to Firebase */
        let now = Date()
        let newChildReference = firebaseRoot.child("\(speaker.owner)&&\(speaker.name)&&\(now.toString)")
        /** Create a new Post on CoreData */
        let newPost = Post(speaker: "\(speaker.owner)&&\(speaker.name)", speakerName: "\(speaker.name)", speakerRef: speaker.ref, date: now, contents: contents, replies: nil)
        
//        print(newPost.toJSON)
        newChildReference.setValue(newPost.toJSON())
        /// set new myPost to snsid
        speaker.ref.getFIRDatabaseReference.child("myPosts").child("\(now.toString)").setValue(
            ["date": now.toString, "ref": newChildReference.url]
        )
        
        self.dismiss(animated: true, completion: nil)
    }
}
