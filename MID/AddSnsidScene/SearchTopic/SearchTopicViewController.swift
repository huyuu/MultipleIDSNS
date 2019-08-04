//
//  SearchTopicTableViewController.swift
//  MID
//
//  Created by 江宇揚 on 2019/06/08.
//  Copyright © 2019 Jiang Yuyang. All rights reserved.
//

import UIKit

@IBDesignable
class SearchTopicViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    internal var resources: ResourcesForAddSnsidScene!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneButton: RoundedNextButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareForViewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.prepareForViewWillAppear()
    }


    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resources.numberOfSearchTopicCells
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cells = resources.totalSearchTopicCells
        let cell = tableView.dequeueReusableCell(withIdentifier: cells[indexPath.row].reuseId, for: indexPath)
        
        self.updateUI(of: cell, for: indexPath)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        switch resources.totalSearchTopicCells[indexPath.row].type {
        case .searchResult(_):
            // choose topic
            self.didChooseTopic(at: indexPath)
            // reload tableView
            self.refresh()
            
        default:
            break
        }
    }
    
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case resources.segueIdToChooseThemeColor:
            let destinationController = segue.destination as! ChooseThemeColorViewController
            destinationController.resources = self.resources
            
            
        case resources.segueIdToNewTopic:
            let destinationController = segue.destination as! NewTopicViewController
            // remember to set the new topic title
            resources.newTopicTitle = resources.userInputForSearchTopic
            destinationController.resources = self.resources
            break
            
        default:
            break
        }
    }
}



// MARK: - Custom Helper Functions

extension SearchTopicViewController {
    private func prepareForViewDidLoad() {
        // set navigation items
        self.navigationItem.title = resources.navigationItemTitle
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.leftBarButtonItem?.title = "Back"
        // set doneButton
        doneButton.addTarget(self, action: #selector(doneButtonTabbed), for: .touchUpInside)
        doneButton.isEnabled = false
    }
    
    
    private func prepareForViewWillAppear() {
        self.tableView.reloadData()
    }
    
    
    /// update UI of tableView cell
    private func updateUI(of cell: UITableViewCell, for indexPath: IndexPath) {
        let cellAttributes = resources.totalSearchTopicCells[indexPath.row]
        switch cellAttributes.type {
        case let .title(titleString):
            let titleLabel = cell.viewWithTag(11) as! UILabel
            titleLabel.text = titleString
            
            
        case let .searchBar(placeHolderString):
            let searchTextField = cell.viewWithTag(11) as! UITextField
            let newTopicButton = cell.viewWithTag(12) as! EdisonBulbButton
            
            // prepare for user input
            searchTextField.delegate = self
            searchTextField.placeholder = placeHolderString
            searchTextField.becomeFirstResponder()
            newTopicButton.isEnabled = resources.topicCanBeNew
            
            
        case let .chosenTopics(topicTitles):
            let collectionView = cell.viewWithTag(100) as! UICollectionView
            self.configureCollectionView(of: collectionView)
            collectionView.reloadData()
            
            
        case let .searchResult(topicTitle):
            let topicLabel = cell.viewWithTag(11) as! SearchResultLabel
            topicLabel.attributedText = self.paintText(of: topicTitle)!
        }
    }
    
    
    /// configure collectionView
    private func configureCollectionView(of collectionView: UICollectionView) {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .vertical
        // asign minInterSpacing and LineSpacing
        layout.minimumInteritemSpacing = resources.minInterItemSpacing
        layout.minimumLineSpacing = resources.minLineSpacing
        // calculate item size
        let collectionViewSize = collectionView.bounds.size
        let width = ( collectionViewSize.width - layout.minimumInteritemSpacing * (resources.itemsPerRow-1) ) / resources.itemsPerRow
        let height: CGFloat = resources.heightForItem
        layout.itemSize = CGSize(width: width, height: height)
        
    }
    
    
    private func updateUIForChosenTopics(of cell: UICollectionViewCell, for indexPath: IndexPath) {
        let topicButton = cell.viewWithTag(101) as! ChosenTopicButton
        
        topicButton.setTitle("   \(resources.chosenTopicTitles[indexPath.item])", for: .normal)
        // set chosen topic style
        let layer = cell.layer
        layer.cornerRadius = resources.cornerRadiusOfChosenTopicCell
        layer.borderWidth = resources.borderWidthOfChosenTopicCell
        layer.borderColor = UIColor.defaultBlueColor.cgColor
    }
    
    
    private func didChooseTopic(at indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        let topicLabel = cell.viewWithTag(11) as! UILabel
        
        // add topic to resources
        var chosenTitles = resources.chosenTopicTitles
        chosenTitles.append(topicLabel.text!)
        resources.chosenTopicsCell = [ SearchTopicCellAttributes(of: .chosenTopics(chosenTitles)) ]
        // clear userInput
        resources.userInputForSearchTopic = ""
    }
    
    
    private func paintText(of fullText: String) -> NSMutableAttributedString? {
        let mentionedString = resources.userInputForSearchTopic
        let mentionedCharCount = mentionedString.count
        let fullCharCount = fullText.count
        
        for charIndex in 0..<fullCharCount {
            if fullText[fullText.index(fullText.startIndex, offsetBy: charIndex)..<fullText.index(fullText.startIndex, offsetBy: charIndex+mentionedCharCount)] == mentionedString {
                
                let rangeShouldPaint = NSRange(location: charIndex, length: mentionedCharCount)
                let paintedText = NSMutableAttributedString(string: fullText)
                paintedText.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.red], range: rangeShouldPaint)
                return paintedText
            }
        }
        // shouldn't happend
        return nil
    }
    
    
    @objc private func doneButtonTabbed() {
        self.performSegue(withIdentifier: resources.segueIdToChooseThemeColor, sender: nil)
    }
    
    
    private func refresh() {
        doneButton.isEnabled = resources.shouldNavigateToChooseThemeColorScene
        tableView.reloadData()
    }
}




// MARK: - UITextField Delegate

extension SearchTopicViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // if existingTopics is still not fetched, fetch it.
        if let _ = resources.existingTopics {} else {
            resources.fetchExistingTopics(completion: {
                self.refresh()
            })
        }
        // show stored text
        textField.text = resources.userInputForSearchTopic
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        resources.userInputForSearchTopic = textField.textForStorage(newChar: string)
        return true
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.refresh()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        resources.userInputForSearchTopic = textField.text ?? ""
    }
}



// MARK: - CollectionView Delegate

extension SearchTopicViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resources.numberOfChosenTopics
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: resources.reuseIdForChosenTopicsCVCell, for: indexPath)
        
        self.updateUIForChosenTopics(of: cell, for: indexPath)
        
        return cell
    }
}
