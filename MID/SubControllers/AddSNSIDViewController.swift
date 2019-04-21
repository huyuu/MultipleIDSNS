//
//  AddSNSIDViewController.swift
//  MID
//
//  Created by 江宇揚 on 2018/12/20.
//  Copyright © 2018 Jiang Yuyang. All rights reserved.
//

import UIKit
import Firebase
import CoreData

class AddSNSIDViewController: UIViewController {

    /// Prepare coreDataContext
//    var coreDataContext: NSManagedObjectContext!
//    var appDelegate: AppDelegate!
    /** For FirebaseDatabase reference, expected to be .../snsidTank */
    public var firebaseRoot: DatabaseReference!
    /** For main account information. This property must be set by the previous controller */
    public var owner: Account!
    public var topicList: JSONDATA!
    
    
    
    /** For SNSID name input textField */
    @IBOutlet weak var nameTextField: UITextField!
    
    
    
    // MARK: - Load the view
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check if account exists
        guard let _ = owner else {
            raiseFatalError("Account doesn't exists when calling AddSNSIDViewController.")
            return
        }
        // Check if firebase reference exists
        guard let _ = firebaseRoot else {
            raiseFatalError("FirebaseRoot isn't set when calling AddSNSIDViewController.")
            return
        }
        // nameTextField is the first responder!
        nameTextField.becomeFirstResponder()
    }

    
    
    // MARK: - Button actions
    
    @IBAction func addSNSIDdidCancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func addSNSIDdone(_ sender: UIBarButtonItem) {
        let name = nameTextField.text!
        
        /** Save new child to Firebase */
        let newChildReference = firebaseRoot.child("\(owner.email)&&\(name)")
        
        /** Create a new SNSID on CoreData */
        let newSNSID = SNSID(name: name, owner: owner.name, ownerRef: owner.ref, myPosts: nil, myReplies: nil, follows: nil, followers: nil, topics: nil, myLikes: nil, focusingPosts: nil)
        
        newChildReference.setValue(newSNSID.toJSON())
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! == "chooseTopics" {
            let destinationController = segue.destination as! AddSNSIDViewController2
            destinationController.superController = self
        }
    }
}


