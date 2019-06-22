//
//  NewNameTableViewController.swift
//  MID
//
//  Created by 江宇揚 on 2019/06/08.
//  Copyright © 2019 Jiang Yuyang. All rights reserved.
//

import UIKit

@IBDesignable
class NewNameTableViewController: UITableViewController {
    
    internal var resources: ResourcesForAddSnsidScene!
    private var indicatorLayer: CALayer!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareForViewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resources.numberOfNewNameCells
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: resources.newNameCells[indexPath.row].reuseId, for: indexPath)

        self.updateUI(of: cell, for: indexPath)

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
 

    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard resources.segueIdToSearchTopic == segue.identifier! else { fatalError() }
        let destinationController = segue.destination as! SearchTopicTableViewController
        destinationController.resources = self.resources
    }
    
    
    
}



// MARK: - Custom Helper Functions

extension NewNameTableViewController {
    private func prepareForViewDidLoad() {
        // set navigation items
        self.navigationItem.title = resources.navigationItemTitle
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.leftBarButtonItem?.title = "Back"
    }
    
    
    private func updateUI(of cell: UITableViewCell, for indexPath: IndexPath) {
        let cellAttributes = resources.newNameCells[indexPath.row]
        switch cellAttributes.type {
        case .title:
            let titleLabel = cell.viewWithTag(11) as! UILabel
            titleLabel.text = cellAttributes.content!
            
            
        case .name:
            let userInputTextField = cell.viewWithTag(11) as! UITextField
            let availableIndicator = AvailabilityIndicatorView(frame: CGRect(x: 0, y: 0, width: userInputTextField.bounds.height - UITextField.insetForSideView, height: userInputTextField.bounds.height - UITextField.insetForSideView))
            
            // prepare for user input
            userInputTextField.delegate = self
            userInputTextField.placeholder = cellAttributes.content!
            userInputTextField.layer.borderWidth = resources.textFieldBorderWidth
            userInputTextField.rightView = availableIndicator
            userInputTextField.rightViewMode = .always
            userInputTextField.borderStyle = .none
            userInputTextField.layer.borderWidth = 0
            userInputTextField.becomeFirstResponder()
            // change layout of availability indicator
            availableIndicator.layoutAccording(to: resources.nameIsAvailable)
            // set cell style
            self.indicatorLayer = cell.layer
            self.updateLayerForIndication(self.indicatorLayer)
        }
    }
    
    
    private func updateLayerForIndication(_ layer: CALayer) {
        layer.cornerRadius = resources.cornerRadiusOfNewNameCell
        layer.borderWidth = resources.borderWidthOfNewNameCell
        layer.borderColor = ResourcesForAddSnsidScene.indicatorColor(accordingTo: self.resources.nameIsAvailable).cgColor
    }
}



// MARK: - UITextField Delegate

extension NewNameTableViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.text = resources.userInputForNewName
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // add string and check the availability
        resources.userInputForNewName = textField.textForStorage(newChar: string)
        // update indicator view
        let indicator = textField.rightView! as! AvailabilityIndicatorView
        indicator.layoutAccording(to: resources.nameIsAvailable)
        self.updateLayerForIndication(self.indicatorLayer)
        
        return true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if resources.nameIsAvailable {
            // store new name
            resources.newName = resources.userInputForNewName
            self.performSegue(withIdentifier: resources.segueIdToSearchTopic, sender: nil)
        }
    }
}



// MARK: - Custom UITextField Helper Functions

fileprivate extension UITextField {
    static let insetForSideView: CGFloat = 7.0
    
    
    func layoutAccordingTo(_ isValid: Bool) {
        self.layer.borderColor = ResourcesForAddSnsidScene.indicatorColor(accordingTo: isValid).cgColor
    }
    
    
    /// for textFieldShouldChangeChar
    func textForStorage(newChar: String) -> String {
        let text = self.text ?? ""
        guard newChar != "" else {
            return String(text.dropLast())
        }
        return text + newChar
    }
}