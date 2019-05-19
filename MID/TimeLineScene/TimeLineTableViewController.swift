//
//  Main1TableViewController.swift
//  MID
//
//  Created by 江宇揚 on 2018/12/12.
//  Copyright © 2018 Jiang Yuyang. All rights reserved.
//

import UIKit
import CoreData
import Firebase


class TimeLineTableViewController: UITableViewController {
    
//    /** For tabbed SNSID */
//    public var snsid: SNSID!
//    /** For Firebase, expected to be .../tabbedSNSIDKey  */
//    public var firebaseRoot: DatabaseReference!
//    private var favorTimeLine: [Post]! {
//        willSet {
//            self.tableView.reloadData()
//        }
//    }
    public var resources: ResourcesForTimeLineScene! {
        didSet {
            // chance stands that tableView doesn't exist
            self.tableView?.reloadData()
        }
    }

    
    // MARK: - Load the view
    
    override func viewDidLoad() {
        super.viewDidLoad()        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        /// Fetch data from proper timeline at once.
//        self.resources.snsid.generateTimeLine(type: .favor, completionHandler: { (posts) in
//            self.resources.favorTimeLine = posts.sorted(by: {$0.date > $1.date})
//            self.tableView.reloadData()
//        })
        // TODO: - add oberver for firebase reference
    }
    
    
    
    // MARK: - Table view cell configuration

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Fixed
        return 1
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // If there are presaved posts return the amount, otherwise 0 (only as a original setting for a new SNSID).
        return resources.favorTimeLine.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Creatng reusable cells
        let cell = tableView.dequeueReusableCell(withIdentifier: self.resources.reuseIdentifier, for: indexPath) as! TimeLineTableViewCell
        
        self.showTimeLineDetailThroughUI(for: cell, indexPath: indexPath)
        self.addAutoLayoutConstraints(for: cell)
        
        return cell
    }
    
    
    // Determine the cell's height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let contentsHeight = cell.wholeStackView.frame.height
//        return contentsHeight + resources.spaceToBottom + resources.spaceToTop
        return UITableView.automaticDimension
    }
    

    
 
    
    // MARK: - Table view cell actions

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Unhilight the cell after selected
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: resources.segueIdentifierForPostDetails, sender: tableView.cellForRow(at: indexPath))
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//    }
    

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

    
 
    // MARK: - Navigations
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case resources.segueIdentifierForPostDetails:
            let destinationController = segue.destination as! PostDetailsTableViewController
            // Set the postTabbed of TimeLineTableViewController
            let cell = sender as! TimeLineTableViewCell
            let row = tableView.indexPath(for: cell)!.row
            let postTabbed = self.resources.favorTimeLine[row]
            destinationController.resources = self.resources.translateToResourcesForPostDetails(post: postTabbed, ownerController: destinationController)
            
            
        case resources.segueIdentifierForAddPost:
            let destinationController = segue.destination as! AddPostViewController
            // Pass speaker to AddSNSIDViewController
            destinationController.resources = self.resources.translateToResourcesForAddPost(ownerController: destinationController)
            
        default:
            raiseFatalError("Segue preparing error, segue.identifier = \(segue.identifier!)")
        }
    }
    
    
    @IBAction func backToSNSIDList(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}



// MARK: - Custom helper functions

private extension TimeLineTableViewController {
    func showTimeLineDetailThroughUI(for cell: TimeLineTableViewCell, indexPath: IndexPath) {
        // remember that favorTimeLine propertiy is already been sorted.
        let post = self.resources.favorTimeLine[indexPath.row]
        
        let speakerNameLabel = cell.viewWithTag(301) as! UILabel
        speakerNameLabel.text = post.speakerName
        let dateLabel = cell.viewWithTag(302) as! UILabel
        dateLabel.text = post.date.toStringForPresentation
        let contentsLabel = cell.viewWithTag(303) as! UILabel
        contentsLabel.text = post.contents
    }
    
    
    func addAutoLayoutConstraints(for cell: TimeLineTableViewCell) {
        
//        cell.contentView.heightAnchor.constraint(greaterThanOrEqualTo: cell.wholeStackView.heightAnchor, constant: 40.0).isActive = true
//        cell.contentView.bottomAnchor.constraint(equalTo: cell.wholeStackView.bottomAnchor, constant: 20.0).isActive = true
//        cell.wholeStackView.topAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: 20.0).isActive = true
//        cell.wholeStackView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 8).isActive = true
//        cell.contentView.trailingAnchor.constraint(equalTo: cell.wholeStackView.trailingAnchor, constant: 8).isActive = true
//        cell.wholeStackView.trailingAnchor.constraint(greaterThanOrEqualTo: cell.labelsStackView.trailingAnchor, constant: 0).isActive = true
//        
//        cell.setNeedsUpdateConstraints()
//        cell.layoutIfNeeded()
    }
    
    
    func refresh() {
        
    }
    
    
    //    func requestPostsFromServer(baseURL: String) {
    //        let defaultURLSession = URLSession(configuration: .default)
    //        let url = URL(string: baseURL)!
    //        defaultURLSession.dataTask(with: url) { (data, response, error) in
    //            // Check error
    //            if let error = error {
    //                raiseFatalError("Response error: \(error)")
    //                return
    //            }
    //
    //            // Check whether there is a response from server
    //            guard let httpResponse = response as? HTTPURLResponse else {
    //                raiseFatalError("Response is not a correct HTTP Response.")
    //                return
    //            }
    //
    //            // Check whether the status code is 200 OK
    //            switch httpResponse.statusCode {
    //            case 200:
    //                break
    //            default:
    //                raiseWeakError("Response is not '200 OK'.")
    //                return
    //            }
    //
    //            // Check whether the data exist
    //            guard let data = data else {
    //                raiseFatalError("Data from the server is nil.")
    //                return
    //            }
    //
    //            // Check valid JSONData
    //            do {
    //                let blockOperations = BlockOperation()
    //                // Decode into [CodablePost]
    //                let posts = try JSONDecoder().decode([CodablePost].self, from: data)
    //                for post in posts {
    //                    blockOperations.addExecutionBlock {
    //                        let newPost = Post(from: post, insertInto: self.coreDataContext)
    //                    }
    //                }
    //                // When all post is read, update the UI by a completion handler
    //                blockOperations.completionBlock = {
    //                    self.appDelegate.saveContext()
    //                    OperationQueue.main.addOperation {
    //                        self.tableView.reloadData()
    //                    }
    //                }
    //                blockOperations.start()
    //
    //            } catch let error {
    //                raiseFatalError("Can't decode to Post: \(error)")
    //                return
    //            }
    //        }.resume()
    //    }
}
