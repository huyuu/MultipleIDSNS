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
    static func roundCornersAndAddShadow(shadowLayer: CALayer, contentsLayer: CALayer, borderWidth: CGFloat=1) {
        contentsLayer.cornerRadius = 50.0
        
        contentsLayer.borderWidth = 1.0
        contentsLayer.borderColor = UIColor.gray.cgColor
        
        contentsLayer.backgroundColor = UIColor.clear.cgColor
        contentsLayer.masksToBounds = true
        
        
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowOffset = CGSize(width:4, height: 4)
        shadowLayer.shadowRadius = 10
        shadowLayer.shadowOpacity = 1
        shadowLayer.masksToBounds = false
    }
    
    
    
}
