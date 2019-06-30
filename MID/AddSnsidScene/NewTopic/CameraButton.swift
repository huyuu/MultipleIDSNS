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

    override func awakeFromNib() {
        super.awakeFromNib()
        self.prepare()
    }
    
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.prepare()
    }
    
    
    override func draw(_ rect: CGRect) {
        let strokeColor = UIColor.textOnPrimaryColor
        let fillColor = UIColor.primaryColor
        
        // general
        let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        let edge = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        
        // set camera outside frame
        let topEdgeForFlash = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
        let rectShell = UIBezierPath(roundedRect: self.bounds.inset(by: edge).inset(by: topEdgeForFlash), cornerRadius: 10.0)
        
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
        let radius = self.frame.width/2 / 2
        let circle = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: CGFloat.pi*2, clockwise: true)
        
        circle.lineWidth = 4.0
        strokeColor.setStroke()
        circle.stroke()
    }
    
    
    // MARK: Custom Helper Functions
    
    private func prepare() {
        
    }
}
