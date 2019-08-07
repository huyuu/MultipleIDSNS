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


//
//// MARK: - ColorUnit Definition
//
///// A _lightweight_ color unit type for general usage which should latter be transformed to ColorUnitButton type.
//fileprivate struct ColorUnit {
//    // instances should be initialized
//    let position: ColorUnitPositionInfo
//    var themeColor: UIColor
//    var fillColor: UIColor
//    // default instances
//    var origin: CGPoint {
//        return CGPoint(x: self.position.center.x - ColorUnitButton.intrinsicSize.width/2, y: self.position.center.y - ColorUnitButton.intrinsicSize.height/2)
//    }
//    let size: CGSize = ColorUnitButton.intrinsicSize
//    static let multiConstant: CGFloat = 0.1
//
//
//    init(position: ColorUnitPositionInfo, themeColor: UIColor, blackOutDistance: CGFloat) {
//        self.themeColor = themeColor
//        self.position = position
//        // set fillColor
//        let hueValue = position.normalizedAngle
//        let saturationValue: CGFloat = 1.0
//        let brightnessValue = max( 1 - position.distanceFromContainerCenter/blackOutDistance, 0 )
//        self.fillColor = UIColor(hue: hueValue, saturation: saturationValue, brightness: brightnessValue, alpha: 1.0)
//    }
//
//
//    func translateToButton(withIndex index: Int) -> ColorUnitButton {
//        return ColorUnitButton(fillWith: self.fillColor,
//                               frame: CGRect(x: self.origin.x, y: self.origin.y, width: ColorUnitButton.intrinsicSize.width, height: ColorUnitButton.intrinsicSize.height),
//                               withIndex: index)
//    }
//}


