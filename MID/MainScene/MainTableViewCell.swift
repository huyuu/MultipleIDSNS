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
                self.favorTimeLine = timeLine
                self.row = newValue.row
            }
            // remember to set the resources for layout
            self.prepareResourcesForLayout(using: newValue)
        } didSet {
            // chance stands that collectionView hasn't been initialized yet.
            self.collectionView?.reloadData()
        }
    }
    /// favorTimeLine of specific snsid, will be set when resources is asigned
    private var favorTimeLine: [Post] = []
    private var row: Int!
    
    
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
        return favorTimeLine.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: ResourcesForMainScrollView.reuseIdentifierForCollectionView, for: indexPath) as! MainCollectionViewCell

        self.customizeLayoutOfCollectionViewCell(for: collectionViewCell, of: collectionView)
        self.showPostDetailThroughUI(for: collectionViewCell, indexPath: indexPath)

        return collectionViewCell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        resources.ownerController.performSegue(withIdentifier: ResourcesForMainScrollView.segueIdentifierForTimeLine, sender: self.row!)
    }
}



// MARK: Custom Helper Functions

extension MainTableViewCell {

    private func configureCollectionView() {
        // register collectionViewCell
        let nibForCollectionViewCell = UINib(nibName: "\(MainCollectionViewCell.self)", bundle: nil)
        self.collectionView.register(nibForCollectionViewCell, forCellWithReuseIdentifier: ResourcesForMainScrollView.reuseIdentifierForCollectionView)

        // Set delegate
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        // set collectionView attributes
        self.collectionView.isPrefetchingEnabled = true
        
        self.collectionView.reloadData()
    }
    
    
    /// layout.itemSize will be set when this function is called.
    private func prepareResourcesForLayout(using resources: ResourcesForMainScrollView) {
        let layout = collectionView.collectionViewLayout as! MainCollectionViewLayout
        layout.resources = resources
    }
    
    
    /// set size of collectionViewCell
    private func customizeLayoutOfCollectionViewCell(for cell: MainCollectionViewCell, of collectionView: UICollectionView) {
        let layout = collectionView.collectionViewLayout as! MainCollectionViewLayout
        // set additional auto layouts
        cell.widthAnchor.constraint(equalToConstant: layout.itemSize.width).isActive = true
        cell.setNeedsUpdateConstraints()
        cell.layoutIfNeeded()
        
        
//        layout.sectionInset = UIEdgeInsets(top: resources.topInset,
//                                           left: resources.leadingInset,
//                                           bottom: resources.topInset,
//                                           right: resources.bottomInset)
        
        cell.prepareResources(using: resources)
    }
    
    
    /// resign proper properties to IBOutlets of collectionViewCell
    private func showPostDetailThroughUI(for cell: MainCollectionViewCell, indexPath: IndexPath) {
        let post = favorTimeLine[indexPath.row]
        cell.speakerNameLabel.text = post.speakerName
        cell.dateLabel.text = post.date.toStringForPresentation
        cell.contentsLabel.text = post.contents
    }
}





