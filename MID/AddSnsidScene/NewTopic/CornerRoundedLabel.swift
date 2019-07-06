//
//  CornerRoundedLabel.swift
//  MID
//
//  Created by 江宇揚 on 2019/07/06.
//  Copyright © 2019 Jiang Yuyang. All rights reserved.
//

import UIKit

@IBDesignable
class CornerRoundedLabel: UILabel {
    
    internal var isTitleAvailable: Bool = true {
        didSet { setNeedsDisplay() }
    }
    private var fillColor = UIColor.primaryColor
    private var strokeColor = UIColor.textOnPrimaryColor
    
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
        let border = UIBezierPath(roundedRect: self.bounds.inset(by: borderInsets), cornerRadius: 20)
        border.lineWidth = linewidth
        strokeColor.setStroke()
        border.stroke()
        fillColor.setFill()
        border.fill()
        
        // draw text
        textColor = strokeColor
        super.drawText(in: rect.inset(by: edgeInsets))
    }
    
    
    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize

        size.width += edgeInsets.left + edgeInsets.right
        size.height += edgeInsets.top + edgeInsets.bottom
        return size
    }
    
    
    
    //MARK: - Inits
    
    /**
     layouts according to contents.
     - parameter isContentAcceptable: Determination for layout.
     - parameter fillColor: Filled background color. Use previous value when set to nil.
     - parameter strokeColor: Border and text color. Use previous value when set to nil.
    */
    internal func layoutAccordingTo(isContentAcceptable: Bool, fillColor: UIColor?=nil, strokeColor: UIColor?=nil) {
        if let fillColor = fillColor {
            self.fillColor = isContentAcceptable ? fillColor : .errorBackgroundColor
        }
        if let strokeColor = strokeColor {
            self.strokeColor = isContentAcceptable ? strokeColor : .textOnErrorColor
        }
        setNeedsDisplay()
    }
    
    
    
    // MARK: Custom Helper Functions
    
    private func prepare() {
    }

}
