//
//  NewTopicButton.swift
//  MID
//
//  Created by 江宇揚 on 2019/06/29.
//  Copyright © 2019 Jiang Yuyang. All rights reserved.
//

import UIKit

@IBDesignable
class EdisonBulbButton: UIButton {
    
    override var isEnabled: Bool {
        didSet { setNeedsDisplay() }
    }
    private var strokeColor: UIColor {
        return self.isEnabled ? UIColor.secondaryColor : UIColor.lightGray
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        self.prepare()
    }
    
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.prepare()
    }
    
    
    override func draw(_ rect: CGRect) {
        strokeColor.setStroke()
        
        // global properties
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let linewidth: CGFloat = Standards.LineWidth.Thin
        
        
        // draw shell
        let shellRadius: CGFloat = rect.width/2 * 0.6
        let shellHalfAngle: CGFloat = 30.0 // in degree
        let shell = UIBezierPath(arcCenter: center, radius: shellRadius, startAngle: (90+shellHalfAngle)/180*CGFloat.pi, endAngle: (90-shellHalfAngle)/180*CGFloat.pi, clockwise: true)
        
        shell.lineWidth = linewidth
        shell.lineCapStyle = .round
        shell.stroke()
        
        
        // draw ground lines
        let groundLines = UIBezierPath()
        let lineSpacing: CGFloat = linewidth*2
        let firstGroundLineMidPoint = CGPoint(x: center.x, y: center.y + shellRadius*cos(shellHalfAngle/180*CGFloat.pi))
        let secondGroundLineMidPoint = firstGroundLineMidPoint + CGPoint(x: 0, y: lineSpacing)
        let thirdGroundLineMidPoint = firstGroundLineMidPoint + CGPoint(x: 0, y: lineSpacing*2)
        let shrimpRate: CGFloat = 0.6
        let groundLineHalfLength: CGFloat = shellRadius * 0.8
        // first ground line
        groundLines.move(to: firstGroundLineMidPoint)
        groundLines.addLine(to: firstGroundLineMidPoint + CGPoint(x: groundLineHalfLength, y: 0))
        groundLines.move(to: firstGroundLineMidPoint)
        groundLines.addLine(to: firstGroundLineMidPoint - CGPoint(x: groundLineHalfLength, y: 0))
        // second ground line
        groundLines.move(to: secondGroundLineMidPoint)
        groundLines.addLine(to: secondGroundLineMidPoint + CGPoint(x: groundLineHalfLength*shrimpRate, y: 0))
        groundLines.move(to: secondGroundLineMidPoint)
        groundLines.addLine(to: secondGroundLineMidPoint - CGPoint(x: groundLineHalfLength*shrimpRate, y: 0))
        // third ground line
        groundLines.move(to: thirdGroundLineMidPoint)
        groundLines.addLine(to: thirdGroundLineMidPoint + CGPoint(x: groundLineHalfLength*shrimpRate*shrimpRate, y: 0))
        groundLines.move(to: thirdGroundLineMidPoint)
        groundLines.addLine(to: thirdGroundLineMidPoint - CGPoint(x: groundLineHalfLength*shrimpRate*shrimpRate, y: 0))
        
        groundLines.lineCapStyle = .round
        groundLines.lineWidth = linewidth
        groundLines.stroke()
        
        
        // metal line
        let metalLine = UIBezierPath()
        metalLine.move(to: center)
        metalLine.addLine(to: firstGroundLineMidPoint)
        
        metalLine.lineCapStyle = .round
        metalLine.lineWidth = linewidth
        metalLine.stroke()
        
        
        // glory
        let glory = UIBezierPath()
        let gloryStartRadius: CGFloat = shellRadius * 1.2
        let gloryEndRadius: CGFloat = shellRadius * 1.6
        // left glory
        glory.move(to: center + CGPoint(x: -gloryStartRadius, y: 0))
        glory.addLine(to: center + CGPoint(x: -gloryEndRadius, y: 0))
        // up glory
        glory.move(to: center + CGPoint(x: 0, y: -gloryStartRadius))
        glory.addLine(to: center + CGPoint(x: 0, y: -gloryEndRadius))
        // right glory
        glory.move(to: center + CGPoint(x: gloryStartRadius, y: 0))
        glory.addLine(to: center + CGPoint(x: gloryEndRadius, y: 0))
        // left up glory
        glory.move(to: center + CGPoint(x: -gloryStartRadius/sqrt(2), y: -gloryStartRadius/sqrt(2)))
        glory.addLine(to: center + CGPoint(x: -gloryEndRadius/sqrt(2), y: -gloryEndRadius/sqrt(2)))
        // right up glory
        glory.move(to: center + CGPoint(x: gloryStartRadius/sqrt(2), y: -gloryStartRadius/sqrt(2)))
        glory.addLine(to: center + CGPoint(x: gloryEndRadius/sqrt(2), y: -gloryEndRadius/sqrt(2)))
        
        glory.lineCapStyle = .round
        glory.lineWidth = linewidth
        glory.stroke()
    }
    
    
    
    // MARK: Custom Helper Functions
    
    private func prepare() {
        self.isEnabled = false
    }
}
