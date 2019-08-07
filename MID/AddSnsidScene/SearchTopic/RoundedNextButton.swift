//
//  RoundedDoneButton.swift
//  MID
//
//  Created by 江宇揚 on 2019/06/15.
//  Copyright © 2019 Jiang Yuyang. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedNextButton: UIButton {
    
//    var isColorSelected: Bool = false
//    override var isEnabled: Bool {
//        willSet {
//            fillColor = newValue ? UIColor.white : UIColor.lightGray
//        }
//    }
//    var fillColor: UIColor = UIColor.white {
//        didSet {
//            self.setNeedsDisplay()
//        }
//    }
//    var strokeColor: UIColor {
//        get {
//            if isEnabled {
//                return isColorSelected ? UIColor.white : UIColor.defaultBlueColor
//            } else {
//                return UIColor.white
//            }
//        }
//    }
    static let intrinsicFrame: CGRect = {
        let intrinsicSize = CGSize(width: 70, height: 70)
        let screenRect = UIScreen.main.bounds
        let centerOfButton = CGPoint(x: screenRect.midX, y: screenRect.maxY - 20.0)
        let originOfButton = centerOfButton - CGPoint(x: intrinsicSize.width/2, y: intrinsicSize.height/2)
        
        return CGRect(origin: originOfButton, size: intrinsicSize)
    }()
    
    private var baseColor = UIColor.white
    private var accentColor = UIColor.primaryColor
    private var shouldShowShadow = true
    private var borderWidth: CGFloat = Standards.LineWidth.Wide
    
    
    override func draw(_ rect: CGRect) {
        let borderEdges = UIEdgeInsets(top: borderWidth/2, left: borderWidth/2, bottom: borderWidth/2, right: borderWidth/2)
        let borderPath = UIBezierPath(ovalIn: rect.inset(by: borderEdges))
        borderPath.lineWidth = self.borderWidth
        UIColor.white.setStroke()
        borderPath.stroke()
        
        if self.isEnabled == true {
            baseColor.setFill()
        } else {
            UIColor.lightGray.setFill()
        }
        borderPath.fill()
        
        let arrowPatternEdges = UIEdgeInsets(top: borderWidth, left: borderWidth, bottom: borderWidth, right: borderWidth)
        let arrowPath = CAShapeLayer.drawNextPattern(in: rect.inset(by: arrowPatternEdges))
        arrowPath.lineWidth = Standards.LineWidth.Wide
        arrowPath.lineCapStyle = .round
        arrowPath.lineJoinStyle = .round
        
        if self.isEnabled == true {
            accentColor.setStroke()
        } else {
            UIColor.gray.setStroke()
        }
        arrowPath.stroke()
    }
    
    
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
        if self.shouldShowShadow {
            layer.shadowOpacity = 0.5
            layer.shadowRadius = 10
            layer.masksToBounds = false
            layer.shadowColor = UIColor.lightGray.cgColor
        } else {
            layer.shadowOpacity = 0
        }

    }
    
    
    
    
    // MARK: Custom Helper Functions
    
    private func prepare() {
        
    }
    
    
//    internal func updateApperanceWithColor(_ color: UIColor) {
//        self.isEnabled = true
//        self.isColorSelected = true
//        self.fillColor = color
//    }
    
    
    internal func layoutWith(isEnabled: Bool, baseColor: UIColor, accentColor: UIColor, shouldShowShadow: Bool, borderWidth: CGFloat=Standards.LineWidth.Wide) {
        self.isEnabled = isEnabled
        self.shouldShowShadow = shouldShowShadow
        self.accentColor = accentColor
        self.baseColor = baseColor
        self.borderWidth = borderWidth
        setNeedsDisplay()
    }
}
