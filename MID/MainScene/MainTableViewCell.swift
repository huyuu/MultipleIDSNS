//
//  MainTableViewCell.swift
//  MID
//
//  Created by 江宇揚 on 2019/05/04.
//  Copyright © 2019 Jiang Yuyang. All rights reserved.
//

import UIKit

@IBDesignable class MainTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    public var resources: ResourcesForMainScrollView! {
        willSet {
            /// if timeLine := [Post] exists
            if let timeLine = newValue.favorTimeLineOf(row: newValue.row) {
                self.timeLine = timeLine
                self.collectionView?.reloadData()
            }
        }
    }
    private var timeLine: [Post] = []
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureCollectionView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
// MARK: - Adapt to CollectionViewProtocals
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return timeLine.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: ResourcesForMainScrollView.reuseIdentifierForCollectionView, for: indexPath) as! MainCollectionViewCell
        
        self.customizeLayoutOfCollectionViewCell(collectionViewCell, of: collectionView)
        self.showPostDetailThroughUI(collectionViewCell, indexPath: indexPath)
        
        return collectionViewCell
    }
}



// MARK: Custom Helper Functions

extension MainTableViewCell {

    private func configureCollectionView() {
        // register collectionViewCell
        let nibForCollectionViewCell = UINib(nibName: "MainCollectionViewCell", bundle: nil)
        self.collectionView.register(nibForCollectionViewCell, forCellWithReuseIdentifier: ResourcesForMainScrollView.reuseIdentifierForCollectionView)

        // Set delegate
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.reloadData()
    }
    
    
    /// set size of collectionViewCell
    private func customizeLayoutOfCollectionViewCell(_ cell: MainCollectionViewCell, of collectionView: UICollectionView) {
        // sizing
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let widthOfTableView = self.frame.width
        layout.itemSize = CGSize(width: widthOfTableView - self.resources.spaceToSide*2,
                                 height: self.resources.heightForCell - self.resources.spaceToBottomTop*2)
        
        // constraints to superView, autoLayout is invalid here.
        layout.sectionInset = UIEdgeInsets(top: self.resources.spaceToBottomTop,
                                           left: self.resources.spaceToSide,
                                           bottom: self.resources.spaceToBottomTop,
                                           right: self.resources.spaceToSide)
        
        // set minspace
        layout.minimumInteritemSpacing = self.resources.minSpaceForItems
    }
    
    
    /// resign proper properties to IBOutlets of collectionViewCell
    private func showPostDetailThroughUI(_ cell: MainCollectionViewCell, indexPath: IndexPath) {
        let post = timeLine[indexPath.row]
        cell.speakerNameLabel.text = post.speakerName
        cell.dateLabel.text = post.date.toStringForPresentation
        cell.contentsLabel.text = post.contents
    }
}





