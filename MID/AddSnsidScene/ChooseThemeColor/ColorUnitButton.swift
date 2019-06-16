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
}
