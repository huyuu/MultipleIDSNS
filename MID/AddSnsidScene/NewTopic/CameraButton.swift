//
//  CameraButton.swift
//  MID
//
//  Created by 江宇揚 on 2019/06/29.
//  Copyright © 2019 Jiang Yuyang. All rights reserved.
//

import UIKit

@IBDesignable
class CameraButton: UIButton {
    
    private var fillColor: UIColor = .primaryColor
    private var strokeColor: UIColor = .textOnPrimaryColor
    

    override func awakeFromNib() {
        super.awakeFromNib()
        self.prepare()
    }
    
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.prepare()
    }
    
    /**
     Layouts for different scenes.
     - parameter fillColor: Filled background color. Use previous value when set to nil.
     - parameter strokeColor: Border and text color. Use previous value when set to nil.
     */
    internal func layoutWith(fillColor: UIColor?=nil, strokeColor: UIColor?=nil) {
        if let fillColor = fillColor {
            self.fillColor = fillColor
        }
        if let strokeColor = strokeColor {
            self.strokeColor = strokeColor
        }
        setNeedsDisplay()
    }
    
    
    override func draw(_ rect: CGRect) {        
        // general
        let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        let edge = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        
        // set camera outside frame
        let topEdgeForFlash = UIEdgeInsets(top: self.bounds.height/8, left: 0, bottom: 0, right: 0)
        let cornerRadius: CGFloat = (self.bounds.width - edge.left - edge.right)/9
        let rectShell = UIBezierPath(roundedRect: self.bounds.inset(by: edge).inset(by: topEdgeForFlash), cornerRadius: cornerRadius)
        
        fillColor.setFill()
        rectShell.fill()
        
        let flashShell = UIBezierPath()
        let leftBottomPoint = CGPoint(x: self.frame.width/4, y: edge.top + topEdgeForFlash.top)
        let rightBottomPoint = CGPoint(x: self.frame.width/4*3, y: edge.top + topEdgeForFlash.top)
        let leftTopPoint = CGPoint(x: self.frame.width/3, y: edge.top)
        let rightTopPoint = CGPoint(x: self.frame.width/3*2, y: edge.top)
        
        flashShell.move(to: leftBottomPoint)
        flashShell.addLine(to: leftTopPoint)
        flashShell.addLine(to: rightTopPoint)
        flashShell.addLine(to: rightBottomPoint)
        flashShell.close()
        
        flashShell.lineJoinStyle = .round
        flashShell.fill()
        
        
        // set center circle
        let radius = self.frame.width/5*2 / 2
        let circle = UIBezierPath(arcCenter: CGPoint(x: rectShell.bounds.midX, y: rectShell.bounds.midY), radius: radius, startAngle: 0, endAngle: CGFloat.pi*2, clockwise: true)
        
        circle.lineWidth = 4.0
        strokeColor.setStroke()
        circle.stroke()
    }
    
    
    // MARK: Custom Helper Functions
    
    private func prepare() {
        
    }
}
