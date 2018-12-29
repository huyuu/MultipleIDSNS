//
//  AddSNSIDViewController.swift
//  MID
//
//  Created by 江宇揚 on 2018/12/20.
//  Copyright © 2018 Jiang Yuyang. All rights reserved.
//

import UIKit
import Firebase

class AddSNSIDViewController: UIViewController {

    // Prepare coreDataContext
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let coreDataContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    /** For FirebaseDatabase reference */
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
        
        guard let _ = firebaseRoot else {
            raiseFatalError("FirebaseRoot isn't set when calling AddSNSIDViewController.")
            return
        }
    }

    
    
    // MARK: - Button actions
    
    @IBAction func addSNSIDdidCancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func addSNSIDdone(_ sender: UIBarButtonItem) {
        let name = nameTextField.text!
        /** Create a new SNSID on CoreData */
        let newSNSID = SNSID(name: name, owner: owner, insertInto: coreDataContext)
        
        /** Save new child to Firebase */
        let newChildReference = firebaseRoot.child(newSNSID.name)
        newChildReference.setValue(newSNSID.toJSON)
        
        coreDataContext.delete(newSNSID)
        appDelegate.saveContext()
        
        self.dismiss(animated: true, completion: nil)
    }
}
