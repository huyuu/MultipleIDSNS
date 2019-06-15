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
    public static func roundCornersAndAddShadow(shadowLayer: CALayer, contentsLayer: CALayer, of cellType: ShadowType, shadowColor: UIColor=UIColor.black) {
        switch cellType {
        case .MainScrollViewCell:
            self.roundCornersAndAddShadow(shadowLayer: shadowLayer, contentsLayer: contentsLayer, cornerRadius: 50.0, borderWidth: 0.01, shadowOpacity: 0.2, shadowOffset: 7.0, shadowRadius: 5.0, shadowColor: shadowColor)
            
            
        case .SearchResultCell:
            self.roundCornersAndAddShadow(shadowLayer: shadowLayer, contentsLayer: contentsLayer, cornerRadius: 20.0, borderWidth: 0.01, shadowOpacity: 0, shadowOffset: 0, shadowRadius: 0, shadowColor: UIColor.clear)
            
            
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

public enum ShadowType {
    case MainScrollViewCell
    case SearchResultCell
}



// MARK: CAShapeLayer Extension

extension CAShapeLayer {
    /**
     Draw a Next Pattern
     - parameter insetsBy: input the insets of the pattern. Note that only the top and bottom value will be used.
    */
    public static func drawNextPattern(in frame: CGRect, insetsBy insets: UIEdgeInsets=UIEdgeInsets(top: 3, left: 0, bottom: 3, right: 0), controlDistanceFromVerticalCenter: CGFloat=3.0) -> CGPath {
        
        let path = UIBezierPath()
        let center = CGPoint(x: frame.width / 2, y: frame.height / 2)
        let startPoint = CGPoint(x: center.x, y: insets.top)
        let middlePoint = CGPoint(x: center.x + controlDistanceFromVerticalCenter, y: center.y)
        let endPoint = CGPoint(x: center.x , y: frame.height - insets.bottom)
        
        path.move(to: startPoint)
        path.addLine(to: middlePoint)
        path.addLine(to: endPoint)
        return path.cgPath
    }
}



// MARK: - UIColor Extension

extension UIColor {
    public convenience init?(_ hexString: String) {
        guard let red = Int( "0x\(hexString.prefix(2))" ),
            let green = Int( "0x\(hexString.prefix(2))" ),
            let blue = Int( "0x\(hexString.prefix(2))" ) else { return nil }
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    
    public static let defaultBlueColor: UIColor = {
        return UIColor(red: 0, green: 122.0/255.0, blue: 1, alpha: 1)
    }()
}
