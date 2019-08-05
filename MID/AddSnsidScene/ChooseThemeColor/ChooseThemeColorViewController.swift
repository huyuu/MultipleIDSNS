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
    @IBOutlet weak var colorPlateScrollView: ColorPlateScrollView!
    @IBOutlet weak var colorContainerView: ColorContainerView!
    
    internal weak var resources: ResourcesForAddSnsidScene!
    internal weak var containerViewController: AddSnsidContainerViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareForViewDidLoad()
    }
    
    
    
    // MARK: - Navigations
    
    internal func willTransitToNextScene() {
    }
}



// MARK: Custom Helper Functions

extension ChooseThemeColorViewController {
    private func prepareForViewDidLoad() {
        // set titleLabel's textColor
        titleLabel.textColor = UIColor.primaryColor
        // set color plate scroll view
        colorPlateScrollView.delegate = self
        colorPlateScrollView.contentSize = colorContainerView.frame.size
        colorPlateScrollView.contentOffset =
            CGPoint(x: colorContainerView.frame.width/2 - colorPlateScrollView.frame.width/2,
                    y: colorContainerView.frame.height/2 - colorPlateScrollView.frame.height/2)
        colorPlateScrollView.decelerationRate = .fast
        // set contentView
        colorContainerView.completeInit(delegate: self)
        // if a themeColor is chosen, set to true
        self.containerViewController?.nextButton.isEnabled = resources.themeColor == UIColor.placeHolderForThemeColor ? false : true
    }
    
    
    internal func didSelectColor(_ colorUnitButton: ColorUnitButton) {
        let color = colorUnitButton.fillColor
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
        // update colorUnitButton Appearance
        if let index = resources.previouslyChoosenButtonIndex {
            colorContainerView.colorButtons[index].isSelected = false
        }
        colorUnitButton.isSelected = !(colorUnitButton.isSelected)
        resources.previouslyChoosenButtonIndex = colorUnitButton.index
        // change contentOffset when selected
        let frameCenter = colorPlateScrollView.center
        let buttonCenter = colorUnitButton.center + colorPlateScrollView.frame.origin
        colorPlateScrollView.setContentOffset(buttonCenter - frameCenter, animated: true)
    }
}



extension ChooseThemeColorViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        self.colorContainerView.adjustApperanceDuringScrolling(containerFrame: scrollView.frame)
//        scrollView.layoutIfNeeded()
    }
}
