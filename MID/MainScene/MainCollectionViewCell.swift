//
//  MainCollectionViewCell.swift
//  MID
//
//  Created by 江宇揚 on 2019/05/05.
//  Copyright © 2019 Jiang Yuyang. All rights reserved.
//

import UIKit

@IBDesignable class MainCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var speakerNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentsLabel: UILabel!
    @IBOutlet weak var wholeContentsStackView: UIStackView!
    
    public var resources: ResourcesForMainScrollView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.configure()
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        CALayer.roundCornersAndAddShadow(shadowLayer: self.layer, contentsLayer: self.contentView.layer)
    }
    
    
    override func prepareForReuse() {
        speakerNameLabel.text = ""
        dateLabel.text = ""
        contentsLabel.text = ""
    }
    
    
    // MARK: - Custom Helper Functions
    
    private func configure() {
        guard let resources = self.resources else { return }
        
        // set autoLayouts
//        wholeContentsStackView.heightAnchor.constraint(equalToConstant: resources.itemSize.height - (resources.topInset + resources.bottomInset) ).isActive = true
        self.setNeedsUpdateConstraints()
        self.layoutIfNeeded()
    }
    
    
    internal func prepareResources(using resources: ResourcesForMainScrollView) {
        self.resources = resources
    }
}
