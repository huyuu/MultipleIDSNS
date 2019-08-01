//
//  UpArrowButton.swift
//  MID
//
//  Created by 江宇揚 on 2019/08/01.
//  Copyright © 2019 Jiang Yuyang. All rights reserved.
//

import UIKit

@IBDesignable
class UpDownArrowButton: UIButton {
    
    private var direction: CAShapeLayer.NextPatternDirection = .level
    private var strokeColor = UIColor.primaryDarkColor
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.prepare()
    }
    
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.prepare()
    }
    
    
    override func draw(_ rect: CGRect) {
        let arrowPath: UIBezierPath = {
            switch self.direction {
            case .up:
                return CAShapeLayer.drawNextPattern(in: rect, direction: .up)
            case .down:
                return CAShapeLayer.drawNextPattern(in: rect, direction: .down)
            case .level:
                return CAShapeLayer.drawNextPattern(in: rect, direction: .level)
            default:
                fatalError("Unexpectedly detect directions out of up, down and level in UpDownArrowButton.")
            }
        }()
        
        arrowPath.lineWidth = 6.0
        arrowPath.lineCapStyle = .round
        arrowPath.lineJoinStyle = .round
        
        strokeColor.setStroke()
        arrowPath.stroke()
    }
    
    
    
    // MARK: Custom Helper Functions
    
    private func prepare() {
        
    }
    
    
    internal func completeInitWith(strokeColor: UIColor?=nil) {
        if let strokeColor = strokeColor {
            self.strokeColor = strokeColor
        }
        
        setNeedsDisplay()
    }
    
    
    internal func layoutAccordingTo(direction: CAShapeLayer.NextPatternDirection?=nil, strokeColor: UIColor?=nil) {
        if let strokeColor = strokeColor {
            self.strokeColor = strokeColor
        }
        
        if let direction = direction {
            self.direction = direction
        }
        setNeedsDisplay()
    }
}
