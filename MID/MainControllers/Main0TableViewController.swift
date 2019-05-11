//
//  Main1TableViewController.swift
//  MID
//
//  Created by 江宇揚 on 2018/12/10.
//  Copyright © 2018 Jiang Yuyang. All rights reserved.
//

import UIKit
import Firebase

class Main0TableViewController: UITableViewController {
    
    /**
     Prepare coreDataContext
     [Here](https://qiita.com/ktanaka117/items/e721b076ceffd182123f) is some useful source to be refered to :)
    */
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let coreDataContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    /** For local stored ID list using CoreData. One should always has at least one SNSID, so this var is never nil. */
    var snsids: [SNSID]? = nil
    /** For account name etc. */
    var storedAccountInfos: StoredAccountInfos! = nil
    var account: Account! = nil
    /** For generate viewController */
    let pageIndex = 0
    /**
     A Firebase database reference.
     * Questions? refer to [this URL](https://www.raywenderlich.com/3-firebase-tutorial-getting-started)
    */
    var firebaseRoot: DatabaseReference!
    
    
    
    // MARK: - Load the view
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Main0TableViewController did load.")
        
//        For debug, should only be conducted once.
//        self.addAccount()
        
        // Fetch account information from coreDataContext
        do {
            storedAccountInfos = try coreDataContext.fetch(StoredAccountInfos.fetchRequest())[0]  // One can only have one account.
        } catch let error as NSError {
            raiseFatalError("Could not fetch data from CoreDataContext to localStoredIDs or account. \(error), \(error.userInfo)")
        }
        print(storedAccountInfos.ref)
        
        // If any SNSID exists, fetch SNSIDs from account
//                if let snsids = account.snsids {
//                    localStoredIDs = snsids.allObjects as! [SNSID]
//                    print(localStoredIDs!.count)
//                }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Fetch data from Firebase and reload Data
        firebaseRoot = Database.rootReference()
        // Init account from reference url
        Account.initSelf(fromReference: firebaseRoot.child("userTank").child(storedAccountInfos.email).url,
                         completionQueue: DispatchQueue.main,
                         completionHandler: { newAccount in
            self.account = newAccount
            newAccount.initChildren(for: "snsids", completionQueue: DispatchQueue.main, completionHandler: { (snsids: [SNSID]) in
                self.snsids = snsids
                self.tableView.reloadData()
                print("here!!!")
            })
            self.tableView.reloadData()
        })
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
            if let _ = account {
                return 1  // One can only have one account
            } else {
                return 0
            }
        // Secon section shows IDs
        case 1:
            return snsids?.count ?? 0
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
            iDNameLabel.text = snsids![indexPath.row].name
            
            return cell
        }
    }
    

    
    // MARK: - Custom actions
    
    // For debug only
    func addAccount() {
        let email = "plr258@gmail_com"
        // Save new acount to CoreDate
        let newAccount = StoredAccountInfos(email: email, name: "Yuyang", password: "empires", insertInto: coreDataContext)

//        coreDataContext.delete(newAccount)
        appDelegate.saveContext()
    }
    
//    func delectAccount(_ account: Account) {
//        // refer to https://www.raywenderlich.com/7104-beginning-core-data/lessons/4  6:00
//        coreDataContext.delete(account)
//        appDelegate.saveContext()
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
        if editingStyle == .delete, indexPath.section != 0 {
            // Delete the row from CoreData
//            coreDataContext.delete(localStoredIDs![indexPath.row])
//            appDelegate.saveContext()
            
            // Delete the item from Firebase
            let toBeDeleteSNSID = snsids![indexPath.row]
            toBeDeleteSNSID.ref.getFIRDatabaseReference.removeValue()
//            firebaseRoot.child(Account.CodingKeysOfAccount.snsids.rawValue).child(toBeDeleteSNSID.name).removeValue()
            
            // Delete the row of tableView
            snsids!.remove(at: indexPath.row)
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
            let tabbedSNSID = snsids![indexPathTabbed.row]
            destinationController.snsid = tabbedSNSID
            // Pass account information to ThreadDetailsViewController
//            destinationController.firebaseRoot = firebaseRoot.child(Account.CodingKeysOfAccount.snsids.rawValue).child(tabbedSNSID.name)
            destinationController.firebaseRoot = tabbedSNSID.ref.getFIRDatabaseReference
            
        case "addSNSID":
            let destinationController = segue.destination as! AddSNSIDViewControllerNew
            // Pass account information to AddSNSIDViewController
            destinationController.owner = account
            destinationController.firebaseRoot = firebaseRoot
            
        default:
            raiseFatalError("Segue preparing error, segue.identifier = \(segue.identifier)")
        }
    }

    
}
