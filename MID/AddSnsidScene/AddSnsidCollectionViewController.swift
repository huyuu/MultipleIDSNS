////
////  AddSnsidCollectionViewController.swift
////  MID
////
////  Created by 江宇揚 on 2019/06/07.
////  Copyright © 2019 Jiang Yuyang. All rights reserved.
////
//
//import UIKit
//
//
//class AddSnsidCollectionViewController: UICollectionViewController {
//
//    public var resources: ResourcesForAddSnsidScene!
//    /// calculate item size and store it.
//    private lazy var calculatedItemSize: CGSize = {
//        let collectionViewSize = collectionView.frame.size
//        let width = collectionViewSize.width - resources.cellInsets.left - resources.cellInsets.right
//        let height = collectionViewSize.height - resources.cellInsets.top - resources.cellInsets.bottom
//
//        return CGSize(width: width, height: height)
//    }()
//
//
//
//    // MARK: - Configuration
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.prepareForViewDidLoad()
//    }
//
//
//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1 // Fixed
//    }
//
//
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return resources.numberOfItems
//    }
//
//
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: resources.blocks[indexPath.row].reuseIdentifier, for: indexPath)
//
//        self.configureCell(of: cell, for: indexPath)
//        self.updateUI(of: cell, for: indexPath)
//
//        return cell
//    }
//
//
//
//    // MARK: UICollectionViewDelegate
//
//    /*
//    // Uncomment this method to specify if the specified item should be highlighted during tracking
//    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//    */
//
//    /*
//    // Uncomment this method to specify if the specified item should be selected
//    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//    */
//
//    /*
//    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
//    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
//        return false
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
//        return false
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
//
//    }
//    */
//
//}
//
//
//
//// MARK: - CUstom Helper Functions
//
//private extension AddSnsidCollectionViewController {
//    func prepareForViewDidLoad() {
//        self.navigationItem.rightBarButtonItem = nil
//        self.navigationItem.title = resources.navigationItemTitle
//    }
//
//
//    /// configure cell
//    func configureCell(of cell: UICollectionViewCell, for index: IndexPath) {
//        let layout = collectionView.collectionViewLayout as! AddSnsidFlowLayout
//
//        // set itemSize
//        layout.itemSize = self.calculatedItemSize
//    }
//
//
//    /// update UI
//    func updateUI(of cell: UICollectionViewCell, for index: IndexPath) {
//        /// a general resource for cell
//        var block = resources.blocks[index.row]
//        /// update UI according to different block type
//        switch block.type {
//        case .name:
//            let titleLabel = cell.viewWithTag(11) as! UILabel
//            let userInputTextField = cell.viewWithTag(12) as! UITextField
//
//            titleLabel.text = block.title
//            userInputTextField.placeholder = block.userInputPlaceHolderString
//            userInputTextField.becomeFirstResponder()
//
//
//        case .topics:
//            let titleLabel = cell.viewWithTag(11) as! UILabel
//            let searchingTableView = cell.viewWithTag(100) as! UITableView
//
//            titleLabel.text = block.title
//            searchingTableView.delegate = self
//            searchingTableView.dataSource = self
//
//
//        case .themeColor:
//            let titleLabel = cell.viewWithTag(11) as! UILabel
//            let colorPlateScrollView = cell.viewWithTag(12) as! UIScrollView
//
//            titleLabel.text = block.title
//
//        }
//    }
//
//
//    func updateUI(of TVcell: UITableViewCell, for index: IndexPath) {
//        let searchTopicBlock = resources.staticTopicBlocks[index.row]
//        switch searchTopicBlock.type {
//        case .searchTopic:
//            let searchTextField = TVcell.viewWithTag(12) as! UITextField
//            searchTextField.delegate = self
//            searchTextField.placeholder = ""
//
//
//        case .chosenTopics:
//            // get topicLabels
//            let topicLabels = (1000...1008).map { (tag) -> ChosenTopicLabel in
//                let topicLabel = TVcell.viewWithTag(tag) as! ChosenTopicLabel
//                // only shows necessary labels
//                let i = tag % 1000
//                if i < resources.chosenTopics.count {
//                    topicLabel.isHidden = false
//                    topicLabel.text = resources.chosenTopics[i].title
//                } else {
//                    topicLabel.isHidden = true
//                }
//                return topicLabel
//            }
//
//
//        case .availableTopic:
//            let topicLabel = TVcell.viewWithTag(12) as! UILabel
//
//
//        }
//    }
//
//
//}
//
//
//
//// MARK: - UITableView Delegate
//
//extension AddSnsidCollectionViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return resources.numberOfRows
//    }
//
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let topicCell = tableView.dequeueReusableCell(withIdentifier: resources.staticTopicBlocks[indexPath.row].reuseIdentifier, for: indexPath)
//
//        self.updateUI(of: topicCell, for: indexPath)
//
//        return topicCell
//    }
//}
//
//
//
//// MARK: - UITextField Delegate
//
//extension AddSnsidCollectionViewController: UITextFieldDelegate {
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        // fetch existing topics once textField becomes the first responder.
//        resources.fetchExistingTopics(completion: {
//            self.collectionView.reloadData()
//        })
//        return true
//    }
//
//
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        resources.updateSearchResults(accordingTo: string, completion: {
//            self.collectionView.reloadData()
//        })
//        return true
//    }
//
//
//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        // stop fetching topics from topicTank
//        resources.topicTankRef.removeAllObservers()
//        return true
//    }
//}
