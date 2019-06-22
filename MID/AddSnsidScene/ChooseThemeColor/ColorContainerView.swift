//
//  ColorContainerView.swift
//  MID
//
//  Created by 江宇揚 on 2019/06/16.
//  Copyright © 2019 Jiang Yuyang. All rights reserved.
//

import UIKit

@IBDesignable
class ColorContainerView: UIView {
    
    
    var themeColor: UIColor = UIColor.placeHolderForThemeColor
    var colorButtons: [ColorUnitButton] = []
    /// color unit density

    lazy var radius: CGFloat = {
        return self.frame.size.width / 2
    }()
    weak var delegate: ChooseThemeColorViewController!

    
    
    // MARK: - inits
    
    func completeInit(delegate: ChooseThemeColorViewController) {
        self.delegate = delegate
        self.themeColor = delegate.resources.themeColor
        self.backgroundColor = UIColor.clear
        
        // generate coloredButtons to self
        if let positions = delegate.resources.colorUnitPositions {
            self.colorButtons = self.generateColoredButtons(from: positions)
        } else {
            delegate.resources.generateColorUnitPositions(in: self.frame, elementSize: ColorUnitButton.intrinsicSize, completionHandler: { [unowned self] (positions) in
                self.colorButtons = self.generateColoredButtons(from: positions)
                self.layoutSubviews()
            })
        }
    }
    
    
    
    
    // MARK: - Required Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
    
    
    
    // MARK: Custom Helper Functions
    
    
    private func generateColoredButtons(from positions: [ColorUnitPositionInfo]) -> [ColorUnitButton] {
        let themeColor = delegate.resources.themeColor
        let blackOutDistance: CGFloat = min( self.frame.width, self.frame.height )
        var index = 0
        
        let colorButtons = positions.map { (positionInfo) -> ColorUnitButton in
            let colorUnit = ColorUnit(position: positionInfo, themeColor: themeColor, blackOutDistance: blackOutDistance)
            let button = colorUnit.translateToButton(withIndex: index)
            // handle touch up
            button.addTarget(self, action: #selector(didSelectColor(_:)), for: .touchUpInside)
            self.addSubview(button)
            index += 1
            return button
        }
        return colorButtons
    }
    
    
    @objc func didSelectColor(_ sender: ColorUnitButton) {
        // pass the functionalities to delegate
        self.delegate!.didSelectColor(sender)
    }
    
    
    internal func adjustApperanceDuringScrolling(containerFrame: CGRect) {
        self.colorButtons.forEach { (button) in
            button.scale(accordingTo: containerFrame)
        }
        self.layoutSubviews()
    }
}



// MARK: - ColorUnit Definition

/// A _lightweight_ color unit type for general usage which should latter be transformed to ColorUnitButton type.
fileprivate struct ColorUnit {
    // instances should be initialized
    let position: ColorUnitPositionInfo
    var themeColor: UIColor
    var fillColor: UIColor
    // default instances
    var origin: CGPoint {
        return CGPoint(x: self.position.center.x - ColorUnitButton.intrinsicSize.width/2, y: self.position.center.y - ColorUnitButton.intrinsicSize.height/2)
    }
    let size: CGSize = ColorUnitButton.intrinsicSize
    static let multiConstant: CGFloat = 0.1
    
    
    init(position: ColorUnitPositionInfo, themeColor: UIColor, blackOutDistance: CGFloat) {
        self.themeColor = themeColor
        self.position = position
        // set fillColor
        let hueValue = position.normalizedAngle
        let saturationValue: CGFloat = 1.0
        let brightnessValue = max( 1 - position.distanceFromContainerCenter/blackOutDistance, 0 )
        self.fillColor = UIColor(hue: hueValue, saturation: saturationValue, brightness: brightnessValue, alpha: 1.0)
    }
    
    
    func translateToButton(withIndex index: Int) -> ColorUnitButton {
        return ColorUnitButton(fillWith: self.fillColor,
                               frame: CGRect(x: self.origin.x, y: self.origin.y, width: ColorUnitButton.intrinsicSize.width, height: ColorUnitButton.intrinsicSize.height),
                               withIndex: index)
    }
}


