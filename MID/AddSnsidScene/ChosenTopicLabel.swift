//
//  ChosenTopicLabel.swift
//  MID
//
//  Created by 江宇揚 on 2019/06/07.
//  Copyright © 2019 Jiang Yuyang. All rights reserved.
//

import UIKit

@IBDesignable
class ChosenTopicLabel: UILabel {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
        self.tintColor = UIColor.blue
    }
    
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = 5.0
        layer.borderColor = UIColor.blue.cgColor
        layer.borderWidth = 1.0
    }
}
