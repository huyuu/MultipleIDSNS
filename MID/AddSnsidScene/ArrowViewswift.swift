//
//  ArrowBarButtonItem.swift
//  MID
//
//  Created by 江宇揚 on 2019/08/05.
//  Copyright © 2019 Jiang Yuyang. All rights reserved.
//

import UIKit

@IBDesignable
class ArrowView: UIView {
    
    private var accentColor: UIColor = UIColor.white
    private var direction: CAShapeLayer.NextPatternDirection = .up
    
    
    override func draw(_ rect: CGRect) {
        let arrowPath: UIBezierPath = {
            switch self.direction {
            case .up:
                return CAShapeLayer.drawNextPattern(in: rect, direction: .up)
            case .down:
                return CAShapeLayer.drawNextPattern(in: rect, direction: .down)
            case .left:
                return CAShapeLayer.drawNextPattern(in: rect, direction: .left)
            case .right:
                return CAShapeLayer.drawNextPattern(in: rect, direction: .right)
            case .level:
                return CAShapeLayer.drawNextPattern(in: rect, direction: .level)
            }
        }()
        
        arrowPath.lineWidth = Standards.LineWidth.Medium
        arrowPath.lineCapStyle = .round
        arrowPath.lineJoinStyle = .round
        
        accentColor.setStroke()
        arrowPath.stroke()
    }
    
    
    
    // MARK: Custom Helper Functions
    
    internal func layoutWith(accentColor: UIColor, direction: CAShapeLayer.NextPatternDirection) {
        self.accentColor = accentColor
        self.direction = direction
        self.backgroundColor = UIColor.clear
        setNeedsDisplay()
    }
}
