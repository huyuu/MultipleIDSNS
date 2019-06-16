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
    
    
    var themeColor: UIColor = UIColor(hue: 0, saturation: 1.0, brightness: 1.0, alpha: 1.0)
    var colorUnits: [ColorUnitButton] = []
    /// color unit density
    let requiredAmountOfColorUnits = 500
    lazy var radius: CGFloat = {
        return self.frame.size.width / 2
    }()
    weak var delegate: ChooseThemeColorViewController!

    
    
    // MARK: - inits
    
    func completeInit(themeColor: UIColor, delegate: ChooseThemeColorViewController) {
        self.themeColor = themeColor
        self.delegate = delegate
        self.backgroundColor = UIColor.clear
    }
    
    
    
    
    // MARK: - Required Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.prepare()
    }
    
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.prepare()
    }
    
    
    
    // MARK: Custom Helper Functions
    
    private func prepare() {
        let themeColorUnit = ColorUnit(center: self.center, themeColor: self.themeColor)
        let colorButtons = self.generateRandomColorUnits(from: themeColorUnit).map { (colorUnit) -> ColorUnitButton in
            let button = colorUnit.translateToButton(centerUnit: themeColorUnit, radius: self.radius)
            button.addTarget(self, action: #selector(didSelectColor(_:)), for: .touchUpInside)
            self.addSubview(button)
            return button
        }
    }
    
    
    private func generateRandomColorUnits(from centerUnit: ColorUnit) -> [ColorUnit] {
        var colorUnits: [ColorUnit] = [centerUnit]
        var count = colorUnits.count
        // if more is required
        while count < self.requiredAmountOfColorUnits {
            let randomX = CGFloat.random(in: 0...(self.frame.size.width - ColorUnitButton.intrinsicSize.width/2))
            let randomY = CGFloat.random(in: 0...(self.frame.size.height - ColorUnitButton.intrinsicSize.height/2))
            let colorUnit = ColorUnit(center: CGPoint(x: randomX, y: randomY), themeColor: self.themeColor)
            
            if true {
                colorUnits.append(colorUnit)
                count += 1
            }
        }
        
        return colorUnits
    }
    
    
    @objc func didSelectColor(_ sender: ColorUnitButton) {
        sender.setNeedsDisplay()
        self.delegate!.resources.themeColor = sender.fillColor
        self.delegate!.didSelectColor()
    }
}



// MARK: - ColorUnit Definition

fileprivate struct ColorUnit {
    var origin: CGPoint {
        return CGPoint(x: self.center.x - ColorUnitButton.intrinsicSize.width/2, y: self.center.y - ColorUnitButton.intrinsicSize.height/2)
    }
    var center: CGPoint
    let size: CGSize = ColorUnitButton.intrinsicSize
    let themColor: UIColor
    static let multiConstant: CGFloat = 0.1



    init(center: CGPoint, themeColor: UIColor) {
        self.center = center
        self.themColor = themeColor
    }


    func isIsolated(in container: [ColorUnit]) -> Bool {
        for existingColor in container {
            if self.center.distance(from: existingColor.center) <= ColorUnitButton.radius {
                return false
            }
        }
        return true
    }
    
    
    func getColor(from centerUnit: ColorUnit, radius: CGFloat) -> UIColor {
        let containerCenter = centerUnit.center
        let normalizedAngle = self.center.angle(from: containerCenter, normalizedBy: 2*CGFloat.pi)
        
        let hueValue = normalizedAngle
        let saturationValue: CGFloat = 1.0
        let brightnessValue = self.center.distance(from: containerCenter, normalizedBy: radius)
        
        return UIColor(hue: hueValue, saturation: saturationValue, brightness: brightnessValue, alpha: 1.0)
    }
    
    
    func translateToButton(centerUnit: ColorUnit, radius: CGFloat) -> ColorUnitButton {
        let color = self.getColor(from: centerUnit, radius: radius)
        return ColorUnitButton(fillWith: color, frame: CGRect(x: self.origin.x, y: self.origin.y, width: ColorUnitButton.intrinsicSize.width, height: ColorUnitButton.intrinsicSize.height))
    }
}


