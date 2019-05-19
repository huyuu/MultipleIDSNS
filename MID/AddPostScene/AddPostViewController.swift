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

    public var resources: ResourcesForAddPost!
    /** Post content text input textField */
    
    @IBOutlet weak var contentTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
//        let newChildReference = resources.firebaseRoot.addressNewPostReference(Of: resources.speaker, at: now)
        /** Create a new Post on CoreData */
        let newPost = Post(speaker: resources.speaker, date: now, contents: contents)
        let newChildReference = newPost.ref.getFIRDatabaseReference
        
        newChildReference.setValue(newPost.toJSON())
        /// set new myPost to snsid
        resources.speaker.ref.getFIRDatabaseReference.child("myPosts").child("\(now.toString)").setValue(
            ["date": now.toString, "ref": newChildReference.url]
        )
        
        self.dismiss(animated: true, completion: nil)
    }
}
