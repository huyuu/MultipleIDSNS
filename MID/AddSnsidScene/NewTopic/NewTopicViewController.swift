//
//  NewTopicViewController.swift
//  MID
//
//  Created by 江宇揚 on 2019/06/23.
//  Copyright © 2019 Jiang Yuyang. All rights reserved.
//

import UIKit

@IBDesignable
class NewTopicViewController: UIViewController {
    
    @IBOutlet weak var doneButton: RoundedNextButton!
    @IBOutlet weak var tableView: UITableView!
    private var textView: TextViewWithPlaceHolder!
    
    internal var resources: ResourcesForAddSnsidScene!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareForViewDidLoad()
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    // MARK: - Navigation
    
    /// Add new topic scene completed -> back to choose topics.
    @IBAction func doneButtonTabbed(_ sender: Any) {
        // add topic to resources
        var chosenTitles = resources.chosenTopicTitles
        chosenTitles.append(resources.newTopicTitle!)
        resources.chosenTopicsCell = [ SearchTopicCellAttributes(of: .chosenTopics(chosenTitles)) ]
        // add new topic to container
        resources.createdTopicTitles.append(resources.newTopicTitle!)
        // clear user input
        resources.userInputForSearchTopic = ""
        self.dismiss(animated: true, completion: nil)
    }
}



// MARK: - UITableView Delegate Extension

extension NewTopicViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resources.newTopicCells.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: resources.newTopicCells[indexPath.row].reuseId)!
        self.configure(cell, indexPath: indexPath)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}



// MARK: - UITextViewDelegate

extension NewTopicViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // if textView should return, resignFirstResponder.
        guard text != "\n" else {
            textView.resignFirstResponder()
            return true
        }
        
        
        resources.userInputForNewTopicDescription = textView.textForStorage(newChar: text)
        let textViewWithPlaceHolder = textView as! TextViewWithPlaceHolder
        textViewWithPlaceHolder.layoutAccordingTo(resources.userInputForNewTopicDescription)
        
        /**
         Their seems to be a bug that update tableView will automatically cause contentOffset set to zero. After try and errors, this seems to happen only when the tableView is scrolled down enough for the system to think that the current contentOffset can't be a proper value.
         
         To fixed it, simplely create a dummy cell with height long enough for your contentOffset.
         For details, see here [https://stackoverflow.com/questions/33789807/uitableview-jumps-up-after-begin-endupdates-when-using-uitableviewautomaticdimen]
        */
        
        tableView.beginUpdates()
        tableView.endUpdates()

        
        return true
    }
    
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        // set text to newTopicDescription anyway
        resources.newTopicDescription = textView.text ?? ""
        textView.resignFirstResponder()
        return true
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        resources.shouldScrollToCombinationCell = true
        self.refresh()
    }
}



// MARK: - Custom Helper Functions

extension NewTopicViewController {
    private func prepareForViewDidLoad() {
        // set doneButton inital style
        doneButton.isEnabled = false
        self.updateDoneButtonState()
        // add observer for keybord adjustment
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeybord(when:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeybord(when:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeybord(when:)), name: UIResponder.keyboardDidHideNotification, object: nil)
        // set tableView to be  unselectable
        tableView.allowsSelection = false
    }
    
    
    private func configure(_ cell: UITableViewCell, indexPath: IndexPath) {
        switch resources.newTopicCells[indexPath.row].type {
        case .title:
            let titleLabel = cell.viewWithTag(11) as! CornerRoundedLabel
            
            titleLabel.text = resources.newTopicTitle ?? ""
            titleLabel.layoutAccordingTo(isContentAcceptable: true, fillColor: .textOnPrimaryColor, strokeColor: .primaryColor)
            
            
        case .icon:
            let iconImageView = cell.viewWithTag(11) as! UIImageView
            let addIconButton = cell.viewWithTag(12) as! CameraButton
            
            // set image view
            self.customizeImageView(iconImageView, icon: resources.newTopicIcon)
            // if icon exists
            if let _ = resources.newTopicIcon {
                addIconButton.layoutWith(fillColor: .clear, strokeColor: .clear)
            } else {
                // set addIconButton layout attributes
                addIconButton.layoutWith(fillColor: .textOnPrimaryColor, strokeColor: .primaryLightColor)
            }
            // add target for taking photos
            addIconButton.addTarget(self, action: #selector(startPickIconImage(_:)), for: .touchUpInside)
            
            
        case .description:
            let descriptionTextView = cell.viewWithTag(11) as! TextViewWithPlaceHolder
            
            descriptionTextView.delegate = self
            descriptionTextView.placeHolder = "Enter description for new topic..."
            // check if description textView should become firstResponder (often after icon has been chosen.)
            if resources.descriptionTextViewShouldBecomeFirstResponder {
                descriptionTextView.becomeFirstResponder()
                resources.descriptionTextViewShouldBecomeFirstResponder = false
            }
            self.textView = descriptionTextView
            
            
        case .dummy:
            break
            
            
        case .combination:
            let combinationImageView = cell.viewWithTag(11) as! UIImageView
            let titleLabel = cell.viewWithTag(12) as! CornerRoundedLabel
            let descriptionLabel = cell.viewWithTag(13) as! UILabel
            
            // set imageView
            self.customizeImageView(combinationImageView, icon: resources.newTopicIcon)
            // set title Label
            titleLabel.text = resources.newTopicTitle!
            titleLabel.layoutAccordingTo(isContentAcceptable: true, fillColor: .secondaryColor, strokeColor: .textOnSecondaryColor)
            // set description Label
            let userInput = resources.userInputForNewTopicDescription
            descriptionLabel.text = userInput.isEmpty ? "placeHolder" : userInput
        }
    }
    
    
    private func updateDoneButtonState() {
        doneButton.layoutWith(isEnabled: resources.isCreatingNewTopicDone)
        if resources.isCreatingNewTopicDone {
            self.view.bringSubviewToFront(doneButton)
        } else {
            self.view.sendSubviewToBack(doneButton)
        }
    }
    
    
    @objc func startPickIconImage(_ sender: CameraButton) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
        
        let photoPicker = UIImagePickerController()
        photoPicker.sourceType = .photoLibrary
        photoPicker.delegate = self
        self.present(photoPicker, animated: true, completion: nil)
    }
    
    
    @objc func adjustForKeybord(when notification: Notification) {
        guard let keyboardScreenFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }

        switch notification.name {
        case UIResponder.keyboardDidHideNotification:
            break
//            tableView.setContentOffset(.zero, animated: false)

        case UIResponder.keyboardWillChangeFrameNotification: fallthrough
        case UIResponder.keyboardWillShowNotification:
            let keyboardViewFrame = tableView.convert(keyboardScreenFrame, from: view.window)
            let textViewFrame = textView.convert(textView.frame, to: tableView)

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
    
    
    private func customizeImageView(_ imageView: UIImageView, icon: UIImage?=nil) {
        // if icon exists
        if let icon = icon {
            imageView.image = icon
            imageView.backgroundColor = UIColor.clear
        } else {
            imageView.backgroundColor = .primaryLightColor
        }
        
        // set iconImageView attributes
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20.0
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor.textOnPrimaryColor.cgColor
    }
    
    
    private func refresh() {
        self.tableView.reloadData()
        self.updateDoneButtonState()
        // when combination scene is ready, scroll to it
        if resources.shouldScrollToCombinationCell {
            tableView.scrollToRow(at: resources.indexPathOfCombinationCellInNewTopicScene!, at: .top, animated: true)
            resources.shouldScrollToCombinationCell = false
        }
    }
}




// MARK: - UIImagePicker Delegate

extension NewTopicViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // save pickedImage to resources
        if let pickedImage = info[.originalImage] as? UIImage {
            resources.newTopicIcon = pickedImage
        }
        picker.dismiss(animated: true, completion: { [unowned self] in
            self.refresh()
            self.tableView.scrollToRow(at: self.resources.indexPathOfDescriptionCellInNewTopicScene, at: .middle, animated: true)
            self.resources.descriptionTextViewShouldBecomeFirstResponder = true
        })
    }
}
