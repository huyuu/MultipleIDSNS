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
    
    // For local stored ID list using CoreData
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
//        self.addID()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Main0TableViewController will appear.")
        
        // Fetch data from coreDataContext
        do {
            localStoredIDs = try coreDataContext.fetch(SNSID.fetchRequest())
            account = try coreDataContext.fetch(Account.fetchRequest())[0]  // One can only have one account.
        } catch let error as NSError {
            raiseFatalError("Could not fetch data from CoreDataContext to localStoredIDs or account. \(error), \(error.userInfo)")
        }
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
        // Creatng reusable cells
        let cell = tableView.dequeueReusableCell(withIdentifier: "com.google.huyuu258.MID.reusableCell", for: indexPath)

        // For the 'Account' cell
        if indexPath.section == 0 {
            // Show stored account.name through accountNameLabel
            let accountNameLabel = cell.viewWithTag(10) as! UILabel
            guard let accountName = account.name else {
                // accountName is nil
                raiseFatalError("Account.name property is nil.")
                accountNameLabel.text = "Error"
                return cell
            }
            accountNameLabel.text = accountName
            
            // Allow adding IDs
            let addIDButton = cell.viewWithTag(20) as! UIButton
            addIDButton.isHidden = false
            addIDButton.isEnabled = true
            
        } else { // For ID cells
            // Show stored SNSID.name through IDNameLabel
            let iDNameLabel = cell.viewWithTag(10) as! UILabel
            guard let iDName = localStoredIDs[indexPath.row].name else {
                // Name is nil
                raiseFatalError("localStoredIDs[\(indexPath.row)].name property is nil. Something must went wrong when fetching data from CoreDataContext.")
                iDNameLabel.text = "Error"
                return cell
            }
            iDNameLabel.text = iDName
            
            // Hide the addIDButton
            let addIDButton = cell.viewWithTag(20) as! UIButton
            addIDButton.isHidden = true
        }

        return cell
    }
    

    
    // MARK: - Actions
    
    // For debug usement only
    func addAccount() {
        let newAccount = Account(entity: Account.entity(), insertInto: coreDataContext)
        newAccount.name = "Jiang Yuyang"
        appDelegate.saveContext()
    }
    
    func addID() {
        // refer to https://www.raywenderlich.com/7104-beginning-core-data/lessons/4  6:00
        let newID = SNSID(entity: SNSID.entity(), insertInto: coreDataContext)
        newID.name = "testID1"
        appDelegate.saveContext()
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

}
