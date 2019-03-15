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
    var appDelegate: AppDelegate!
    var coreDataContext: NSManagedObjectContext!
    // The post been tabbed, should be set by the ViewController who calls the segue.
    var postTabbed: Post!
    var selfSNSID: SNSID!
    var localStoredReplies: [Reply]?
    /** For Firebase, expected to be .../postDate */
    var firebaseRoot: DatabaseReference!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let _ = postTabbed, let _ = selfSNSID else {
            raiseFatalError("The optional variable 'postTabbed' in ThreadDetailsTableViewController is nil.")
            fatalError()
        }
        
        /// Load replies from localStored post
        localStoredReplies = postTabbed.replies?.toArray()
        
        firebaseRoot.observe(.value, with: { snapshot in
            /** We are now listening at /.../postDate. snapshot.key=post.date, snapshot.value=post.postInfo
             Therefor, we search from snapshot'schild for key of "replies" and pass its value to JSON decoder of Reply
             */
            if let replies: [Reply] = snapshot.childSnapshot(forPath: Post.CodingKeysOfPost.replies.rawValue).decodeTo(insertInto: self.coreDataContext) {
                self.localStoredReplies = replies
                self.tableView.reloadData()
            }
        })
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
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
        let post = postTabbed!

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
            let replies = localStoredReplies!

            let reply = replies[indexPath.row.advanced(by: -2)]
            // Set speakerName
            let targetNameLabel = cell.viewWithTag(200) as! UILabel
            targetNameLabel.text = "@ \(post.speakerName)"
            // Set content
            let contentLabel = cell.viewWithTag(201) as! UILabel
            contentLabel.text = reply.content
            // Set time
            let dateLabel = cell.viewWithTag(202) as! UILabel
            dateLabel.text = reply.date.toStringForPresentation
            
            return cell
        }
    }
 

    
    // MARK: - Table View System Functions
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
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
            destinationController.appDelegate = appDelegate
            destinationController.coreDataContext = coreDataContext

        default:
            raiseFatalError("Segue preparing error, segue.identifier = \(segue.identifier)")
        }
    }
 

    
    @IBAction func backToTimeLine(_ sender: UIBarButtonItem) {
        firebaseRoot.removeAllObservers()
        self.dismiss(animated: true, completion: nil)
    }
}
