//
//  ColorContainerView.swift
//  MID
//
//  Created by 江宇揚 on 2019/06/16.
//  Copyright © 2019 Jiang Yuyang. All rights reserved.
//

import UIKit

@IBDesignable
class ColorContainerView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.prepare()
    }
    
    
    
    // MARK: - Custom Helper Functions
    
    private func prepare() {
        self.backgroundColor = .white
    }
}
