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
    
    var isColorSelected: Bool = false
    var fillColor: UIColor = UIColor.clear {
        didSet {
            self.setNeedsDisplay()
        }
    }
    static let intrinsicFrame: CGRect = {
        let intrinsicSize = CGSize(width: 70, height: 70)
        let screenRect = UIScreen.main.bounds
        let centerOfButton = CGPoint(x: screenRect.midX, y: screenRect.maxY - 20.0)
        let originOfButton = centerOfButton - CGPoint(x: intrinsicSize.width/2, y: intrinsicSize.height/2)
        
        return CGRect(origin: originOfButton, size: intrinsicSize)
    }()
    
    
    override func draw(_ rect: CGRect) {
        let strokeColor = isColorSelected ? UIColor.white : UIColor.defaultBlueColor
        
        strokeColor.setStroke()
        fillColor.setFill()
        
        let borderPath = UIBezierPath(ovalIn: rect)
        borderPath.lineWidth = 0.1
        borderPath.stroke()
        borderPath.fill()
        
        let arrowPath = CAShapeLayer.drawNextPattern(in: rect)
        arrowPath.lineWidth = 6.0
        arrowPath.lineCapStyle = .round
        arrowPath.lineJoinStyle = .round
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
    
    
    
    
    // MARK: Custom Helper Functions
    
    private func prepare() {
        
    }
    
    
    internal func updateApperanceWithColor(_ color: UIColor) {
        self.isEnabled = true
        self.isColorSelected = true
        self.fillColor = color
    }
}
