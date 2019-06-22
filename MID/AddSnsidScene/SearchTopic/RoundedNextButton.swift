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
