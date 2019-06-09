//
//  InvalidNameDescriptionLabel.swift
//  MID
//
//  Created by 江宇揚 on 2019/06/08.
//  Copyright © 2019 Jiang Yuyang. All rights reserved.
//

import UIKit

@IBDesignable
class InvalidNameDescriptionLabel: UILabel {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.prepare()
    }
    
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.prepare()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = 10.0
        layer.borderWidth = 1.0
        layer.borderColor = self.tintColor.cgColor
    }
    
    
    internal var textWithoutOffset: String? {
        get {
            // shouldn't be referred to
            guard let text = self.text else { return nil }
            return text
        }
        set {
            guard let newValue = newValue else { self.text = nil; return }
            self.text = "   \(newValue)   "
        }
    }
    
    
    private func prepare() {
        self.tintColor = UIColor.red
    }
}

