//
//  ThreadDetailTableViewController.swift
//  MID
//
//  Created by 江宇揚 on 2018/12/23.
//  Copyright © 2018 Jiang Yuyang. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class ThreadDetailsTableViewController: UITableViewController {
    
    let pageIndex = 1
    // Prepare coreDataContext
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let coreDataContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // The post been tabbed, should be set by the ViewController who calls the segue.
    var postTabbed: Post!
    var selfSNSID: SNSID!
    var localStoredReplies: [Reply]?
    /** For Firebase */
    var firebaseRoot: DatabaseReference!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let _ = postTabbed else {
            raiseFatalError("The optional variable 'postTabbed' in ThreadDetailsTableViewController is nil.")
            fatalError()
        }
        
        if selfSNSID == nil {
            SNSID.initFromReference(postTabbed.speakerRef, insertInto: coreDataContext, completionHandler: { newSNSID in
                self.selfSNSID = newSNSID
                self.tableView.reloadData()
            })
        }
        
        /// Load replies from localStored post
//        localStoredReplies = postTabbed.replies?.toArray()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        firebaseRoot.observe(.value, with: { snapshot in
            /** We are now listening at /.../postDate. snapshot.key=post.date, snapshot.value=post.postInfo
             Therefor, we search from snapshot'schild for key of "replies" and pass its value to JSON decoder of Reply
            */
            if let replies = snapshot.childSnapshot(forPath: Post.CodingKeysOfPost.replies.rawValue).decodeToReplies(insertInto: self.coreDataContext) {
                self.localStoredReplies = replies
            }
            self.tableView.reloadData()
        })
    }
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Default value, need to be changed.
        return 2 + (localStoredReplies?.count ?? 0)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Check whether postTabbed exists, which should always be true, otherwise raise fatal error and return an empty cell
        guard let post = postTabbed else { fatalError() }

        // Check which row to present
        switch indexPath.row {
        case 0: // Show the post
            let cell = tableView.dequeueReusableCell(withIdentifier: "reusableCellOfPostDetail", for: indexPath)
            // Set speakerName
            let speakerNameLabel = cell.viewWithTag(200) as! UILabel
            speakerNameLabel.text = post.speakerName
            // Set content
            let contentLabel = cell.viewWithTag(201) as! UILabel
            contentLabel.text = post.content
            // Set time
            let dateLabel = cell.viewWithTag(202) as! UILabel
            dateLabel.text = post.date.toStringForPresentation
            
            return cell
            
        case 1: // Show buttons for action
            let cell = tableView.dequeueReusableCell(withIdentifier: "reusableCellOfActionButtons", for: indexPath)
            return cell
            
        default: // Show replies of the post
            let cell = tableView.dequeueReusableCell(withIdentifier: "reusableCellOfReply", for: indexPath)
            // Check if there is any reply to the post
            guard let replies = localStoredReplies else {
                return cell
            }
            
            let reply = replies[indexPath.row-2]
            // Set speakerName
            let speakerNameLabel = cell.viewWithTag(200) as! UILabel
            speakerNameLabel.text = reply.selfSNSIDName
            // Set content
            let contentLabel = cell.viewWithTag(201) as! UILabel
            contentLabel.text = reply.content
            // Set time
            let dateLabel = cell.viewWithTag(202) as! UILabel
            dateLabel.text = reply.date.toStringForPresentation
            
            return cell
        }
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "showAddReplyView":
            let destinationController = segue.destination as! AddReplyViewController
            // Set the postTabbed of ThreadDetailsViewController
            destinationController.targetPost = postTabbed
            destinationController.selfSNSID = selfSNSID
            destinationController.firebaseRoot = firebaseRoot.child(Post.CodingKeysOfPost.replies.rawValue)

        default:
            raiseFatalError("Segue preparing error, segue.identifier = \(segue.identifier)")
        }
    }
 

    
    @IBAction func backToTimeLine(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: {
            self.firebaseRoot.removeAllObservers()
        })
    }
    
}
