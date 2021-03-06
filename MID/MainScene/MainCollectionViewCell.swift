//
//  MainCollectionViewCell.swift
//  MID
//
//  Created by 江宇揚 on 2019/05/05.
//  Copyright © 2019 Jiang Yuyang. All rights reserved.
//

import UIKit

@IBDesignable
class MainCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var speakerNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentsLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var wholeContentsStackView: UIStackView!
    @IBOutlet weak var wholeContentsView: UIView!
    
    
    public var resources: ResourcesForMainScrollView! {
        willSet { self.setShadowColor(resources: newValue) }
    }
    private var shadowColor: UIColor! = UIColor.black
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // add shadow and border to contentView
        CALayer.roundCornersAndAddShadow(shadowLayer: self.layer, contentsLayer: self.contentView.layer, of: .MainScrollViewCell, shadowColor: self.shadowColor)
        
        // set iconImageView cornerRadius
        iconImageView.layer.cornerRadius = 5
        iconImageView.layer.masksToBounds = true
    }
    
    
    override func prepareForReuse() {
        speakerNameLabel.text = ""
        dateLabel.text = ""
        contentsLabel.text = ""
    }
    
    
    // MARK: - Custom Helper Functions
    
    internal func prepareResources(using resources: ResourcesForMainScrollView) {
        self.resources = resources
    }
    
    
    private func setShadowColor(resources: ResourcesForMainScrollView) {
        let currentSnsid = resources.snsidOf(row: resources.row!)!
        guard let shadowColorString = currentSnsid.settings["themeColor"] as? String,
            let shadowColor = UIColor(shadowColorString) else { return }
        self.shadowColor = shadowColor
    }
}
