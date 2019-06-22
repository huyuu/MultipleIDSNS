//
//  colorUnitButton.swift
//  MID
//
//  Created by 江宇揚 on 2019/06/15.
//  Copyright © 2019 Jiang Yuyang. All rights reserved.
//

import UIKit

@IBDesignable
class ColorUnitButton: UIButton {
    
    /// Main fillColor
    internal var fillColor: UIColor = UIColor.clear
    private var strokeColor: UIColor {
        return self.isHighlighted ? UIColor.lightGray : UIColor.clear
    }
    static let intrinsicSize = CGSize(width: 50, height: 50)
    static let radius: CGFloat = sqrt(ColorUnitButton.intrinsicSize.width*ColorUnitButton.intrinsicSize.width + ColorUnitButton.intrinsicSize.height*ColorUnitButton.intrinsicSize.height)
    
    
    
    // MARK: - inits
    
    init(fillWith color: UIColor, frame: CGRect) {
        super.init(frame: frame)
        self.fillColor = color
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: - Required Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.prepare()
    }
    
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.prepare()
    }
    
    
    override func draw(_ rect: CGRect) {
        // first set colors
        fillColor.setFill()
        strokeColor.setStroke()
        // draw the circle
        let ovalPath = UIBezierPath(ovalIn: rect)
        ovalPath.lineWidth = 2.0
        ovalPath.fill()
        ovalPath.stroke()
    }
    
    
    
    // MARK: Custom Helper Functions
    
    private func prepare() {
        
    }
    
    
    internal func scale(accordingTo scrollViewFrame: CGRect) {
        let buttonCenter = self.center + scrollViewFrame.origin
        
        let leftSpacing = buttonCenter.x - scrollViewFrame.minX
        let rightSpacing = scrollViewFrame.maxX - buttonCenter.x
        let topSpacing = buttonCenter.y - scrollViewFrame.minY
        let bottomSpacing = scrollViewFrame.maxY - buttonCenter.y
        
        let recessiveScale: CGFloat = 0.01
        let dominantScale: CGFloat = 1.0
        let recessiveAlpha: CGFloat = 0.01
        let dominantAlpha: CGFloat = 1.0
        
        guard (leftSpacing>0) && (rightSpacing>0) && (topSpacing>0) && (bottomSpacing>0) else {
            return
        }
        
        let minSpacingToEdge = min( leftSpacing, rightSpacing, topSpacing, bottomSpacing )
        let edgeCenterDistance = max( scrollViewFrame.width, scrollViewFrame.height )
        let centeringRate = minSpacingToEdge / edgeCenterDistance
        let scale = (dominantScale - recessiveScale)*centeringRate + recessiveScale
        let scaleTransFormer = CGAffineTransform(scaleX: scale, y: scale)
        let alpha = (dominantAlpha - recessiveAlpha)*centeringRate + recessiveAlpha
        
        self.transform = scaleTransFormer
        self.alpha = alpha
        self.setNeedsDisplay()
    }
}
