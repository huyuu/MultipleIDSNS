//
//  DrawingHelperFunctions.swift
//  MID
//
//  Created by 江宇揚 on 2019/05/11.
//  Copyright © 2019 Jiang Yuyang. All rights reserved.
//

import Foundation
import UIKit

// MARK: - CALayer Extension

extension CALayer {
    
    /// Public func for rounding corers and  adding shadow. The caller should select a cell type.
    public static func roundCornersAndAddShadow(shadowLayer: CALayer, contentsLayer: CALayer, of cellType: ShadowType, cornerRadius: CGFloat?=nil, shadowColor: UIColor=UIColor.black) {
        switch cellType {
        case .MainScrollViewCell:
            self.roundCornersAndAddShadow(shadowLayer: shadowLayer, contentsLayer: contentsLayer, cornerRadius: 50.0, borderWidth: 0.01, shadowOpacity: 0.2, shadowOffset: 7.0, shadowRadius: 5.0, shadowColor: shadowColor)
            
        case .SearchResultCell:
            self.roundCornersAndAddShadow(shadowLayer: shadowLayer, contentsLayer: contentsLayer, cornerRadius: 20.0, borderWidth: 0.01, shadowOpacity: 0, shadowOffset: 0, shadowRadius: 0, shadowColor: UIColor.clear)
            
        case .RoundIconImageView:
            self.roundCornersAndAddShadow(shadowLayer: shadowLayer, contentsLayer: contentsLayer, cornerRadius: cornerRadius!, borderWidth: 0, shadowOpacity: 0.2, shadowOffset: 0, shadowRadius: cornerRadius!, shadowColor: shadowColor)
        }
    }
    
    
    /// Pirvate action func should only be called privatly
    private static func roundCornersAndAddShadow(shadowLayer: CALayer, contentsLayer: CALayer, cornerRadius: CGFloat=50.0, borderWidth: CGFloat=1, shadowOpacity: Float=0.5, shadowOffset: CGFloat=4.0, shadowRadius: CGFloat=5.0, shadowColor: UIColor=UIColor.black) {
        contentsLayer.cornerRadius = cornerRadius
        
        contentsLayer.borderWidth = borderWidth
        contentsLayer.borderColor = UIColor.lightGray.cgColor
        
        contentsLayer.backgroundColor = UIColor.clear.cgColor
        contentsLayer.masksToBounds = true
        
        
        shadowLayer.shadowColor = shadowColor.cgColor
        shadowLayer.shadowOffset = CGSize(width: shadowOffset, height: shadowOffset)
        shadowLayer.shadowRadius = shadowRadius
        shadowLayer.shadowOpacity = shadowOpacity
        shadowLayer.masksToBounds = false
    }
}



// MARK: - Shadow Type Enum Definition

public enum ShadowType {
    case MainScrollViewCell
    case SearchResultCell
    case RoundIconImageView
}



// MARK: CAShapeLayer Extension

extension CAShapeLayer {
    /**
     Draw a Next Pattern
     - parameter insetsBy: input the insets of the pattern. Note that only the top and bottom value will be used.
    */
    public static func drawNextPattern(in frame: CGRect, insetsBy insets: UIEdgeInsets=UIEdgeInsets(top: 3, left: 0, bottom: 3, right: 0), controlDistanceFromVerticalCenter: CGFloat=3.0) -> CGPath {
        
        let path = UIBezierPath()
        let center = CGPoint(x: frame.width / 2, y: frame.height / 2)
        let startPoint = CGPoint(x: center.x, y: insets.top)
        let middlePoint = CGPoint(x: center.x + controlDistanceFromVerticalCenter, y: center.y)
        let endPoint = CGPoint(x: center.x , y: frame.height - insets.bottom)
        
        path.move(to: startPoint)
        path.addLine(to: middlePoint)
        path.addLine(to: endPoint)
        return path.cgPath
    }
    
    
    public static func drawNextPattern(in frame: CGRect, direction: NextPatternDirection = .right) -> UIBezierPath {
        let path = UIBezierPath()
        
        let startPoint: CGPoint = {
            switch direction {
            case .up:
                return CGPoint(x: frame.width/3, y: frame.height*2/3)
            case .down:
                return CGPoint(x: frame.width/3, y: frame.height/3)
            case .left:
                return CGPoint(x: frame.width*2/3, y: frame.height/3)
            case .right:
                return CGPoint(x: frame.width/3, y: frame.height/3)
            case .level:
                return CGPoint(x: frame.width/3, y: frame.height/2)
            }
        }()
        
        let middlePoint: CGPoint = {
            switch direction {
            case .up:
                return CGPoint(x: frame.width/2, y: frame.height/3)
            case .down:
                return CGPoint(x: frame.width/2, y: frame.height*2/3)
            case .left:
                return CGPoint(x: frame.width/3, y: frame.height/2)
            case .right:
                return CGPoint(x: frame.width*2/3, y: frame.height/2)
            case .level:
                return CGPoint(x: frame.width/2, y: frame.height/2)
            }
        }()
        
        let endPoint: CGPoint = {
            switch direction {
            case .up:
                return CGPoint(x: frame.width*2/3, y: frame.height*2/3)
            case .down:
                return CGPoint(x: frame.width*2/3, y: frame.height/3)
            case .left:
                return CGPoint(x: frame.width*2/3, y: frame.height*2/3)
            case .right:
                return CGPoint(x: frame.width/3, y: frame.height*2/3)
            case .level:
                return CGPoint(x: frame.width*2/3, y: frame.height/2)
            }
        }()
        
        path.move(to: startPoint)
        path.addLine(to: middlePoint)
        path.addLine(to: endPoint)
        return path
    }
    
    
    public enum NextPatternDirection {
        case up, down, left, right, level
    }
    
    
    public static func drawCameraPattern(in frame: CGRect) -> (UIBezierPath, UIBezierPath) {
        // general
        let center = CGPoint(x: frame.midX, y: frame.midY)
        let edge = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        
        // set camera outside frame
        let topEdgeForFlash = UIEdgeInsets(top: frame.height/8, left: 0, bottom: 0, right: 0)
        let cornerRadius: CGFloat = (frame.width - edge.left - edge.right)/9
        let shellRect = frame.inset(by: edge).inset(by: topEdgeForFlash)
        let shell = UIBezierPath(roundedRect: shellRect, cornerRadius: cornerRadius)
        
        let shellWidth = frame.inset(by: edge).width
        let leftBottomPoint = CGPoint(x: frame.minX + edge.left + shellWidth/4,
                                      y: frame.minY + edge.top + topEdgeForFlash.top)
        let rightBottomPoint = CGPoint(x: frame.minX + edge.left + shellWidth/4*3,
                                       y: frame.minY + edge.top + topEdgeForFlash.top)
        let leftTopPoint = CGPoint(x: frame.minX + edge.left + shellWidth/3,
                                   y: frame.minY + edge.top)
        let rightTopPoint = CGPoint(x: frame.minX + edge.left + shellWidth/3*2,
                                    y: frame.minY + edge.top)
        
        shell.move(to: leftBottomPoint)
        shell.addLine(to: leftTopPoint)
        shell.addLine(to: rightTopPoint)
        shell.addLine(to: rightBottomPoint)
        shell.close()
        
        shell.lineJoinStyle = .round
        
        // set center circle
        let radius = frame.width/5*2 / 2
        let circle = UIBezierPath(arcCenter: CGPoint(x: shellRect.midX, y: shellRect.midY), radius: radius, startAngle: 0, endAngle: CGFloat.pi*2, clockwise: true)
        circle.lineWidth = 4.0
        
        return (shell, circle)
    }
}



// MARK: - UIColor Extension

extension UIColor {
    public convenience init?(_ hexString: String) {
        let hexStringWithoutSharp = hexString.first == "#" ? String(hexString.dropFirst()) : hexString
        
        guard let red = Int("\(hexStringWithoutSharp.prefix(2))", radix: 16 ),
            let green = Int("\(hexStringWithoutSharp.prefix(4).suffix(2))", radix: 16 ),
            let blue = Int("\(hexStringWithoutSharp.suffix(2))", radix: 16 ) else { return nil }
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    
    public static let defaultBlueColor: UIColor = UIColor(red: 0, green: 122.0/255.0, blue: 1, alpha: 1)
    
    public static let primaryColor = UIColor("#344955")!
    public static let primaryLightColor = UIColor("#5f7481")!
    public static let primaryDarkColor = UIColor("#0b222c")!
    public static let textOnPrimaryColor = UIColor("#ffffff")!
    public static let secondaryColor = UIColor("#f9aa33")!
    public static let secondaryLightColor = UIColor("#ffdc65")!
    public static let secondaryDarkColor = UIColor("#c17b00")!
    public static let textOnSecondaryColor = UIColor("#000000")!
    public static let errorBackgroundColor = UIColor("#B00020")!
    public static let textOnErrorColor = UIColor.white
    public static let correctColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
    
    
    public var rgbComponents: (red: CGFloat, blue: CGFloat, green: CGFloat) {
        var red: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var green: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (red: red, blue: blue, green: green)
    }
    
    
    public var redComponent: CGFloat {
        return rgbComponents.red
    }
    
    
    public var blueComponent: CGFloat {
        return rgbComponents.blue
    }
    
    
    public var greenComponent: CGFloat {
        return rgbComponents.green
    }
    
    
    public var hueComponents: (hue: CGFloat, saturation: CGFloat, brightness: CGFloat) {
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return (hue: hue, saturation: saturation, brightness: brightness)
    }
    
    
    public var hueComponent: CGFloat {
        return hueComponents.hue
    }
    
    
    public var saturationComponent: CGFloat {
        return hueComponents.saturation
    }
    
    
    public var brightnessComponent: CGFloat {
        return hueComponents.brightness
    }
    
    
    public func toHexString() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format: "#%06x", rgb)
    }
    
    
    public static var placeHolderForThemeColor = UIColor(hue: 0, saturation: 1.0, brightness: 1.0, alpha: 1.0)
}
