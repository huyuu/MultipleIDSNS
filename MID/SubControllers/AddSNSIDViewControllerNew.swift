//
//  ChooseTopicTableViewController.swift
//  MID
//
//  Created by 江宇揚 on 2019/03/19.
//  Copyright © 2019 Jiang Yuyang. All rights reserved.
//

import UIKit
import Firebase

class AddSNSIDViewControllerNew: UITableViewController {

    /// A dictionary of topic list
    var topicDict: JSONDATA!
    var topicTitles: [String]!
    /// determine whether doneBarButton is enabled
    var topicCount = 0 {
        willSet {
            doneBarButton.isEnabled = newValue >= 7 ? true : false
        }
    }
    /** For FirebaseDatabase reference, expected to be top level ../  */
    public var firebaseRoot: DatabaseReference!
    private var topicTankRef = Database.rootReference().child("topicTank")
    private var snsidTankRef = Database.rootReference().child("snsidTank")
    /** For main account information. This property must be set by the previous controller */
    public var owner: Account!
    private var name: String!
    

    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    
    
    // MARK: - Loading
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Get topic list
        topicTankRef.observe(.value, with: { (snapshot) in
            /// check the amount of topicDictionary
            if let topicDict = snapshot.value as? JSONDATA {
                self.topicDict = topicDict
                self.topicTitles = topicDict.keys.sorted(by: <)
                self.tableView.reloadData()
            }
        })
        
        self.tableView.separatorStyle = .none

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = true

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    
    deinit {
        topicTankRef.removeAllObservers()
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /// if there doesn't exist any topic in the topicTank, return 0 for the cell.
        return topicDict?.count ?? 0
    }

    
    /// Cell For Row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        switch (indexPath.row) {
        case 0: /// fixed SNSID cell
            cell = tableView.dequeueReusableCell(withIdentifier: "reusableIDCell", for: indexPath)
            let nameLabel = cell.viewWithTag(11) as! UILabel
            nameLabel.text = "Name"
//            let nameTextField = cell.viewWithTag(20) as! UITextField
            
        case 1: /// for fixed "Choose Topics" label
            cell = tableView.dequeueReusableCell(withIdentifier: "reusableTopicCell", for: indexPath)
            let titleLabel = cell.viewWithTag(10) as! UILabel
            
            titleLabel.text = "Choose Topics"
            titleLabel.font = UIFont(name: "System", size: 28)
            
        default: /// for choosable topic list
            cell = tableView.dequeueReusableCell(withIdentifier: "reusableTopicCell", for: indexPath)
            let titleLabel = cell.viewWithTag(10) as! UILabel
            
            titleLabel.textColor = self.view.tintColor
            titleLabel.text = "#" + topicTitles[indexPath.row-2]
        }
        
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reusableTopicCell", for: indexPath)
        cell.accessoryType = .checkmark
        tableView.deselectRow(at: indexPath, animated: true)
        topicCount += 1
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    
    
    // MARK: - Custom Functions
    
    @IBAction func doneButtonTabbed(_ sender: UIBarButtonItem) {
//        
//        /** Save new child to Firebase */
//        let newChildReference = snsidTankRef.child("\(owner.email)&&\(name)")
//        
//        /** Create a new SNSID on CoreData */
//        let newSNSID = SNSID(name: name, owner: owner.name, ownerRef: owner.ref, myPosts: nil, myReplies: nil, follows: nil, followers: nil, topics: topicDict, myLikes: nil, focusingPosts: nil)
//        
//        newChildReference.setValue(newSNSID.toJSON())
//        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func addSNSIDCanceled(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! == "addTopic" {
            let destination = segue.destination as! AddTopicViewController
            
            destination.snsidKey = "\(owner.email)&&\(name)"
            destination.topicTitles = topicTitles
        }
    }
}



extension AddSNSIDViewControllerNew: UITextFieldDelegate {
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if let text = textField.text {
            self.name = text
            return true
        } else {
            return false
        }
    }
}
