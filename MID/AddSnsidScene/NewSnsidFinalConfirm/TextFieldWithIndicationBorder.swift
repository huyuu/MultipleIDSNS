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

    private var isInputAvailable = false
    private let validBorderColor = UIColor.green
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
    
    
    override func draw(_ rect: CGRect) {
        // draw border
        let linewidth: CGFloat = 3.0
        let borderInsets = UIEdgeInsets(top: linewidth/2, left: linewidth/2, bottom: linewidth/2, right: linewidth/2)
        let border = UIBezierPath(roundedRect: self.bounds.inset(by: borderInsets), cornerRadius: 16)
        border.lineWidth = linewidth
        let strokeColor = isInputAvailable ? validBorderColor : invalidBorderColor
        strokeColor.setStroke()
        border.stroke()
        
        // draw text
        let textInsets = UIEdgeInsets(top: edgeInsets.top, left: edgeInsets.left+4, bottom: edgeInsets.bottom, right: edgeInsets.right+4)
        super.drawText(in: rect.inset(by: textInsets))
        self.sizeToFit()
    }
    
    
    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        
        size.width += edgeInsets.left + edgeInsets.right
        size.height += edgeInsets.top + edgeInsets.bottom
        return size
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
