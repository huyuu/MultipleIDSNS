//
//  DataSourceForScrollView.swift
//  MID
//
//  Created by 江宇揚 on 2019/05/05.
//  Copyright © 2019 Jiang Yuyang. All rights reserved.
//

import Foundation
import UIKit
import Firebase


public class ResourcesForMainScrollView: ProjectResource {
    
    // MARK: - CoreData
    
    /**
     Prepare coreDataContext
     [Here](https://qiita.com/ktanaka117/items/e721b076ceffd182123f) is some useful source to be refered to :)
     */
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let coreDataContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    // MARK: - Firebase
    
    /** For local stored ID list using CoreData. One should always has at least one SNSID, so this var is never nil. */
    var snsids: [SNSID] = []
    /// For local stored timeLines, update specific favorTimeLine when timeLines is updated
    var timeLines: [String: [Post]] = [:]
//        willSet {
//            self.favorTimeLineForSpecificSnsid = self.favorTimeLineOf(row: row, timeLines: newValue)
//        }
//    }
    /** For account name etc. */
    var storedAccountInfos: StoredAccountInfos
    /// Ordered snsidList for representation
    var sortedSnsidNameList: [String] {
        return snsids.map{ $0.name }.sorted(by: <)
    }
    var account: Account! = nil
    /**
     A Firebase database reference.
     * Questions? refer to [this URL](https://www.raywenderlich.com/3-firebase-tutorial-getting-started)
     */
    var firebaseRoot: DatabaseReference! = nil
    
    
    
    // MARK: - ReuseIdentifiers and Nibs
    
    static let reuseIdentifierForCollectionView = "ReusableCollectionViewCell"
    static let reuseIdentifierForTableView = "ReusableTableViewCell"
    static let segueIdentifierForTimeLine = "showTimeLine"
    let nibForTableViewCell = UINib(nibName: "\(MainTableViewCell.self)", bundle: nil)
    
    
    
    // MARK: - TableViewCell Configuration
    
    var widthForCell: CGFloat! = nil
    let heightForCell: CGFloat = 200.0
//    let spaceToSide: CGFloat = 12.0
//    let spaceToBottomTop: CGFloat = 8.0
//    let minSpaceForItems: CGFloat = 10.0
    
    
    
    // MARK: - CollectionView Configuration
    
    // item size attributes
    let leadingInset: CGFloat = 12
    let trailingInset: CGFloat = 12
    let topInset: CGFloat = 20
    let bottomInset: CGFloat = 20
    var minInterItemSpacing: CGFloat {
//        return self.heightForCell
        return 5
    }
    let minLineSpacing: CGFloat = 5
    
    // item presentation attributes
    let recessiveAlpha: CGFloat = 0.6
    let dominantAlpha: CGFloat = 1.0
    let recessiveScale: CGFloat = 0.6
    let dominantScale: CGFloat = 1.0
    
    
    
    // MARK: - Special Usage
    
    /// only holds value in tableView scene
    var row: Int?
    weak var ownerController: MainScrollViewController!
    
    
    // MARK: - Functions
    
    /// Main initializer
    init() {
        do {
            self.storedAccountInfos = try coreDataContext.fetch(StoredAccountInfos.fetchRequest())[0]  // One can only have one account.
        } catch let error as NSError {
            raiseFatalError("Could not fetch data from CoreDataContext to localStoredIDs or account. \(error), \(error.userInfo)")
            fatalError()
        }
    }
    
    
    /// Complete the initialization after viewDidLoad.
    func completeInitialization(ownerController: MainScrollViewController, withCompletionHandler completionHandler: @escaping () -> ()) {
        self.firebaseRoot = Database.rootReference()
        self.ownerController = ownerController
        self.asyncInitAccount(completionHandlerForUI: completionHandler)
    }
    
    
    /// Init account from reference url
    func asyncInitAccount(completionHandlerForUI: @escaping () -> ()) {
        //        let group = DispatchGroup()
        Account.initSelf(fromReference: firebaseRoot.child("userTank").child(storedAccountInfos.email).url,
                         completionQueue: DispatchQueue.main,
                         completionHandler: { newAccount in
                            self.account = newAccount
                            newAccount.initChildren(for: "snsids", completionQueue: DispatchQueue.main, completionHandler: { (snsids: [SNSID]) in
                                // asign to dataSource.snsids
                                self.snsids = snsids
                                for snsid in snsids {
                                    snsid.generateTimeLine(type: .favor, completionHandler: { (newTimeLine: [Post]) in
                                        self.timeLines[snsid.name] = newTimeLine
                                        completionHandlerForUI()
                                    })
                                }
                            })
        })
    }
    
    
    /// get timeLine of specific row
    public func favorTimeLineOf(row: Int?) -> [Post]? {
        // if row is set
        if let row = row {
            if let timeLine = self.timeLines[ "\(sortedSnsidNameList[row])" ] {
                return timeLine.sorted(by: { $0.date > $1.date })
            }
        }
        return nil
    }
    
    
    /// search for snsid using row of MainScrollTableView
    public func snsidOf(row: Int?) -> SNSID? {
        if let row = row {
            let returnSnsid = self.snsids.first(where: { (snsid: SNSID) -> Bool in
                return snsid.name == sortedSnsidNameList[row] ? true : false
            })
            return returnSnsid
            
        } else {
            return nil
        }
    }
    
    
    /// copy self with addition of row property
    internal func prepareResourcesForCell(row: Int, cell: MainTableViewCell) -> ResourcesForMainScrollView {
        self.row = row
        self.widthForCell = cell.contentView.frame.width
        return self
    }
}



// MARK: - DataSourceForTimeLineScene

extension ResourcesForMainScrollView: DataSourceForTimeLineScene {
    func translateToResourcesForTimeLineScene(forRow row: Int, ownerController: TimeLineTableViewController) -> ResourcesForTimeLineScene {
        let newResources = ResourcesForTimeLineScene(snsid: self.snsidOf(row: row)!,
                                                     favorTimeLine: self.favorTimeLineOf(row: row)!,
                                                     ownerController: ownerController)
        
        return newResources
    }
}
