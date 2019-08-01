//
//  EdittingDescriptionTableViewCellInBottomNavigationDrawer.swift
//  MID
//
//  Created by 江宇揚 on 2019/07/31.
//  Copyright © 2019 Jiang Yuyang. All rights reserved.
//

import UIKit

class EdittingDescriptionTableViewCellInBottomNavigationDrawer: UITableViewCell {
    
    @IBOutlet weak var descriptionTextView: TextViewWithPlaceHolder!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
