//
//  NewSnsidFinalConfirmViewController.swift
//  MID
//
//  Created by 江宇揚 on 2019/07/29.
//  Copyright © 2019 Jiang Yuyang. All rights reserved.
//

import UIKit
import Firebase

class NewSnsidFinalConfirmViewController: UIViewController, AddSnsidSceneController {
    
    @IBOutlet weak var tableView: UITableView!
    
    internal weak var resources: ResourcesForAddSnsidScene!
    internal weak var containerViewController: AddSnsidContainerViewController?
    
    private var textView: TextViewWithPlaceHolder!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareForViewDidLoad()
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    internal func willTransitToNextScene() {
//        self.updateDatabase()
    }
    
    
//    @IBAction func doneButtonDidTap(_ sender: Any) {
//        self.updateDatabase()
//        self.navigationController!.popToRootViewController(animated: true)
//    }
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



// MARK: - TextView Delegate

extension NewSnsidFinalConfirmViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // if textView should return, resignFirstResponder.
        guard text != "\n" else {
            textView.resignFirstResponder()
            return true
        }
        // set user inpit to textView
        resources.snsidDescription = textView.textForStorage(newChar: text)
        let textViewWithPlaceHolder = textView as! TextViewWithPlaceHolder
        textViewWithPlaceHolder.layoutAccordingTo(resources.snsidDescription)
        // update tableView
        tableView.beginUpdates()
        tableView.endUpdates()
        
        return true
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        resources.snsidDescription = textView.text ?? ""
    }
    
    
    @objc func adjustForKeyboard(when notification: Notification) {
        guard let keyboardScreenFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        // ensure bottomNavDrawer is not at front
        guard self.containerViewController?.bottomNavDrawer == nil else { return }

        switch notification.name {
        case UIResponder.keyboardWillChangeFrameNotification:
            fallthrough
        case UIResponder.keyboardWillShowNotification:
            let keyboardViewFrame = tableView.convert(keyboardScreenFrame, from: view.window)
            let textViewFrame = self.textView.convert(self.textView.frame, to: tableView)
            
            let currentTextViewLowerBound = textViewFrame.origin.y + textViewFrame.height
            let keyboardUpperBound = keyboardViewFrame.origin.y
            
            if currentTextViewLowerBound >= keyboardUpperBound {
                let adjustment = currentTextViewLowerBound - keyboardUpperBound
                tableView.contentOffset.y += adjustment
            }
        default:
            break
        }
    }
}



//MARK: - Navigations

extension NewSnsidFinalConfirmViewController {
//    private func generateOverlayBluredView() -> UIVisualEffectView {
//        // Init a blured view
//        let blurEffect = UIBlurEffect(style: .dark)
//        let bluredView = UIVisualEffectView(effect: blurEffect)
//        // Set its frame
//        bluredView.frame = UIScreen.main.bounds
//        // add gesture recognizer
//        bluredView.isUserInteractionEnabled = true
//        bluredView.addGestureRecognizer({
//            return UITapGestureRecognizer(target: self, action: #selector(bluredViewDidTap))
//        }() )
//
//        return bluredView
//    }
    
    
    @objc func nameLabelDidTap() {
        containerViewController?.showBottomNavigatinoDrawer(of: .name)
    }
    
    
    @objc func iconViewDidTap() {
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
        // Add observer for keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard(when:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard(when:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    
    private func configureCell(_ cell: UITableViewCell, cellAttributes: FinalConfirmCellAttributes) {
        switch cellAttributes.type {
        case .title:
            let titleLabel = cell.viewWithTag(11) as! UILabel
            titleLabel.textColor = UIColor.primaryColor
            
        case .icon:
            let iconView = cell.viewWithTag(11) as! ViewWithRoundedCornersAndShadowImage
            // Add tap gesture
            iconView.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(iconViewDidTap))
            iconView.addGestureRecognizer(tapGesture)
            
            // Show icon image
            iconView.layoutWith(image: resources.snsidIconImage, cornerRadius: nil, baseColor: UIColor.primaryLightColor, accentColor: UIColor.white, shouldHideShadowAtDefault: true, shouldShowCameraPatternAtDefault: true)
            
            
        case .information:
            let nameLabel = cell.viewWithTag(11) as! UILabel
            let descriptionTextView = cell.viewWithTag(12) as! TextViewWithPlaceHolder
            // Add tap gestures
            nameLabel.isUserInteractionEnabled = true
            nameLabel.addGestureRecognizer({
                return UITapGestureRecognizer(target: self, action: #selector(nameLabelDidTap))
            }() )
            // init description text view
            descriptionTextView.delegate = self
            self.textView = descriptionTextView
            
            // Show contents
            nameLabel.text = resources.newName
            descriptionTextView.placeHolder = resources.snsidDescriptionPlaceHolder
            descriptionTextView.text = resources.snsidDescription
            
        case .dummy:
            break
        }
    }
    
    
    private func updateDatabase() {
        guard let resources = self.resources,
            let name = resources.newName,
            !resources.chosenTopicTitles.isEmpty else { return }
        
        let runQueue = DispatchQueue.global()
        runQueue.async {
            let newSnsidIdentifier = "\(resources.owner.email)&&\(name)"
            let newSnsidURL = "\(Database.snsidTankReference)/\(newSnsidIdentifier)"
            let topicRefs: JSONDATA = {
                var json = JSONDATA()
                for title in resources.chosenTopicTitles {
                    json["\(title)"] = ["ref": newSnsidURL]
                }
                return json
            }()
            
            let newSnsid = SNSID(name: name,
                                 owner: resources.owner.email,
                                 ownerRef: resources.owner.ref,
                                 myPosts: nil,
                                 myReplies: nil,
                                 follows: nil,
                                 followers: nil,
                                 topics: topicRefs,
                                 myLikes: nil,
                                 focusingPosts: nil,
                                 settings: ["themeColor": resources.themeColor.toHexString()])
            
            // add newSnsid in snsidTank
            newSnsidURL.getFIRDatabaseReference.setValue(newSnsid.toJSON())
            // add new child to user
            resources.owner.ref.getFIRDatabaseReference.child("snsids").child(name).setValue(["ref": newSnsidURL])
            // add new topics
            resources.createdTopicTitles.forEach { (title) in
                Database.topicTankReference.child(title).setValue(
                    ["title": title, "adherents": ["ref": newSnsidURL]]
                )
            }
            // add adherent to existing topics
            resources.chosenTopicTitles.forEach { (title) in
                Database.topicTankReference.child(title).child("adherents").child(newSnsidIdentifier)
                    .setValue(["ref": newSnsidURL])
            }
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
            // reload icon cell
            self.tableView.reloadRows(at: [self.resources.indexOfIconCellInFinalConfirm], with: .automatic)
        })
    }
}


