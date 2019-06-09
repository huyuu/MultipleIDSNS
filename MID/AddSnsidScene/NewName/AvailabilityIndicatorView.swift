//
//  AvailabilityIndicatorView.swift
//  MID
//
//  Created by 江宇揚 on 2019/06/08.
//  Copyright © 2019 Jiang Yuyang. All rights reserved.
//

import UIKit


@IBDesignable
class AvailabilityIndicatorView: UIView {

    private let pathLayer = CAShapeLayer()
    private let lineWidth: CGFloat = 4.0
    
    
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
        
        layer.addSublayer(pathLayer)
    }
    
    
    
    // Methods
    
    private func prepare() {
        self.backgroundColor = UIColor.clear
    }
    
    
    internal func layoutAccording(to available: Bool) {        
        if available {
            pathLayer.path = self.drawPossitivePattern()
        } else {
            pathLayer.path = self.drawNegativePattern()
        }
        pathLayer.strokeColor = ResourcesForAddSnsidScene.indicatorColor(accordingTo: available).cgColor
        pathLayer.fillColor = UIColor.clear.cgColor
        pathLayer.lineWidth = lineWidth
        pathLayer.lineCap = .round
    }
    
    
    private func drawPossitivePattern() -> CGPath {
        // calculate startPoint and rectSize from bounds
        let startPoint = CGPoint(x: lineWidth/2, y: lineWidth/2)
        let rectSize = CGSize(width: self.bounds.width - lineWidth*2, height: self.bounds.height - lineWidth*2)
        // create circle
        let path = UIBezierPath(ovalIn: CGRect(x: startPoint.x, y: startPoint.y, width: rectSize.width, height: rectSize.height))
        
        return path.cgPath
    }
    
    
    private func drawNegativePattern() -> CGPath {
        let edges = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        let path = UIBezierPath()
        // for left-top -> right-bottom line
        let startPoint1 = CGPoint(x: edges.left, y: edges.top)
        let endPoint1 = CGPoint(x: self.bounds.width - edges.right, y: self.bounds.height - edges.bottom)
        path.move(to: startPoint1)
        path.addLine(to: endPoint1)
        // for right-top -> left-bottom line
        let startPoint2 = CGPoint(x: self.bounds.width - edges.right, y: edges.top)
        let endPoint2 = CGPoint(x: edges.left, y: self.bounds.height - edges.bottom)
        path.move(to: startPoint2)
        path.addLine(to: endPoint2)
        
        return path.cgPath
    }
}

