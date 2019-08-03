//
//  TextFieldWithIndicationBorder.swift
//  MID
//
//  Created by 江宇揚 on 2019/07/29.
//  Copyright © 2019 Jiang Yuyang. All rights reserved.
//

import UIKit

@IBDesignable
class TextFieldWithIndicationBorder: UITextField {

    private var isInputAvailable = true
    private let validBorderColor = UIColor.correctColor
    private let invalidBorderColor = UIColor.errorBackgroundColor
    
    private let edgeInsets = UIEdgeInsets(top: 8, left: 24, bottom: 8, right: 24)
    

    override func awakeFromNib() {
        super.awakeFromNib()
        self.prepare()
    }
    
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.prepare()
    }
    
    
    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        
        size.width += edgeInsets.left + edgeInsets.right
        size.height += edgeInsets.top + edgeInsets.bottom
        return size
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let borderLayer = CAShapeLayer()
        // draw border
        let linewidth: CGFloat = 3.0
        let borderLineInsets = UIEdgeInsets(top: linewidth/2, left: linewidth/2, bottom: linewidth/2, right: linewidth/2)
        borderLayer.frame = CGRect(x: self.bounds.origin.x-edgeInsets.left,
                                   y: self.bounds.origin.y-edgeInsets.top,
                                   width: self.bounds.width + edgeInsets.left + edgeInsets.right,
                                   height: self.bounds.height + edgeInsets.top + edgeInsets.bottom)
        let borderLine = UIBezierPath(roundedRect: borderLayer.bounds.inset(by: borderLineInsets), cornerRadius: Standards.CornerRadius.formalTextField)
        
        borderLayer.path = borderLine.cgPath
        borderLayer.lineWidth = linewidth
        let strokeColor = isInputAvailable ? validBorderColor : invalidBorderColor
        borderLayer.strokeColor = strokeColor.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        
        layer.addSublayer(borderLayer)
    }
    
    
    
    // MARK: Custom Helper Functions
    
    private func prepare() {
        self.borderStyle = .none
    }
    
    
    internal func layoutAccodingTo(_ isInputAvailable: Bool) {
        self.isInputAvailable = isInputAvailable
        self.setNeedsDisplay()
    }
}
