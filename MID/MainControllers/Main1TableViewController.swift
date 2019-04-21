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


class Main1TableViewController: UITableViewController {
    
    let pageIndex = 1
    /** For tabbed SNSID */
    public var snsid: SNSID!
    /** For Firebase, expected to be .../tabbedSNSIDKey  */
    public var firebaseRoot: DatabaseReference!
    private var favorTimeLine: [Post]! {
        willSet {
            self.tableView.reloadData()
        }
    }

    
    // MARK: - Load the view
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Fetch posts, which is [Post], from SNSID.posts which is a NSSet
    }

    
    override func viewWillAppear(_ animated: Bool) {
        /// Fetch data from proper timeline at once.
        snsid.generateTimeLine(type: .favor, completionHandler: { (posts) in
            if let _ = posts {
                self.favorTimeLine = posts!.sorted(by: {$0.date > $1.date})
                self.tableView.reloadData()
            }
        })
    }
    
    
    
    // MARK: - Table view cell configuration

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Fixed
        return 1
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // If there are presaved posts return the amount, otherwise 0 (only as a original setting for a new SNSID).
        return favorTimeLine?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Creatng reusable cells
        let cell = tableView.dequeueReusableCell(withIdentifier: "com.google.huyuu258.MID.reusableCellOfPosts", for: indexPath)
        
        // If localStorePosts is nil, tableView will present 0 row, meaning that localStoredPosts is never nil at this moment.
        let posts = favorTimeLine!
        // Show the information of the post by UILabels
        let post = posts[indexPath.row]
        
        /// Speaker's name
        let speakerNameLabel = cell.viewWithTag(100) as! UILabel
        speakerNameLabel.text = snsid.name
        /// Content
        let contentsLabel = cell.viewWithTag(101) as! UILabel
        contentsLabel.text = post.contents
        /// Date
        let dateLabel = cell.viewWithTag(102) as! UILabel
        dateLabel.text = post.date.toStringForPresentation
        
        return cell
    }
    
    
    // Determine the cell's height
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    
    // MARK: - Custom actions
    
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
    
 
    
    // MARK: - Table view cell actions

    // Unhilight the cell after selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    }
    

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
        case "showThreadDetails":
            let destinationController = segue.destination as! ThreadDetailsTableViewController
            // Set the postTabbed of ThreadDetailsViewController
            let indexPathTabbed = tableView.indexPath(for: sender as! UITableViewCell)!
            let postTabbed = favorTimeLine![indexPathTabbed.row]
            destinationController.postTabbed = postTabbed
            destinationController.selfSNSID = snsid
            destinationController.firebaseRoot = postTabbed.ref.getFIRDatabaseReference
            
        case "showAddPostView":
            let destinationController = segue.destination as! AddPostViewController
            // Pass speaker to AddSNSIDViewController
            destinationController.speaker = snsid
            
        default:
            raiseFatalError("Segue preparing error, segue.identifier = \(segue.identifier)")
        }
    }
    
    
    @IBAction func backToSNSIDList(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}

