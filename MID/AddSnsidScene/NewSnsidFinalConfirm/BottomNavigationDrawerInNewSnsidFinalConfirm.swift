//
//  BottomNavigationDrawerForChangingName.swift
//  MID
//
//  Created by 江宇揚 on 2019/07/29.
//  Copyright © 2019 Jiang Yuyang. All rights reserved.
//

import UIKit


/// Mimic from [here](https://stackoverflow.com/questions/37967555/how-can-i-mimic-the-bottom-sheet-from-the-maps-app).
@IBDesignable class BottomNavigationDrawerInNewSnsidFinalConfirm: BottomNavigationDrawerViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var upDownIndicatorButton: UpDownArrowButton!
    
    
    // MARK: - Instances
    
    internal var resources: ResourcesForAddSnsidScene!
    internal var type: BottomNavigationDrawerAttributesType? = nil
    
    override var expansionState: BottomNavigationDrawerViewController.ExpansionState {
        didSet {
            // detect arrow direction
            let arrowDirection: CAShapeLayer.NextPatternDirection = {
                switch expansionState {
                case .closed:
                    return .up
                case .full:
                    return .down
                case .partial:
                    return .level
                case .invisible:
                    return .up
                }
            }()
            // present it on upDownIndicatorButton whenever expansionState changed
            upDownIndicatorButton.layoutAccordingTo(direction: arrowDirection)
        }
    }
    
    
    
    // MARK: - View Actions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareForViewDidLoad()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)        
        self.tableView.reloadData()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.animateToInitialPosition()
        // set expandsion state to closed.
        self.expansionState = .full
    }
    
    
    
    // MARK: - Inits
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented in \(BottomNavigationDrawerInNewSnsidFinalConfirm.self).")
    }
    
    
    internal init(resources: ResourcesForAddSnsidScene, type: BottomNavigationDrawerAttributesType, origin: CGPoint, size: CGSize) {
        super.init(nibName: nil, bundle: nil)
        self.resources = resources
        self.type = type
        self.view.frame = CGRect(origin: origin, size: size)
    }
}



// MARK: - TableView Delegate

extension BottomNavigationDrawerInNewSnsidFinalConfirm: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let type = self.type else { return 0 }
        
        let cellAttributes = BottomNavigationDrawerAttributes(of: type)
        return cellAttributes.cellAmount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellAttributes = BottomNavigationDrawerAttributes(of: self.type!)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellAttributes.reuseId)!
        
        self.configureCell(cell, cellAttributes: cellAttributes)
        
        return cell
    }
}



// MARK: - TextField Delegate

extension BottomNavigationDrawerInNewSnsidFinalConfirm: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        resources.userInputForNewName = textField.textForStorage(newChar: string)
        let textFieldWithIndicator = textField as! TextFieldWithIndicationBorder
        textFieldWithIndicator.layoutAccodingTo(resources.isNameAvailable)

        return true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        resources.newName = textField.text ?? ""
    }
}



// MARK: - Gesture Delegate

extension BottomNavigationDrawerInNewSnsidFinalConfirm: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // We solve for PanGesture only.
        if let gesture = gestureRecognizer as? UIPanGestureRecognizer {
            let yOrigin = view.frame.minY
            
            let isBottomNavDrawerClosed = yOrigin == resources.closedHeight
            /**
             Bool to indicate whether the bottom navigation drawer is shrinking by user scroll.
             We make it a closure which will only be conducted when the bottom navigation drawer is *NOT* at closed position.
            */
            let isBottomNavDrawerShrinking = { [unowned self] () -> Bool in
                let didTableViewContentsReachTop = self.tableView.contentOffset.y == 0
                let isScrollingDown: Bool = { [unowned self] in
                    let velocityOfYComponent = gesture.velocity(in: self.view).y
                    return velocityOfYComponent > 0
                }()
                
                return didTableViewContentsReachTop && isScrollingDown
            }
            // If BottomNavDrawer is not at closed position or shrinking by user scroll, enable the scrolling of the table view embedded in.
            if isBottomNavDrawerClosed || isBottomNavDrawerShrinking() {
                tableView.isScrollEnabled = false
            } else {
                tableView.isScrollEnabled = true
            }
        }
        
        // Should always returns false to avoid plural gesture be recognized simultaneously.
        return false
    }
}



// MARK: - Custom Helper Functions

extension BottomNavigationDrawerInNewSnsidFinalConfirm {
    private func prepareForViewDidLoad() {
        // register nib for Changing Name
        let nibForChangingName = UINib(nibName: "ChangingNameTableViewCellInBottomNavigationDrawer", bundle: nil)
        tableView.register(nibForChangingName, forCellReuseIdentifier: "changingNameCellForBottomNavigationDrawerOfNewSnsidFinalConfirm")
        // set tableView delegate
        tableView.delegate = self
        tableView.dataSource = self
        // add panGesture to view
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(scrollUpToCoverParentView(recognizer:)))
        panGesture.delegate = self
        view.addGestureRecognizer(panGesture)
        
        // change background color of header view
        headerView.backgroundColor = UIColor.white
        // set stroke color for upDownIndicatorButton
        upDownIndicatorButton.completeInitWith(strokeColor: UIColor.primaryDarkColor)
        
        // set rounded corners to whole view
        self.view.layer.cornerRadius = Standards.CornerRadius.fullScreenView
        self.view.layer.shadowOpacity = 0.4
        self.view.layer.masksToBounds = false
    }
    
    
    private func animateToInitialPosition() {
        UIView.animate(withDuration: Standards.UIMotionDuration.fast, animations: { [unowned self] in
            // Change y origin to initial position
            let newYOrigin = self.resources.fullyExpandedHeight
            self.view.frame = CGRect(x: 0, y: newYOrigin, width: self.view.frame.width, height: self.view.frame.height)
        })
    }
    
    
    @objc func scrollUpToCoverParentView(recognizer: UIPanGestureRecognizer) {
        
        // Calculate final position

        let finalYOriginPosition: CGFloat = { [unowned self] in
            let translation = recognizer.translation(in: self.view)
            let currentYOrigin = self.view.frame.minY
            return currentYOrigin + translation.y
        }()
        // Bools for checking whether the final position is between closed and fully-expanded state.
        let isFinalYOriginAboveClosedPosition = finalYOriginPosition < resources.closedHeight
        let isFinalYOriginBelowFullyExpandedPosition = finalYOriginPosition > resources.fullyExpandedHeight
        // If the final yOrigin position is between closed and fully epanded position, mark the view as expandable and respond to pan gestures.
        if isFinalYOriginAboveClosedPosition && isFinalYOriginBelowFullyExpandedPosition {
            // scroll BottomNavDrawer
            view.frame = CGRect(x: 0, y: finalYOriginPosition, width: view.frame.width, height: view.frame.height)
        }
        
        
        // Animate BottomNavDrawer
        
        if case .ended = recognizer.state {
            
            let yVelocity = recognizer.velocity(in: self.view).y
            let expectedDuration = UIView.calculateDurationGivenYInfos(bottomPosition: resources.closedHeight, topPosition: resources.fullyExpandedHeight, currentPosition: self.view.frame.minY, velocity: yVelocity)
            let isClosing = yVelocity > 0
            let isExpanding = yVelocity < 0
            
            if isExpanding {
                UIView.animate(withDuration: min(expectedDuration, Standards.UIMotionDuration.superFast), delay: 0.0, options: [.allowUserInteraction],
                               animations: { [self] in
                                self.view.frame = CGRect(x: 0, y: self.resources.fullyExpandedHeight, width: self.view.frame.width, height: self.view.frame.height)
                                
                    }, completion: { [unowned self] _ in
                        self.expansionState = .full
                        self.tableView.isScrollEnabled = true
                })
            } else if isClosing {
                let parentViewController = self.parent as! AddSnsidContainerViewController
                parentViewController.dismissBottomNavigationDrawer()
            }
        }
        
        // reset recognizer to zero
        recognizer.setTranslation(.zero, in: view)
    }
    
    
    private func configureCell(_ cell: UITableViewCell, cellAttributes: BottomNavigationDrawerAttributes) {
        switch cellAttributes.type {
        case .name:
            let changingNameCell = cell as! ChangingNameTableViewCellInBottomNavigationDrawer
            
            changingNameCell.nameTextField.delegate = self
            changingNameCell.nameTextField.text = resources.newName
        }
    }
}
