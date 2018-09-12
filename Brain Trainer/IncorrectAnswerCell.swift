//
//  IncorrectAnswerCell.swift
//  Brain Trainer
//
//  Created by Jia Rui Shan on 2018/9/3.
//  Copyright © 2018 Jia Rui Shan. All rights reserved.
//

import UIKit

class IncorrectAnswerCell: UITableViewCell {
    
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var questionNumber: UILabel!
    @IBOutlet weak var answer: UILabel!
    @IBOutlet weak var userAnswer: UILabel!
    @IBOutlet weak var showButton: UIButton!
    @IBOutlet weak var bgView: UIView!
    
    var real_answer = ""

    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.backgroundColor = UIColor.clear
        bgView.layer.cornerRadius = 10
    }
    
    @IBAction func show(_ sender: UIButton) {
        if answer.text == "[Hidden]" {
            sender.setTitle("Hide", for: .normal)
            sender.setTitle("Hide", for: .focused)
            sender.setTitle("Hide", for: .highlighted)
            answer.text = real_answer
            answer.textColor = UIColor(white: 1, alpha: 0.95)
        } else {
            sender.setTitle("Show", for: .normal)
            sender.setTitle("Show", for: .focused)
            sender.setTitle("Show", for: .highlighted)
            real_answer = answer.text!
            answer.text = "[Hidden]"
            answer.textColor = UIColor(white: 1, alpha: 0.3)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
