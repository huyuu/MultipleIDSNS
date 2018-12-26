//
//  ThreadDetailTableViewController.swift
//  MID
//
//  Created by 江宇揚 on 2018/12/23.
//  Copyright © 2018 Jiang Yuyang. All rights reserved.
//

import UIKit

class ThreadDetailsTableViewController: UITableViewController {
    
    let pageIndex = 1
    // The post been tabbed, should be set by the ViewController who calls the segue.
    var postTabbed: CodablePost?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Default value, need to be changed.
        return 2
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Check whether postTabbed exists, which should always be true, otherwise raise fatal error and return an empty cell
        guard let post = postTabbed else {
            raiseFatalError("The optional variable 'postTabbed' in ThreadDetailsTableViewController is nil.")
            return tableView.dequeueReusableCell(withIdentifier: "reusableCellOfPostDetail", for: indexPath)
        }

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
            
            return cell
            
        case 1: // Show buttons for action
            let cell = tableView.dequeueReusableCell(withIdentifier: "reusableCellOfActionButtons", for: indexPath)
            return cell
            
        default: // Show replies of the post
            let cell = tableView.dequeueReusableCell(withIdentifier: "reusableCellOfReply", for: indexPath)
            // Check if there is any reply to the post
            guard let reply = post.replies?[indexPath.row-2] else {
                return cell
            }
            // Set speakerName
            let speakerNameLabel = cell.viewWithTag(200) as! UILabel
            speakerNameLabel.text = reply.speakerName
            // Set content
            let contentLabel = cell.viewWithTag(201) as! UILabel
            contentLabel.text = reply.content
            // Set time
            let dateLabel = cell.viewWithTag(202) as! UILabel
            
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    @IBAction func backToTimeLine(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
