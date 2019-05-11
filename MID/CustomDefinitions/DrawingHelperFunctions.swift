//
//  DrawingHelperFunctions.swift
//  MID
//
//  Created by 江宇揚 on 2019/05/11.
//  Copyright © 2019 Jiang Yuyang. All rights reserved.
//

import Foundation
import UIKit

public extension CALayer {
    func roundCornersAndAddShadow(borderWidth: CGFloat=1, contentsLayer: CALayer=CALayer()) {
        let backgroundLayer = self
        
        // round corners of the background layer
        backgroundLayer.cornerRadius = 20
        self.masksToBounds = true
        
        // set border line
        self.borderColor = UIColor.gray.cgColor
        self.borderWidth = borderWidth
        
        self.shadowOffset = CGSize(width: 2, height: 2)
        self.shadowOpacity = 0.3
        self.shadowRadius = 5.0
    }
}
