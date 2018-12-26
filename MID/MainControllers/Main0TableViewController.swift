//
//  Main1TableViewController.swift
//  MID
//
//  Created by 江宇揚 on 2018/12/10.
//  Copyright © 2018 Jiang Yuyang. All rights reserved.
//

import UIKit

class Main0TableViewController: UITableViewController {
    
    // Prepare coreDataContext
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let coreDataContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // For local stored ID list using CoreData. One should always has at least one SNSID, so this var is never nil.
    var localStoredIDs: [SNSID]! = nil
    // For account name
    var account: Account! = nil
    // For generate viewController
    let pageIndex = 0
    
    // MARK: - Load the view
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Main0TableViewController did load.")
        
//        For debug, should only be conducted once.
//        self.addAccount()
//        self.addIDAndPosts()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // Fetch data from coreDataContext
        do {
            localStoredIDs = try coreDataContext.fetch(SNSID.fetchRequest())
            account = try coreDataContext.fetch(Account.fetchRequest())[0]  // One can only have one account.
        } catch let error as NSError {
            raiseFatalError("Could not fetch data from CoreDataContext to localStoredIDs or account. \(error), \(error.userInfo)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Main0TableViewController will appear.")
    }

    
    
    // MARK: - Configure cells

    override func numberOfSections(in tableView: UITableView) -> Int {
        // default, need to be changed
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        // First section shows account information
        case 0:
            return 1  // One can only have one account
        // Secon section shows IDs
        case 1:
            return localStoredIDs.count
        // Do we have the third section? No!!
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // For the 'Account' cell
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "reusableCellOfAccount", for: indexPath)
            // Show stored account.name through accountNameLabel
            let accountNameLabel = cell.viewWithTag(10) as! UILabel
            accountNameLabel.text = account.name
            
            return cell
            
        } else { // For ID cells
            let cell = tableView.dequeueReusableCell(withIdentifier: "reusableCellOfSNSID", for: indexPath)
            // Show stored SNSID.name through IDNameLabel
            let iDNameLabel = cell.viewWithTag(11) as! UILabel
            iDNameLabel.text = localStoredIDs[indexPath.row].name
            
            return cell
        }
    }
    

    
    // MARK: - Custom actions
    
    // For debug only
    func addAccount() {
        let newAccount = Account(entity: Account.entity(), insertInto: coreDataContext)
        newAccount.name = "Jiang Yuyang"
        appDelegate.saveContext()
    }
    
    func addIDAndPosts() {
        // refer to https://www.raywenderlich.com/7104-beginning-core-data/lessons/4  6:00
        for i in 1...5 {
            let newID = SNSID(entity: SNSID.entity(), insertInto: coreDataContext)
            newID.name = "testID\(i)"
            
            // new post to certain SNSID
            for j in 1...i {
                print("i, j = \(i), \(j)")
                let newPost = Post(name: "user\(i)", ID: Int64(i*2+j*300), content: "I love the number \(j)", insertInto: coreDataContext)
                newID.addToPosts(newPost)
            }
        }
        
        appDelegate.saveContext()
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

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            coreDataContext.delete(localStoredIDs[indexPath.row])
            appDelegate.saveContext()
            localStoredIDs.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    

    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
    }
    

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "showTimeLine":
            let destinationController = segue.destination as! Main1TableViewController
            
            // Set the postTabbed of ThreadDetailsViewController
            let indexPathTabbed = tableView.indexPath(for: sender as! UITableViewCell)!
            destinationController.tabbedSNSID = localStoredIDs[indexPathTabbed.row]
            
        default:
            raiseFatalError("Segue preparing error, segue.identifier = \(segue.identifier)")
        }
    }

    
}
