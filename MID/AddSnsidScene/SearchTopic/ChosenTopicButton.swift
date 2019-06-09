//
//  DeleteButton.swift
//  MID
//
//  Created by 江宇揚 on 2019/06/08.
//  Copyright © 2019 Jiang Yuyang. All rights reserved.
//

import UIKit

@IBDesignable
class ChosenTopicButton: UIButton {
    
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
        // new layer for pattern
        let patternLayer = CAShapeLayer()
        let frameInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        patternLayer.frame = CGRect(x: frameInsets.left,
                                    y: frameInsets.top,
                                    width: self.bounds.height - frameInsets.top - frameInsets.bottom,
                                    height: self.bounds.height - frameInsets.top - frameInsets.bottom)
        patternLayer.lineWidth = 3.5
        patternLayer.lineCap = .round
        patternLayer.strokeColor = UIColor.defaultBlueColor.cgColor
        
        let edges = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        let path = UIBezierPath()
        // for left-top -> right-bottom line
        let startPoint1 = CGPoint(x: edges.left, y: edges.top)
        let endPoint1 = CGPoint(x: patternLayer.frame.width - edges.right, y: patternLayer.frame.height - edges.bottom)
        path.move(to: startPoint1)
        path.addLine(to: endPoint1)
        // for right-top -> left-bottom line
        let startPoint2 = CGPoint(x: patternLayer.frame.width - edges.right, y: edges.top)
        let endPoint2 = CGPoint(x: edges.left, y: patternLayer.frame.height - edges.bottom)
        path.move(to: startPoint2)
        path.addLine(to: endPoint2)
        
        patternLayer.path = path.cgPath
        self.layer.addSublayer(patternLayer)
    }
    
    
    private func prepare() {
        
    }
}
