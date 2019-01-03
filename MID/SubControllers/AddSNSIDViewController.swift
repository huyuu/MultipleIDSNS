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
    var coreDataContext: NSManagedObjectContext!
    var appDelegate: AppDelegate!
    /** For FirebaseDatabase reference, expected to be .../snsids */
    public var firebaseRoot: DatabaseReference!
    /** For main account information. This property must be set by the previous controller */
    public var owner: Account!
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
        let newChildReference = firebaseRoot.child(name)
        /** Create a new SNSID on CoreData */
        let newSNSID = SNSID(name: name, ownerRef: owner.ref, myPosts: nil, publishedReplies: nil, ref: newChildReference.url, insertInto: coreDataContext)
        newChildReference.setValue(newSNSID.toJSON)
        
        owner.addToSnsids(newSNSID)
        
        self.dismiss(animated: true, completion: nil)
    }
}
