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
        return self.isSelected ? UIColor.white : UIColor.clear
    }
    
    
    
    // MARK: - inits
    
    internal init(fillWith color: UIColor, frame: CGRect) {
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
        let ovalPath = UIBezierPath(ovalIn: rect)
        ovalPath.addClip()
        fillColor.setFill()
        strokeColor.setStroke()
        ovalPath.stroke()
        ovalPath.lineWidth = 2.0        
    }
    
    
    
    // MARK: Custom Helper Functions
    
    private func prepare() {
        
    }
}
