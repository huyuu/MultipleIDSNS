//
//  ChangingNameTableViewCellInBottomNavigationDrawer.swift
//  MID
//
//  Created by 江宇揚 on 2019/07/31.
//  Copyright © 2019 Jiang Yuyang. All rights reserved.
//

import UIKit

@IBDesignable
class ChangingNameTableViewCellInBottomNavigationDrawer: UITableViewCell {
        
    @IBOutlet weak var nameTextField: TextFieldWithIndicationBorder!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.prepare()
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.prepare()
    }
    
    
    
    // MARK: - Custom Helper Functions
    
    private func prepare() {
        
    }
}
