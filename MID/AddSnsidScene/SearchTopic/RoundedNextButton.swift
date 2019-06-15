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
        
        // draw next arror path
        let patternLayer = CAShapeLayer()
        patternLayer.path = CAShapeLayer.drawNextPattern(in: self.layer.frame, insetsBy: UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0), controlDistanceFromVerticalCenter: 20.0)
        patternLayer.lineCap = .round
        patternLayer.lineWidth = 8.0
        patternLayer.lineJoin = .round
        patternLayer.strokeColor = UIColor.defaultBlueColor.cgColor
        patternLayer.fillColor = UIColor.clear.cgColor
        
        // set cornerRadisus
        layer.cornerRadius = self.frame.width / 2
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.defaultBlueColor.cgColor
        
        layer.addSublayer(patternLayer)
    }
    
    
    
    // MARK: Custom Helper Functions
    
    private func prepare() {
        
    }
}
