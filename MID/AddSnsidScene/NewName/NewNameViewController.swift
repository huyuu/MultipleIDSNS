//
//  NewNameTableViewController.swift
//  MID
//
//  Created by 江宇揚 on 2019/06/08.
//  Copyright © 2019 Jiang Yuyang. All rights reserved.
//

import UIKit

@IBDesignable
class NewNameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddSnsidSceneController {
    
    @IBOutlet var tableView: UITableView!
    
    internal weak var resources: ResourcesForAddSnsidScene!
    internal weak var containerViewController: AddSnsidContainerViewController?
    private var indicatorLayer: CALayer!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareForViewDidLoad()
    }
    
    

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resources.numberOfNewNameCells
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cells = resources.totalNewNameCells
        let cell = tableView.dequeueReusableCell(withIdentifier: cells[indexPath.row].reuseId, for: indexPath)

        self.configureCell(cell, for: indexPath)

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
    
    // MARK: - Navigation
    
    func willTransitToNextScene() {
        // store new name
        resources.newName = resources.userInputForNewName
    }
    
    
    func updateNextButtonState(isReady: Bool) {
        self.containerViewController?.nextButton.layoutWith(isEnabled: isReady)
    }
}



// MARK: - Custom Helper Functions

extension NewNameViewController {
    private func prepareForViewDidLoad() {
    }
    
    
    private func configureCell(_ cell: UITableViewCell, for indexPath: IndexPath) {
        let cellAttributes = resources.totalNewNameCells[indexPath.row]
        switch cellAttributes.type {
        case .title:
            let titleLabel = cell.viewWithTag(11) as! UILabel
            
            titleLabel.text = cellAttributes.content
            titleLabel.textColor = UIColor.primaryColor
            
        case .name:
            let userInputTextField = cell.viewWithTag(11) as! UITextField
//            let availableIndicator = AvailabilityIndicatorView(frame: CGRect(x: 0, y: 0, width: userInputTextField.bounds.height - UITextField.insetForSideView, height: userInputTextField.bounds.height - UITextField.insetForSideView))
            
            // prepare for user input
            userInputTextField.delegate = self
            userInputTextField.placeholder = cellAttributes.content
            userInputTextField.borderStyle = .none
            userInputTextField.layer.borderWidth = 0
            userInputTextField.becomeFirstResponder()
            // set cell style
            self.indicatorLayer = cell.layer
            self.updateLayerForIndication(self.indicatorLayer)
            
            
        case .errorDescription:
            let errorDescriptionLabel = cell.viewWithTag(11) as! UILabel
            // set error description string
            errorDescriptionLabel.text = cellAttributes.content
            errorDescriptionLabel.textColor = resources.isNameAvailable ? UIColor.white : UIColor.black
        }
    }
    
    
    private func updateLayerForIndication(_ layer: CALayer) {
        layer.cornerRadius = Standards.CornerRadius.largeCell
        layer.borderWidth = Standards.BorderWidth.largeCell
        layer.borderColor = ResourcesForAddSnsidScene.indicatorColor(accordingTo: self.resources.isNameAvailable).cgColor
        // reload tableView to show the error description string
        let indexPath = IndexPath(row: resources.rowNumberOfErrorDescriptionCell, section: 0)
        tableView.reloadRows(at: [indexPath], with: .fade)
        // trigger On/Off of the doneButton
        self.updateNextButtonState(isReady: resources.isNameAvailable)
    }
}



// MARK: - UITextField Delegate

extension NewNameViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.text = resources.userInputForNewName
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // add string and check the availability
        resources.userInputForNewName = textField.textForStorage(newChar: string)
        // update UI for indication
        self.updateLayerForIndication(self.indicatorLayer)
        return true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        resources.userInputForNewName = textField.text ?? ""
    }
}
