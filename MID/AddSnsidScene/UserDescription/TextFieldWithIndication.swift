//
//  TextFieldWithIndication.swift
//  MID
//
//  Created by 江宇揚 on 2019/07/11.
//  Copyright © 2019 Jiang Yuyang. All rights reserved.
//

import UIKit

@IBDesignable
class TextFieldWithIndication: UITextField {
    
    
    private var isContentAccepitable: Bool = true
    private let correctColor = UIColor.green
    private let wrongColor = UIColor.red
    
    
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
        let border = UIBezierPath(roundedRect: self.bounds.inset(by: borderInsets), cornerRadius: 20)
        border.lineWidth = linewidth
        let strokeColor = isContentAccepitable ? correctColor : wrongColor
        strokeColor.setStroke()
        border.stroke()
        
        // draw text
        let edgeInsets = UIEdgeInsets(top: 8, left: 24, bottom: 8, right: 24)
        super.drawText(in: rect.inset(by: edgeInsets))
    }
    
    
    
    // MARK: Custom Helper Functions
    
    private func prepare() {
        
    }
    
    
    internal func layoutAccordingTo(_ isContentAccepitable: Bool) {
        self.isContentAccepitable = isContentAccepitable        
        setNeedsDisplay()
    }
}
