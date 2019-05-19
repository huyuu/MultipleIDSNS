//
//  PostDetailsCell.swift
//  MID
//
//  Created by 江宇揚 on 2019/05/18.
//  Copyright © 2019 Jiang Yuyang. All rights reserved.
//

import UIKit

class PostDetailsCell: UITableViewCell {
    @IBOutlet weak var speakerNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentsLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
