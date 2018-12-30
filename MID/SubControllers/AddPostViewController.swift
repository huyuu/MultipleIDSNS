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

    // Prepare coreDataContext
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let coreDataContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    /** For FirebaseDatabase reference */
    public var firebaseRoot: DatabaseReference!
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
        let content = contentTextField.text!
        /** Save new child to Firebase */
        let newChildReference = firebaseRoot.child(Date().toString)
        /** Create a new Post on CoreData */
        let newPost = Post(of: speaker, content: content, ref: newChildReference.url, insertInto: coreDataContext)
        newChildReference.setValue(newPost.toJSON)
        
        coreDataContext.delete(newPost)
        appDelegate.saveContext()
        
        self.dismiss(animated: true, completion: nil)
    }
}
