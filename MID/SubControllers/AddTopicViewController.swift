//
//  AddTopicViewController.swift
//  MID
//
//  Created by 江宇揚 on 2019/03/20.
//  Copyright © 2019 Jiang Yuyang. All rights reserved.
//

import UIKit
import Firebase

class AddTopicViewController: UIViewController {
    
    /** For FirebaseDatabase reference, expected to be .../topicTank */
    private var firebaseRoot = Database.rootReference().child("topicTank")
    /// List of topics, should be set by prepare-segue function
    public var topicTitles: [String]!
    public var snsidKey: String!
    
    
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func addTopicDone(_ sender: UIBarButtonItem) {
        let title = titleTextField.text!
        let adherentRef = SNSID.presumeRefOf(tankType: .snsid, member: snsidKey)
        /// A JSONDATA of the snsid who create this topic
        let adherent = [snsidKey!: ["ref": adherentRef]]
        let newTopic = Topic(title: title, adherents: adherent)
        
        firebaseRoot.child(title).setValue(newTopic.toJSON())
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func addTopicCanceled(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    

}


extension AddTopicViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if titleTextField.text! != "" {
            doneBarButton.isEnabled = true
        }
    }
}
