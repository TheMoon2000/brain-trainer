//
//  TrainerCell.swift
//  Brain Trainer
//
//  Created by Jia Rui Shan on 13/06/2017.
//  Copyright © 2017 Jia Rui Shan. All rights reserved.
//

import UIKit

class TrainerCell: UITableViewCell {
    @IBOutlet weak var background: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        background.layer.cornerRadius = 10
//        self.contentView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
