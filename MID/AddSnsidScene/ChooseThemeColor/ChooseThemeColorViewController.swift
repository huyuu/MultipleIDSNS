//
//  ChooseThemeColorViewController.swift
//  MID
//
//  Created by 江宇揚 on 2019/06/08.
//  Copyright © 2019 Jiang Yuyang. All rights reserved.
//

import UIKit

@IBDesignable
class ChooseThemeColorViewController: UIViewController, AddSnsidSceneController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var colorPlateScrollView: ColorPlateScrollView!{
        didSet {
            if let _ = colorContainerView {
                self.prepareWhenColorPlateIsReady()
            }
        }
    }
    @IBOutlet weak var colorContainerView: ColorContainerView!
    
    internal weak var resources: ResourcesForAddSnsidScene! {
        didSet {
            if let _ = resources {
                self.prepareWhenResourcesIsReady()
            }
        }
    }
    internal weak var containerViewController: AddSnsidContainerViewController?
    
    private var colorUnitViews: [ColorUnitView]? = []
    private var selectedColorUnitView: ColorUnitView? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareForViewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.prepareForViewWillAppear()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.prepareForViewDidAppear()
    }
    
    
    
    // MARK: - Navigations
    
    internal func willTransitToNextScene() {
    }
}



// MARK: Custom Helper Functions

extension ChooseThemeColorViewController {
    private func prepareForViewDidLoad() {

    }
    
    
    private func prepareWhenResourcesIsReady() {
        self.generateColorUnitViews(in: resources.colorContainerBounds, elementSize: resources.colorUnitViewSize, completionQueue: DispatchQueue.main, completionHandler: { [unowned self] newPoint in
            // get color for newPoint
            let color: UIColor = {
                let center = CGPoint(x: self.resources.colorContainerBounds.width/2,
                                     y: self.resources.colorContainerBounds.height/2)
                return self.colorForPoint(newPoint, centerPoint: center)
            }()
            // generate new ColorUnitView from newPoint and color
            let newColorUnitView = ColorUnitView(baseColor: color, frame: newPoint.surroundingRect(withSize: self.resources.colorUnitViewSize))
            // add action to it
            newColorUnitView.addTarget(self, action: #selector(self.didSelectColor(_:)), for: .touchUpInside)
            // update database
            self.colorUnitViews?.append(newColorUnitView)
            self.colorContainerView?.addSubview(newColorUnitView)
        })
    }
    
    
    /// only been conducted once
    private func prepareWhenColorPlateIsReady() {
        // set color plate scroll view
        colorPlateScrollView.delegate = self
        colorPlateScrollView.contentSize = colorContainerView.frame.size
        colorPlateScrollView.contentOffset = {
            let scrollViewCenter = CGPoint(x: colorPlateScrollView.bounds.width/2, y: colorPlateScrollView.bounds.height/2)
            let contentViewCenter = colorContainerView.center
            return contentViewCenter - scrollViewCenter
        }()
        //            CGPoint(x: colorContainerView.frame.width/2 - colorPlateScrollView.frame.width/2,
        //                    y: colorContainerView.frame.height/2 - colorPlateScrollView.frame.height/2)
        colorPlateScrollView.decelerationRate = .fast
        
        // only conduct once at colorPlate been set.
        if let colorUnitViews = self.colorUnitViews {
            colorUnitViews.forEach { [unowned self] colorUnitView in
                self.colorContainerView.addSubview(colorUnitView)
            }
            self.colorUnitViews = nil
        }
    }
    
    
    private func prepareForViewWillAppear() {
        // set titleLabel's textColor
        titleLabel.textColor = UIColor.primaryColor
        // if a themeColor is chosen, set to true
        self.containerViewController?.nextButton.isEnabled = resources.themeColor == UIColor.placeHolderForThemeColor ? false : true
    }
    
    
    private func prepareForViewDidAppear() {

    }
    
    
    @objc func didSelectColor(_ colorUnitView: ColorUnitView) {
        // if the color is already selected, reset it to default state
        guard colorUnitView.isColorSelected != true else {
            // update colorUnitButton Appearance
            colorUnitView.layoutWith(isSelected: false)
            colorContainerView.sendSubviewToBack(colorUnitView)
            self.selectedColorUnitView = nil
            return
        }
        
        selectedColorUnitView?.layoutWith(isSelected: false)
        colorUnitView.layoutWith(isSelected: true)
        colorContainerView.bringSubviewToFront(colorUnitView)
        selectedColorUnitView = colorUnitView
        let color = colorUnitView.color
        // update database
        self.resources.themeColor = color
        
        // update doneButton Apperance
        self.containerViewController?.nextButton.layoutWith(
            isEnabled: color==UIColor.placeHolderForThemeColor ? false : true,
            baseColor: color,
            accentColor: .textOnPrimaryColor,
            shouldShowShadow: false,
            borderWidth: Standards.LineWidth.SuperWide
        )
        
        // change contentOffset when selected
        let frameCenter = colorPlateScrollView.center
        let colorUnitCenter = colorUnitView.center + colorPlateScrollView.frame.origin
        colorPlateScrollView.setContentOffset(colorUnitCenter - frameCenter, animated: true)
    }
    
    
    /**
     - parameter completionHandler: should be @escaping because it'll be run at group.notify after asynchronous works.
     */
    private func generateColorUnitViews(in containerFrame: CGRect, elementSize: CGSize, completionQueue: DispatchQueue, completionHandler: @escaping (CGPoint) -> () ) {
        
        // preparation for concurrent operations
        let runQueue = DispatchQueue(label: "colorUnitPositions", qos: .default, attributes: .concurrent)
        
        let pointsPerFrame = Int( resources.requiredAmountOfColorUnits/(resources.pieces * resources.pieces) )
        let determineDistance = elementSize.width * resources.determineDistanceAdjustingCoefficient
        // first, split containerFrame into pieces
        let frames = self.splitFrame(of: containerFrame, into: resources.pieces)
        // for each frame, generate enough colorUnitViews
        frames.forEach { frame in
            runQueue.async {
                var partialPoints: [CGPoint] = []
                var count = 0
                while count < pointsPerFrame {
                    let randomX = CGFloat.random(in: frame.minX..<frame.maxX)
                    let randomY = CGFloat.random(in: frame.minY..<frame.maxY)
                    let newPoint = CGPoint(x: randomX, y: randomY)
                    
                    if newPoint.isIsolated(in: partialPoints, determineDistance: determineDistance) {
                        partialPoints.append(newPoint)
                        count += 1
                        // completion
                        completionQueue.async {
                            completionHandler(newPoint)
                        }
                    }
                }
            }
        }
    }
    
    
    /// Privately used in _func_ generateColorUnitPositions(in:elementSize:completionHandler:).
    private func splitFrame(of originFrame: CGRect, into pieces: Int) -> [CGRect] {
        let width = originFrame.width / CGFloat(pieces)
        let height = originFrame.height / CGFloat(pieces)
        
        let xs = (0..<pieces).map { (multiplier) -> CGFloat in
            return originFrame.origin.x + width * CGFloat(multiplier)
        }
        let ys = (0..<pieces).map { (multiplier) -> CGFloat in
            return originFrame.origin.y + height * CGFloat(multiplier)
        }
        
        var frames: [CGRect] = []
        for x in xs {
            for y in ys {
                let frame = CGRect(x: x, y: y, width: width, height: height)
                frames.append(frame)
            }
        }
        return frames
    }
    
    
    private func colorForPoint(_ point: CGPoint, centerPoint: CGPoint) -> UIColor {
        let hue: CGFloat = point.angle(from: centerPoint, normalizedBy: CGFloat.pi*2)
        let saturation: CGFloat = {
            let effectiveDistance = min( resources.colorContainerBounds.width, resources.colorContainerBounds.height )
            let normalizedDistance = point.distance(from: centerPoint, normalizedBy: effectiveDistance)
            return 1 - normalizedDistance
        }()
        let brightness: CGFloat = 1.0
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }
}



extension ChooseThemeColorViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        self.colorContainerView.adjustApperanceDuringScrolling(containerFrame: scrollView.frame)
//        scrollView.layoutIfNeeded()
    }
}




fileprivate extension CGPoint {
    func isIsolated(in existingPoints: [CGPoint], determineDistance: CGFloat) -> Bool {
        for existingPoint in existingPoints {
            if self.distance(from: existingPoint) <= determineDistance {
                return false
            }
        }
        return true
    }
    
    
    func surroundingRect(withSize size: CGSize) -> CGRect {
        let minX = self.x - size.width/2
        let minY = self.y - size.height/2
        return CGRect(x: minX, y: minY, width: size.width, height: size.height)
    }
}
