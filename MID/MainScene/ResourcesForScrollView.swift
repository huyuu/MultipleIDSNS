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


public class ResourcesForMainScrollView {
    /**
     Prepare coreDataContext
     [Here](https://qiita.com/ktanaka117/items/e721b076ceffd182123f) is some useful source to be refered to :)
     */
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let coreDataContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
    var account: Account! = nil
    /**
     A Firebase database reference.
     * Questions? refer to [this URL](https://www.raywenderlich.com/3-firebase-tutorial-getting-started)
     */
    var firebaseRoot: DatabaseReference! = nil
    static let reuseIdentifierForCollectionView = "ReusableCollectionViewCell"
    static let reuseIdentifierForTableView = "ReusableTableViewCell"
    /// Ordered snsidList for representation
    var sortedSnsidNameList: [String] {
        return snsids.map{ $0.name }.sorted(by: <)
    }
    
    // For cell configuration
    let heightForCell: CGFloat = 200.0
    let spaceToSide: CGFloat = 12.0
    let spaceToBottomTop: CGFloat = 8.0
    let minSpaceForItems: CGFloat = 10.0
    
    let nibForTableViewCell = UINib(nibName: "\(MainTableViewCell.self)", bundle: nil)
    
    /// only holds value in tableView scene
    var row: Int?
    /// one's favorTimeLine is set when row is not nil
//    var favorTimeLineForSpecificSnsid: [Post]? {
//        get {
//            return favorTimeLineOf(row: row, timeLines: self.timeLines)
//        }
//        set {}
//    }

    
    
    
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
    func completeInitialization(withCompletionHandler completionHandler: @escaping () -> ()) {
        self.firebaseRoot = Database.rootReference()
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
            let timeLine = self.timeLines[ "\(sortedSnsidNameList[row])" ]
            // check get timeLine successful
            guard let _ = timeLine else {
                raiseWeakError("Error when gettinh timeLine from timeLines.")
                return nil
            }
            return timeLine
        } else {
            return nil
        }
    }
    
    
    public func copyWithRowForCell(row: Int) -> ResourcesForMainScrollView {
        let newValue = self
        newValue.row = row
        return newValue
    }
}



