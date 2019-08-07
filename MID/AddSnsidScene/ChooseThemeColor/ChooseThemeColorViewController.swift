//
//  ChooseThemeColorViewController.swift
//  MID
//
//  Created by 江宇揚 on 2019/06/08.
//  Copyright © 2019 Jiang Yuyang. All rights reserved.
//

import UIKit

/**
 An AddSnsidSceneController.
 
 When embedded in a container view, child view controllers may be preloaded before they are presented, but the sub views including IBOutlets won't be initiated until the specific view controller reaches viewWillAppear state.
*/
@IBDesignable class ChooseThemeColorViewController: UIViewController, AddSnsidSceneController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var colorPlateScrollView: ColorPlateScrollView!{
        didSet {
            // When views in current view controller are all set (probably at viewWillAppear), conduct self.prepareWhenColorPlateIsReady()
            if let _ = colorContainerView {
                self.prepareWhenColorPlateIsReady()
            }
        }
    }
    @IBOutlet weak var colorContainerView: ColorContainerView!
    
    
    // MARK: - Instances
    
    internal weak var resources: ResourcesForAddSnsidScene! {
        didSet {
            // When views in current view controller are all set (probably at viewDidLoad of AddSnsidContainerViewController), conduct self.prepareWhenResourcesAreReady()
            if let _ = resources {
                self.prepareWhenResourcesAreReady()
            }
        }
    }
    // needed for AddSnsidSceneController protocol
    internal weak var containerViewController: AddSnsidContainerViewController?
    /**
     A container of colorUnitViews aimed to store the result of asynchronouly generated colorUnitViews in self.generateColorUnitPositions().
     Note that this property will be only set once when resources are set, and then will be set to nil and can never be refer to.
    */
    private var colorUnitViews: [ColorUnitView]? = []
    /// For storage of current selected ColorUnit. Will be set to nil if no ColorUnit if currently on selection.
    private var selectedColorUnitView: ColorUnitView? = nil
    
    
    
    // MARK: - Required View Actions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareForViewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.prepareForViewWillAppear()
    }
    
    
    
    // MARK: - Navigations
    
    internal func willTransitToNextScene() {
        
    }
}



// MARK: Custom Helper Functions

extension ChooseThemeColorViewController {
    
    // MARK: - Custom View Actions
    
    private func prepareForViewDidLoad() {

    }
    
    
    /**
     After resources are set at ContainerView-Loading stage, ChooseThemeColorViewController pre-generates positions for color units.
     When every position is located, a newPoint: CGPoint is past to the completion handler from which a new ColorUnitView instance is generated accordingly.
    */
    private func prepareWhenResourcesAreReady() {
        self.generateColorUnitPositions(in: resources.colorContainerBounds, elementSize: resources.colorUnitViewSize, completionQueue: DispatchQueue.main, completionHandler: { [unowned self] newPoint in
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
            /**
             Update database. There are 2 condition needed to be considerated.
             - colorUnitViews exists, colorContainerView is nil: this is the first state right after resources is set. Here, we store the newColorUnitView to colorUnitViews.
             - colorUnitViews is nil, colorContainerView exists: this is the normal state after colorContainerView is initiated. Here, we store the newColorUnitView to colorContainerView.
            */
            self.colorUnitViews?.append(newColorUnitView)
            self.colorContainerView?.addSubview(newColorUnitView)
        })
    }
    
    
    /// only been conducted once before viewWillAppear.
    private func prepareWhenColorPlateIsReady() {
        // set color plate scroll view
        colorPlateScrollView.delegate = self
        colorPlateScrollView.contentSize = colorContainerView.frame.size
        colorPlateScrollView.contentOffset = {
            let scrollViewCenter = CGPoint(x: colorPlateScrollView.bounds.width/2, y: colorPlateScrollView.bounds.height/2)
            let contentViewCenter = colorContainerView.center
            return contentViewCenter - scrollViewCenter
        }()
        colorPlateScrollView.decelerationRate = .fast
        
        // If colorUnitViews exists, add colorUnitView from it and delete it afterwards. From now on, [colorUnitView] can only be refered to through colorContainerView.
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
        self.updateNextButtonState(isReady: resources.themeColor != nil)
//        self.containerViewController?.nextButton.isEnabled = resources.themeColor == UIColor.placeHolderForThemeColor ? false : true
    }
    
    
    /**
     a colorUnitView is touched up.
     
     when a colorUnitView is selected:
     * if the color is already in selected state, reset it.
     * otherwise, set newColorUnitView to be selected state, update
    */
    @objc func didSelectColor(_ colorUnitView: ColorUnitView) {
        // if the color is already selected, reset it to default state
        guard colorUnitView.isColorSelected != true else {
            // update colorUnitButton Appearance
            colorUnitView.layoutWith(isSelected: false)
            colorContainerView.sendSubviewToBack(colorUnitView)
            // set selectedColorUnitView to nil
            self.selectedColorUnitView = nil
            // update database and nextButtonState
            resources.themeColor = nil
            self.updateNextButtonState(isReady: false)
            return
        }
        
        // if color is newly selected, set previous selected to be unselected state.
        selectedColorUnitView?.layoutWith(isSelected: false)
        // newly selected unit set to selected
        colorUnitView.layoutWith(isSelected: true)
        colorContainerView.bringSubviewToFront(colorUnitView)
        // set it to storage
        self.selectedColorUnitView = colorUnitView
        // extract the selected color
        let color = colorUnitView.color
        // update database and nextButton state.
        resources.themeColor = color
        self.updateNextButtonState(isReady: true)
//        self.containerViewController?.nextButton.layoutWith(
//            isEnabled: color==UIColor.placeHolderForThemeColor ? false : true,
//            baseColor: color,
//            accentColor: .textOnPrimaryColor,
//            shouldShowShadow: false,
//            borderWidth: Standards.LineWidth.SuperWide
//        )
        // change contentOffset when selected
        let frameCenter = colorPlateScrollView.center
        let colorUnitCenter = colorUnitView.center + colorPlateScrollView.frame.origin
        colorPlateScrollView.setContentOffset(colorUnitCenter - frameCenter, animated: true)
    }
    
    
    internal func updateNextButtonState(isReady: Bool) {
        if isReady {
            self.containerViewController?.nextButton.layoutWith(isEnabled: true, baseColor: resources.themeColor!, accentColor: .textOnPrimaryColor, shouldShowShadow: false, borderWidth: Standards.LineWidth.SuperWide)
        } else {
            self.containerViewController?.nextButton.layoutWith(isEnabled: false, baseColor: .lightGray, accentColor: .textOnPrimaryColor, shouldShowShadow: false, borderWidth: Standards.LineWidth.SuperWide)
        }
    }
    
    
    
    // MARK: - Color Generating Functions.
    
    /**
     - parameter completionHandler: should be @escaping because it'll be run at group.notify after asynchronous works.
     */
    private func generateColorUnitPositions(in containerFrame: CGRect, elementSize: CGSize, completionQueue: DispatchQueue, completionHandler: @escaping (CGPoint) -> () ) {
        
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



// MARK: - ScrollView Delegate

extension ChooseThemeColorViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        self.colorContainerView.adjustApperanceDuringScrolling(containerFrame: scrollView.frame)
//        scrollView.layoutIfNeeded()
    }
}



// MARK: - Fileprivate CGPoint Extension

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
