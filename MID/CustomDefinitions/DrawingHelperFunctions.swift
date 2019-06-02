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
    static func roundCornersAndAddShadow(shadowLayer: CALayer, contentsLayer: CALayer, borderWidth: CGFloat=1, shadowOpacity: Float=0.5, shadowOffset: CGFloat=4.0) {
        contentsLayer.cornerRadius = 50.0
        
        contentsLayer.borderWidth = borderWidth
        contentsLayer.borderColor = UIColor.lightGray.cgColor
        
        contentsLayer.backgroundColor = UIColor.clear.cgColor
        contentsLayer.masksToBounds = true
        
        
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowOffset = CGSize(width: shadowOffset, height: shadowOffset)
        shadowLayer.shadowRadius = 5
        shadowLayer.shadowOpacity = shadowOpacity
        shadowLayer.masksToBounds = false
    }
    
    
    
}
