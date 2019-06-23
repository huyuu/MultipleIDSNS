//
//  MainTableViewControllerVer2.swift
//  MID
//
//  Created by 江宇揚 on 2019/05/05.
//  Copyright © 2019 Jiang Yuyang. All rights reserved.
//

import UIKit

class MainScrollViewController: UITableViewController {
    
    /// For dataSource
    private var resources: ResourcesForMainScrollView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Loading data
        resources = ResourcesForMainScrollView()
        resources.completeInitialization(ownerController: self, withCompletionHandler: {
            self.tableView.reloadData()
        })
        
        self.registerTableViewCell()
        self.tableView.separatorStyle = .none

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resources.snsids.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: ResourcesForMainScrollView.reuseIdentifierForTableView, for: indexPath) as! MainTableViewCell
        
        tableViewCell.resources = self.resources.prepareResourcesForCell(row: indexPath.row, cell: tableViewCell)
        
        return tableViewCell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return resources.heightForCell
    }
    
    
    // For row selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: ResourcesForMainScrollView.segueIdentifierForTimeLine,
                          sender: tableView.cellForRow(at: indexPath))
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case ResourcesForMainScrollView.segueIdentifierForTimeLine:
            let destinationController = segue.destination as! TimeLineTableViewController
            // Set the resource from self
            if let cell = sender as? MainTableViewCell {
                let row = tableView.indexPath(for: cell)!.row
                destinationController.resources = self.resources.translateToResourcesForTimeLineScene(forRow: row, ownerController: destinationController)
            } else if let row = sender as? Int {
                destinationController.resources = self.resources.translateToResourcesForTimeLineScene(forRow: row, ownerController: destinationController)
            }
            
            
        case ResourcesForMainScrollView.segueIdentifierForAddSnsid:
            let destinationController = segue.destination as! NewNameViewController
            destinationController.resources = self.resources.translateToResourcesForAddSnsidScene()
            
            
        default:
            break
        }
    }
}




// MARK: - Custom Helper Functions

private extension MainScrollViewController {
    func registerTableViewCell() {
        self.tableView.register(self.resources.nibForTableViewCell, forCellReuseIdentifier: ResourcesForMainScrollView.reuseIdentifierForTableView)
    }
    
    
    
}
