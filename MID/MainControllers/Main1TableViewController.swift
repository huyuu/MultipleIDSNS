//
//  Main1TableViewController.swift
//  MID
//
//  Created by 江宇揚 on 2018/12/12.
//  Copyright © 2018 Jiang Yuyang. All rights reserved.
//

import UIKit

class Main1TableViewController: UITableViewController {
    
    let pageIndex = 1
    // Prepare coreDataContext
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let coreDataContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // For local stored posts
    var localStoredPosts: [Post]? = nil

    
    // MARK: - Load the view
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Main1TableViewController did load.")
        
//        self.tableView.rowHeight = UITableView.automaticDimension

        // self.addPosts()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func viewWillAppear(_ animated: Bool) {
        print("Main1TableViewController will appear.")
        
        // Fetch local stored posts from CoreData
        do {
            localStoredPosts = try coreDataContext.fetch(Post.fetchRequest())
        } catch let error as NSError {
            raiseFatalError("Couldn't fetch posts from coreDataContext. \(error), \(error.userInfo)")
        }
    }
    
    
    
    // MARK: - Table view cell configuration

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Fixed
        return 1
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // If there are presaved posts return the amount, otherwise 0 (only as a original setting for a new SNSID).
        if let posts = localStoredPosts {
            return posts.count
        }
        return 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Creatng reusable cells
        let cell = tableView.dequeueReusableCell(withIdentifier: "com.google.huyuu258.MID.reusableCellOfPosts", for: indexPath)
        
        // Check if there is any locally stored post
        guard let posts = localStoredPosts else {
            return cell  // No post. Only for original user.
        }
        
        // Show the information of the post by UILabels
        let post = posts[indexPath.row]
        // Speaker's name
        let speakerNameLabel = cell.viewWithTag(100) as! UILabel
        let speakerName = post.speakerName
        speakerNameLabel.text = speakerName
        // Content
        let contentLabel = cell.viewWithTag(101) as! UILabel
        contentLabel.text = post.content
        
        return cell
    }
    
    
    // Determine the cell's height
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    
    // MARK: - Custom actions
    
    // For debug only
    func addPosts() {
        for i in 1...3 {
            let newPost = Post(entity: Post.entity(), insertInto: coreDataContext)
            newPost.speakerName = "user\(i)"
            newPost.speakerID = Int64(i)
            newPost.content = "I like the number \(i)"
            appDelegate.saveContext()
        }
    }

    
    func requestPostsFromServer(baseURL: String) {
        let defaultURLSession = URLSession(configuration: .default)
        let url = URL(string: baseURL)!
        defaultURLSession.dataTask(with: url) { (data, response, error) in
            // Check error
            if let error = error {
                raiseFatalError("Response error: \(error)")
                return
            }
            
            // Check whether there is a response from server
            guard let httpResponse = response as? HTTPURLResponse else {
                raiseFatalError("Response is not a correct HTTP Response.")
                return
            }
            
            // Check whether the status code is 200 OK
            switch httpResponse.statusCode {
            case 200:
                break
            default:
                raiseWeakError("Response is not '200 OK'.")
                return
            }
            
            // Check whether the data exist
            guard let data = data else {
                raiseFatalError("Data from the server is nil.")
                return
            }
            
            // Check valid JSONData
            do {
                let blockOperations = BlockOperation()
                // Decode into [CodablePost]
                let posts = try JSONDecoder().decode([CodablePost].self, from: data)
                for post in posts {
                    blockOperations.addExecutionBlock {
                        let newPost = Post(of: post, insertInto: self.coreDataContext)
                    }
                }
                // When all post is read, update the UI by a completion handler
                blockOperations.completionBlock = {
                    self.appDelegate.saveContext()
                    OperationQueue.main.addOperation {
                        self.tableView.reloadData()
                    }
                }
                blockOperations.start()
                
            } catch let error {
                raiseFatalError("Can't decode to Post: \(error)")
                return
            }
        }.resume()
    }
    
 
    
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

    
 
    // MARK: - Navigations
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "showThreadDetails":
            let destinationController = segue.destination as! ThreadDetailsTableViewController
            
            // Set the postTabbed of ThreadDetailsViewController
            let indexPathTabbed = tableView.indexPath(for: sender as! UITableViewCell)!
            destinationController.postTabbed = CodablePost( localStoredPosts![indexPathTabbed.row] )
            
        default:
            raiseFatalError("Segue preparing error, segue.identifier = \(segue.identifier)")
        }
    }
}

