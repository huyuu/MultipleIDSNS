//
//  DetailContainerViewController.swift
//  MID
//
//  Created by 江宇揚 on 2019/07/11.
//  Copyright © 2019 Jiang Yuyang. All rights reserved.
//

import UIKit

@IBDesignable
class UserDescriptionDetailContainerViewController: UIViewController {
    
    @IBOutlet weak var errorDescriptionLable: UILabel!
    @IBOutlet weak var nameTextField: TextFieldWithIndication!
    
    internal var resources: ResourcesForAddSnsidScene!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareForViewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.prepareForViewWillAppear()
    }
    

    
    // MARK: - Custom Helper Functions
    
    private func prepareForViewDidLoad() {
        errorDescriptionLable.text = "Name already exists or is blank."
    }
    
    
    private func prepareForViewWillAppear() {
        // set name everytime this view is reloaded.
        nameTextField.text = resources.newName
        nameTextField.becomeFirstResponder()
    }
}



// MARK: - TextField Delegate

extension UserDescriptionDetailContainerViewController: UITextFieldDelegate {   
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        resources.userInputForNewName = textField.textForStorage(newChar: string)
        // update nameTextField appearance for indication accodring to input name.
        nameTextField.layoutAccordingTo(resources.nameIsAvailable)
        return true
    }
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
