//
//  MainCollectionCollectionViewController.swift
//  MID
//
//  Created by 江宇揚 on 2019/04/28.
//  Copyright © 2019 Jiang Yuyang. All rights reserved.
//

import UIKit
import Firebase

//private let reuseIdentifier = "ReusableCollectionViewCell"


class MainCollectionCollectionViewController: UICollectionViewController {
    /// For dataSource
    private var dataSource = DataSourceForMainCollectionView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Loading data
        dataSource.completeInitialization(withCompletionHandler: {
            self.collectionView.reloadData()
        })

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: self.dataSource.reuseIdentifier)

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /// Prepare cells for proper size
        self.configureCellsForProperSize()
    }
    
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.dataSource.snsids.count
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
//        return self.dataSource.timeLines[ dataSource.orderedSnsidNameList[section] ]?.count ?? 0
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: dataSource.reuseIdentifier, for: indexPath)
    
        // Configure the cell
    
        return cell
    }
    
    

    // MARK: UICollectionViewDelegate
    
    @objc func refresh() {
        // Todo:- refresh controls
        collectionView.refreshControl?.endRefreshing()
    }

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
}



// MARK: - Custom Helper Functions

fileprivate extension MainCollectionCollectionViewController {
    func configureCellsForProperSize() {
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let width = (view.frame.size.width)
        layout.itemSize = CGSize(width: width, height: self.dataSource.heightForCell)
    }
}



// MARK: - Data Source Class Definition

fileprivate class DataSourceForMainCollectionView {
    /**
     Prepare coreDataContext
     [Here](https://qiita.com/ktanaka117/items/e721b076ceffd182123f) is some useful source to be refered to :)
     */
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let coreDataContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    /** For local stored ID list using CoreData. One should always has at least one SNSID, so this var is never nil. */
    var snsids: [SNSID] = []
    /// For local stored timeLines
    var timeLines: [String: [Post]] = [:]
    /** For account name etc. */
    var storedAccountInfos: StoredAccountInfos
    var account: Account! = nil
    /**
     A Firebase database reference.
     * Questions? refer to [this URL](https://www.raywenderlich.com/3-firebase-tutorial-getting-started)
     */
    var firebaseRoot: DatabaseReference! = nil
    let reuseIdentifier = "ReusableCollectionViewCell"
    /// Ordered snsidList for representation
    var orderedSnsidNameList: [String] {
        return snsids.map{ $0.name }.sorted(by: <)
    }
    
    let heightForCell: CGFloat = 20.0
    
    
    
    
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
        print("dataSource loaded!!")
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
}
