//
//  TimeLineTableViewCell.swift
//  MID
//
//  Created by 江宇揚 on 2019/05/18.
//  Copyright © 2019 Jiang Yuyang. All rights reserved.
//

import UIKit

@IBDesignable
class TimeLineTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconImageView.layer.cornerRadius = 5
        iconImageView.layer.masksToBounds = true
    }
}
