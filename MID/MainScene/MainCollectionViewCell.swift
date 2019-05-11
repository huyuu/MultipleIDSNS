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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.roundCornersAndAddShadow()
    }
}
