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

class PostDetailsTableViewController: UITableViewController {
    
    // should be set by delegate in navigation
    public var resources: ResourcesForPostDetails!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCells()
//        firebaseRoot.observe(.value, with: { snapshot in
            /** We are now listening at /.../postDate. snapshot.key=post.date, snapshot.value=post.postInfo
             Therefor, we search from snapshot'schild for key of "replies" and pass its value to JSON decoder of Reply
             */
//            if let replies: [Reply] = snapshot.childSnapshot(forPath: Post.CodingKeysOfPost.replies.rawValue).decodeTo(insertInto: self.coreDataContext) {
//                self.replies = replies
//                self.tableView.reloadData()
//            }
//        })
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        /// Load replies from localStored post
        resources.post.generateReplies(completionHandler: { (newReplies) in
            if let _ = newReplies {
                self.resources.replies = newReplies!.sorted(by: { $0.date > $1.date })
                self.tableView.reloadData()
            }
        })
    }
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // Fixed
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Default value, need to be changed.
        return 2 + (resources.replies?.count ?? 0)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Check which row to present
        switch indexPath.row {
        case 0: // Show the post
            let cell = tableView.dequeueReusableCell(withIdentifier: resources.reuseIdentifierForPostDetailsCell, for: indexPath) as! PostDetailsCell
            self.showPostDetailsThroughUI(for: cell)
            return cell
            
        case 1: // Show buttons for action
            let cell = tableView.dequeueReusableCell(withIdentifier: "reusableCellOfActionButtons", for: indexPath)
            return cell
            
        default: // Show replies of the post
            let cell = tableView.dequeueReusableCell(withIdentifier: "reusableCellOfReply", for: indexPath)
            self.showRepliesThroughUI(for: cell, indexPath: indexPath)
            
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
        case resources.segueIdentifierForAddReply:
            let destinationController = segue.destination as! AddReplyViewController
            // Set the postTabbed of ThreadDetailsViewController
            destinationController.resources = self.resources.translateToResourcesForAddReply()

        default:
            raiseFatalError("Segue preparing error, segue.identifier = \(segue.identifier!)")
        }
    }
 

    
    @IBAction func backToTimeLine(_ sender: UIBarButtonItem) {
        resources.firebaseRoot.removeAllObservers()
        self.dismiss(animated: true, completion: nil)
    }
}



// MARK: - Custom Helper Functions

private extension PostDetailsTableViewController {
    func registerCells() {
        tableView.register(resources.nibForPostDetails, forCellReuseIdentifier: resources.reuseIdentifierForPostDetailsCell)
    }
    
    
    func showPostDetailsThroughUI(for cell: PostDetailsCell) {
        cell.speakerNameLabel.text = resources.post.speakerName
        cell.contentsLabel.text = resources.post.contents
        cell.dateLabel.text = resources.post.date.toStringForPresentation
    }
    
    
    func showRepliesThroughUI(for cell: UITableViewCell, indexPath: IndexPath) {
        // Check if there is any reply to the post
        if let replies = resources.replies {
            let reply = replies[indexPath.row.advanced(by: -2)]
            
            // Set speakerName
            let targetNameLabel = cell.viewWithTag(200) as! UILabel
            targetNameLabel.text = "@ \(resources.post.speakerName)"
            // Set content
            let contentsLabel = cell.viewWithTag(201) as! UILabel
            contentsLabel.text = reply.contents
            // Set time
            let dateLabel = cell.viewWithTag(202) as! UILabel
            dateLabel.text = reply.date.toStringForPresentation
        }
    }
}
