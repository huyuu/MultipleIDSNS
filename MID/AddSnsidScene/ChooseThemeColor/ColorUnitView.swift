//
//  ColorUnitView.swift
//  MID
//
//  Created by 江宇揚 on 2019/08/06.
//  Copyright © 2019 Jiang Yuyang. All rights reserved.
//

import UIKit

@IBDesignable
class ColorUnitView: UIControl {
    
    /// baseColor will be asigned only once when it is borned. 
    private let baseColor: UIColor
    private var _isColorSelected: Bool = false
    internal var isColorSelected: Bool { return _isColorSelected }
    /// a get only property for reading the color of this color unit when touched.
    internal var color: UIColor { return self.baseColor }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.prepare()
    }
    
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.prepare()
    }
    
    
    override func draw(_ rect: CGRect) {
        // draw the circle
        let circle = UIBezierPath(ovalIn: rect)
        self.baseColor.setFill()
        circle.fill()
        // if isSelected, draw border
        if self._isColorSelected {
            let borderPath: UIBezierPath = {
                let borderwidth = Standards.LineWidth.Thin
                let edges = UIEdgeInsets(top: borderwidth*2, left: borderwidth*2, bottom: borderwidth*2, right: borderwidth*2)
                let borderPath = UIBezierPath(ovalIn: rect.inset(by: edges))
                borderPath.lineWidth = borderwidth
                return borderPath
            }()
            let borderColor = UIColor.white
            borderColor.setStroke()
            borderPath.stroke()
        }
    }
    
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        let circleLayer = CAShapeLayer()
//        circleLayer.path = UIBezierPath(ovalIn: self.bounds).cgPath
//        circleLayer.fillColor = self.baseColor.cgColor
//        layer.addSublayer(circleLayer)
//
//        if self._isColorSelected {
//            let borderPath: UIBezierPath = {
//                let borderwidth = Standards.LineWidth.Thin
//                let edges = UIEdgeInsets(top: borderwidth*2, left: borderwidth*2, bottom: borderwidth*2, right: borderwidth*2)
//                let borderPath = UIBezierPath(ovalIn: self.bounds.inset(by: edges))
//                borderPath.lineWidth = borderwidth
//                return borderPath
//            }()
//            let borderLayer = CAShapeLayer()
//            borderLayer.path = borderPath.cgPath
//            borderLayer.lineWidth = borderPath.lineWidth
//            borderLayer.strokeColor = UIColor.white.cgColor
//            layer.addSublayer(borderLayer)
//        }
//    }
    
    
    internal init(baseColor: UIColor, frame: CGRect) {
        self.baseColor = baseColor
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    /// from [here](https://qiita.com/dnaka@github/items/6718d0c9f1cca1c5a4f3)
    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        self.baseColor = .primaryColor
        super.init(coder: aDecoder)
        self.backgroundColor = .clear
        Bundle.main.loadNibNamed("\(ColorUnitView.self)", owner: self, options: nil)
        self.addSubview(self)
    }
    
    
    
    // MARK: Custom Helper Functions
    
    private func prepare() {
        
    }
    
    
    internal func layoutWith(isSelected: Bool=false) {
        self._isColorSelected = isSelected
        setNeedsDisplay()
//        setNeedsLayout()
    }
}
