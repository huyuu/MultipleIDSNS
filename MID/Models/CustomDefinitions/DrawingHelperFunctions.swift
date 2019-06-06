//
//  DrawingHelperFunctions.swift
//  MID
//
//  Created by 江宇揚 on 2019/05/11.
//  Copyright © 2019 Jiang Yuyang. All rights reserved.
//

import Foundation
import UIKit

// MARK: - CALayer Extension

extension CALayer {
    
    /// Public func for rounding corers and  adding shadow. The caller should select a cell type.
    public static func roundCornersAndAddShadow(shadowLayer: CALayer, contentsLayer: CALayer, of cellType: CellType, shadowColor: UIColor=UIColor.black) {
        switch cellType {
        case .MainScrollViewCell:
            self.roundCornersAndAddShadow(shadowLayer: shadowLayer, contentsLayer: contentsLayer, cornerRadius: 50.0, borderWidth: 0.01, shadowOpacity: 0.2, shadowOffset: 7.0, shadowRadius: 5.0, shadowColor: shadowColor)
        }
    }
    
    
    /// Pirvate action func should only be called privatly
    private static func roundCornersAndAddShadow(shadowLayer: CALayer, contentsLayer: CALayer, cornerRadius: CGFloat=50.0, borderWidth: CGFloat=1, shadowOpacity: Float=0.5, shadowOffset: CGFloat=4.0, shadowRadius: CGFloat=5.0, shadowColor: UIColor=UIColor.black) {
        contentsLayer.cornerRadius = cornerRadius
        
        contentsLayer.borderWidth = borderWidth
        contentsLayer.borderColor = UIColor.lightGray.cgColor
        
        contentsLayer.backgroundColor = UIColor.clear.cgColor
        contentsLayer.masksToBounds = true
        
        
        shadowLayer.shadowColor = shadowColor.cgColor
        shadowLayer.shadowOffset = CGSize(width: shadowOffset, height: shadowOffset)
        shadowLayer.shadowRadius = shadowRadius
        shadowLayer.shadowOpacity = shadowOpacity
        shadowLayer.masksToBounds = false
    }
}



// MARK: - Shadow Type Enum Definition

public enum CellType {
    case MainScrollViewCell
}
