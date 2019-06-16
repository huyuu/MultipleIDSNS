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
    var fillColor: UIColor = UIColor.clear
    
    
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
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // draw next arror path
//        let patternLayer = CAShapeLayer()
//        patternLayer.path = CAShapeLayer.drawNextPattern(in: self.layer.frame, insetsBy: UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0), controlDistanceFromVerticalCenter: 20.0)
//        patternLayer.lineCap = .round
//        patternLayer.lineWidth = 6.0
//        patternLayer.lineJoin = .round
//        patternLayer.strokeColor = UIColor.defaultBlueColor.cgColor
//        patternLayer.fillColor = UIColor.clear.cgColor
//        
//        // set cornerRadisus
//        layer.cornerRadius = self.frame.width / 2
//        layer.borderWidth = 0.1
//        layer.borderColor = UIColor.defaultBlueColor.cgColor
//        
//        layer.addSublayer(patternLayer)
    }
    
    
    
    // MARK: Custom Helper Functions
    
    private func prepare() {
        
    }
}
