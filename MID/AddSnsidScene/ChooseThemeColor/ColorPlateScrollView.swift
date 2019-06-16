//
//  ColorPlateScrollView.swift
//  MID
//
//  Created by 江宇揚 on 2019/06/16.
//  Copyright © 2019 Jiang Yuyang. All rights reserved.
//

import UIKit

@IBDesignable
class ColorPlateScrollView: UIScrollView {
    
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
    }
    
    
    
    // MARK: Custom Helper Functions
    
    private func prepare() {
        
    }
    

}
