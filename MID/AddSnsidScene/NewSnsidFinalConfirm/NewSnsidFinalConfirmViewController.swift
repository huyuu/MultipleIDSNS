//
//  NewSnsidFinalConfirmViewController.swift
//  MID
//
//  Created by 江宇揚 on 2019/07/29.
//  Copyright © 2019 Jiang Yuyang. All rights reserved.
//

import UIKit

class NewSnsidFinalConfirmViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    internal var resources: ResourcesForAddSnsidScene!
    private var bottomNavDrawer: BottomNavigationDrawerInNewSnsidFinalConfirm? = nil
    private var overlayBluredView: UIVisualEffectView? = nil
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareForViewDidLoad()
    }
}



// MARK: - TableView Delegate

extension NewSnsidFinalConfirmViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resources.finalConfirmCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellAttributes = resources.finalConfirmCells[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellAttributes.reuseId)!
        
        self.configureCell(cell, cellAttributes: cellAttributes)
        return cell
    }
}



//MARK: - Navigations

extension NewSnsidFinalConfirmViewController {
    private func showBottomNavigatinoDrawer(of type: BottomNavigationDrawerAttributesType) {
        // display blured view
        self.overlayBluredView = self.generateOverlayBluredView()
        UIView.animate(withDuration: Standards.UIMotionDuration.quiteFast) { [self] in
            self.view.addSubview(self.overlayBluredView!)
            // hide navigation bar
            self.navigationController?.navigationBar.isHidden = true
        }
        
        /// Init bottom navigation drawer
        let newBottomNavDrawer = BottomNavigationDrawerInNewSnsidFinalConfirm(resources: self.resources, type: .name, origin: CGPoint(x: 0, y: self.view.frame.maxY), size: self.view.frame.size)
        /// Add as self's child. Note that we'll handle animations of bottomNavDrawer in its own class.
        self.addChild(newBottomNavDrawer)
        self.view.addSubview(newBottomNavDrawer.view)
        newBottomNavDrawer.didMove(toParent: self)
        
        // set it to self's reference
        self.bottomNavDrawer = newBottomNavDrawer
    }

    
    internal func dismissBottomNavigationDrawer() {
        // remove blured view from view hierarchy
        self.overlayBluredView?.removeFromSuperview()
        self.overlayBluredView = nil
        // dismiss bottomNavDrawer
        self.bottomNavDrawer?.standardDismiss(completion: {
            // remove bottomNavDrawer from view hierarchy
            self.bottomNavDrawer?.view.removeFromSuperview()
            self.bottomNavDrawer?.removeFromParent()
            self.bottomNavDrawer = nil
        })
    }
    
    
    private func generateOverlayBluredView() -> UIVisualEffectView {
        // Init a blured view
        let blurEffect = UIBlurEffect(style: .dark)
        let bluredView = UIVisualEffectView(effect: blurEffect)
        // Set its frame
        bluredView.frame = UIScreen.main.bounds
        // add gesture recognizer
        bluredView.isUserInteractionEnabled = true
        bluredView.addGestureRecognizer({
            return UITapGestureRecognizer(target: self, action: #selector(bluredViewDidTap))
        }() )
        
        return bluredView
    }
    
    
    @objc func nameLabelDidTap() {
        showBottomNavigatinoDrawer(of: .name)
    }
    
    
    @objc func descriptionLabelDidTap() {
        showBottomNavigatinoDrawer(of: .description)
    }
    
    
    @objc func iconImageDidTap() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
        
        let photoPicker = UIImagePickerController()
        photoPicker.sourceType = .photoLibrary
        photoPicker.delegate = self
        self.present(photoPicker, animated: true, completion: nil)
    }
    
    
    @objc func bluredViewDidTap() {
        self.dismissBottomNavigationDrawer()
    }
}



//MARK: - Custom Helper Functions

extension NewSnsidFinalConfirmViewController {
    private func prepareForViewDidLoad() {
        tableView.allowsSelection = false
    }

    
    private func configureCell(_ cell: UITableViewCell, cellAttributes: FinalConfirmCellAttributes) {
        switch cellAttributes.type {
        case .title:
            let titleLabel = cell.viewWithTag(11) as! UILabel
            
        case .icon:
            let iconImageView = cell.viewWithTag(11) as! UIImageView
            // Add tap gesture
            iconImageView.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(iconImageDidTap))
            iconImageView.addGestureRecognizer(tapGesture)
            
            // Show icon image
            iconImageView.image = resources.snsidIconImage
            
        case .information:
            let nameLabel = cell.viewWithTag(11) as! UILabel
            let descriptionLabel = cell.viewWithTag(12) as! UILabel
            // Add tap gestures
            nameLabel.isUserInteractionEnabled = true
            nameLabel.addGestureRecognizer({
                return UITapGestureRecognizer(target: self, action: #selector(nameLabelDidTap))
            }() )
            descriptionLabel.isUserInteractionEnabled = true
            descriptionLabel.addGestureRecognizer({
                return UITapGestureRecognizer(target: self, action: #selector(descriptionLabelDidTap))
            }() )
            // Show contents
            nameLabel.text = resources.newName
            descriptionLabel.text = resources.snsidDescription
        }
    }
}



// MARK: - UIImagePicker Delegate

extension NewSnsidFinalConfirmViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // save pickedImage to resources
        if let pickedImage = info[.originalImage] as? UIImage {
            resources.snsidIconImage = pickedImage
        }
        picker.dismiss(animated: true, completion: { [unowned self] in
            self.tableView.reloadData()
        })
    }
}


