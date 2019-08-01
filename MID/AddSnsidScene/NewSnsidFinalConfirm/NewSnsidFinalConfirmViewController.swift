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
        /// Init bottom navigation drawer
        let newBottomNavDrawer = BottomNavigationDrawerInNewSnsidFinalConfirm()
        // Inheritate from the previous bottomNavDrawer
        newBottomNavDrawer.completeInitWith(resources: self.resources, type: type)
        
        /// Add as self's child
        self.addChild(newBottomNavDrawer)
        self.view.addSubview(newBottomNavDrawer.view)
        newBottomNavDrawer.didMove(toParent: self)
        /// Adjust BND's position and size
        newBottomNavDrawer.view.frame = { [unowned self] in
            let height = self.view.frame.height
            let width = self.view.frame.width
            let yOrigin: CGFloat = self.view.frame.maxY
            return CGRect(x: 0, y: yOrigin, width: width, height: height)
        }()
        // set it to self's reference
        self.bottomNavDrawer = newBottomNavDrawer
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
}



//MARK: - Custom Helper Functions

extension NewSnsidFinalConfirmViewController {
    private func prepareForViewDidLoad() {
        tableView.allowsSelection = false
    }
    
    
    private func prepareForViewWillLoad() {
        
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


