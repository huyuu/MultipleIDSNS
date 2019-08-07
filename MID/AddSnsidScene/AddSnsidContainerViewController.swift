//
//  AddSnsidContainerViewController.swift
//  MID
//
//  Created by 江宇揚 on 2019/08/04.
//  Copyright © 2019 Jiang Yuyang. All rights reserved.
//

import UIKit

@IBDesignable
class AddSnsidContainerViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextButton: RoundedNextButton!
    @IBOutlet weak var toolBar: UIToolbar!
    
    
    // MARK: - Instances
    
    internal var resources: ResourcesForAddSnsidScene!
    
    private var pageViewController: AddSnsidPageViewController!
    private var displayableViewControllers: [UIViewController]! = []
    private var currentPageIndex = 0 {
        didSet {
            pageControl.currentPage = currentPageIndex
        }
    }
    /// A internal label makes sure that it can be seen from finalConfirm VC.
    internal var bottomNavDrawer: BottomNavigationDrawerViewController?
    private var tapGestureOnBluredView: UITapGestureRecognizer?
    
    
    
    // MARK: - View Actions

    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareForViewDidLoad()
    }
    
    
    deinit {
        // make sure to remove all observers
        resources.topicTankRef.removeAllObservers()
    }
    
    
    // MARK: - Navigation
    
    private func pageIndexAfter(_ currentPageIndex: Int) -> Int? {
        return currentPageIndex == displayableViewControllers.count-1 ? nil : currentPageIndex+1
    }
    
    
    private func pageIndexBefore(_ currentPageIndex: Int) -> Int? {
        return currentPageIndex == 0 ? nil : currentPageIndex-1
    }
    
    
    @IBAction func nextButtonDidTap(_ sender: Any) {
        let currentController = displayableViewControllers[currentPageIndex] as! AddSnsidSceneController
        // conduct willTransitToNextScene()
        currentController.willTransitToNextScene()
        // remove currentController's power of controll.
        currentController.containerViewController = nil
        
        // ensure it's not the last page
        guard let nextPageIndex = pageIndexAfter(currentPageIndex) else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        // give nextController controll power
        let nextController = displayableViewControllers[nextPageIndex] as! AddSnsidSceneController
        // set nextController's containerViewController to self before it appears. In this way, the nextController can prepare custom resources in viewWillAppear().
        nextController.containerViewController = self
        pageViewController.setViewControllers([nextController], direction: .forward, animated: true, completion: nil)
        
        // add 1 to currentPageIndex
        currentPageIndex += 1
    }
    
    
    @objc func backButtonDidTap() {
        let currentController = displayableViewControllers[currentPageIndex] as! AddSnsidSceneController
        currentController.containerViewController = nil
        
        guard let previousPageIndex = pageIndexBefore(currentPageIndex) else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        // give previousController controll power
        let previousController = displayableViewControllers[previousPageIndex] as! AddSnsidSceneController
        previousController.containerViewController = self
        pageViewController.setViewControllers([previousController], direction: .reverse, animated: true, completion: nil)

        // substitute 1 to currentPageIndex
        currentPageIndex -= 1
    }
    
    
    internal func showBottomNavigatinoDrawer(of type: BottomNavigationDrawerAttributesType) {
        UIView.animate(withDuration: Standards.UIMotionDuration.superFast,
           animations: { [unowned self] in
                // set underViews to be black
                self.pageViewController.viewControllers!.forEach({ viewController in
                    viewController.view.alpha = 0.2
                })
                // set unerToolBar to be hidden
                self.toolBar.isHidden = true
            }, completion: { [unowned self] _ in
                // add gesture recognizer to backgroundView after its shown.
                self.tapGestureOnBluredView = UITapGestureRecognizer(target: self, action: #selector(self.dismissBottomNavigationDrawer))
                let finalConfirmVC = self.pageViewController.viewControllers!.first!
                finalConfirmVC.view.addGestureRecognizer(self.tapGestureOnBluredView!)
        })
        
        /// Init bottom navigation drawer
        let newBottomNavDrawer = BottomNavigationDrawerInNewSnsidFinalConfirm(resources: self.resources, type: .name, origin: CGPoint(x: 0, y: self.view.frame.maxY), size: self.view.frame.size)
        /// Add as self's child. Note that we'll handle animations of bottomNavDrawer in its own class.
        self.addChild(newBottomNavDrawer)
        self.view.addSubview(newBottomNavDrawer.view)
        newBottomNavDrawer.didMove(toParent: self)
        // set it to private var
        self.bottomNavDrawer = newBottomNavDrawer
    }
    
    
    @objc internal func dismissBottomNavigationDrawer() {
        // remove gesture recognizer
        let finalConfirmVC = pageViewController.viewControllers!.first!
        finalConfirmVC.view.removeGestureRecognizer(self.tapGestureOnBluredView!)
        
        UIView.animate(withDuration: Standards.UIMotionDuration.superFast,
           animations: { [unowned self] in
                // set views to be normal alpha
                self.pageViewController.viewControllers!.forEach({ viewController in
                    viewController.view.alpha = 1
                })
                // show uner toolbar
                self.toolBar.isHidden = false
        })

        // dismiss bottomNavDrawer
        self.bottomNavDrawer!.standardDismiss(completion: { [unowned self] in
            // reload name label
            self.pageViewController.viewControllers!.forEach({ viewController in
                (viewController as? NewSnsidFinalConfirmViewController)?.tableView.reloadRows(at: [self.resources.indexOfNameCellInFinalConfirm], with: .automatic)
            })
            // remove bottomNavDrawer from view hierarchy
            self.bottomNavDrawer?.view.removeFromSuperview()
            self.bottomNavDrawer?.removeFromParent()
            self.bottomNavDrawer = nil
        })
    }
}



// MARK: - UIPageViewController Delegate

extension AddSnsidContainerViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = displayableViewControllers.firstIndex(of: viewController)!
        return index == 0 ? nil : displayableViewControllers[index-1]
    }


    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = displayableViewControllers.firstIndex(of: viewController)!
        return index == displayableViewControllers.count-1 ? nil : displayableViewControllers[index+1]
    }
}



// MARK: - Custom Helper Functions

extension AddSnsidContainerViewController {
    private func prepareForViewDidLoad() {
        // generate pageViewController
        pageViewController = (children.first! as! AddSnsidPageViewController)
//        pageViewController.dataSource = self
        // set displayableViews
        let newNameVC = self.initAddSnsidSceneController(withIdentifier: "\(NewNameViewController.self)")
        let searchTopicVC = self.initAddSnsidSceneController(withIdentifier: "\(SearchTopicViewController.self)")
        let chooseThemeColorVC = self.initAddSnsidSceneController(withIdentifier: "\(ChooseThemeColorViewController.self)")
        let finalConfirmVC = self.initAddSnsidSceneController(withIdentifier: "\(NewSnsidFinalConfirmViewController.self)")
        displayableViewControllers.append(contentsOf: [newNameVC, searchTopicVC, chooseThemeColorVC, finalConfirmVC])
        
        // set NewName Scene to be the first viewController
        currentPageIndex = 0
        let initialViewController = displayableViewControllers[currentPageIndex] as! AddSnsidSceneController
        pageViewController.setViewControllers([initialViewController], direction: .forward, animated: true, completion: { [unowned self] _ in
            // set its containerViewController
            initialViewController.containerViewController = self
        })
        
        // set nextButton initial state
        nextButton.layoutWith(isEnabled: false, baseColor: .secondaryColor, accentColor: .textOnSecondaryColor, shouldShowShadow: false, borderWidth: Standards.LineWidth.SuperWide)
        
        // set toolbar initial state
        toolBar.barTintColor = UIColor.primaryDarkColor
        let cancelItem: UIBarButtonItem = {
            let arrowView = ArrowView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            // set layout
            arrowView.layoutWith(accentColor: .primaryLightColor, direction: .left)
            // set actions for arrowView
            arrowView.isUserInteractionEnabled = true
            arrowView.addGestureRecognizer({
                return UITapGestureRecognizer(target: self, action: #selector(backButtonDidTap))
            }() )
            return UIBarButtonItem(customView: arrowView)
        }()
        let dummyItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelItem, dummyItem, dummyItem], animated: false)
        toolBar.setNeedsDisplay()
        
        // set page control initial state
        pageControl.isUserInteractionEnabled = false
        pageControl.numberOfPages = displayableViewControllers.count
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .primaryDarkColor
    }
    
    
    private func initAddSnsidSceneController(withIdentifier id: String) -> AddSnsidSceneController {
        let viewController = storyboard!.instantiateViewController(withIdentifier: id) as! AddSnsidSceneController
        viewController.resources = self.resources
        return viewController
    }
}



protocol AddSnsidSceneController: UIViewController {
    var containerViewController: AddSnsidContainerViewController? { get set }
    var resources: ResourcesForAddSnsidScene! { get set }
    func willTransitToNextScene()
}
