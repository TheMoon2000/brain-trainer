//
//  IncorrectAnswerViewController.swift
//  Brain Trainer
//
//  Created by Jia Rui Shan on 2018/9/3.
//  Copyright © 2018 Jia Rui Shan. All rights reserved.
//

import UIKit

class IncorrectAnswerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    
    var incorrectNumbers = [(problem: String, index: Int, answer: String, userAnswer: String)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = bannerTint
        
        let nib = UINib(nibName: "IncorrectAnswerCell", bundle: Bundle.main)
        table.register(nib, forCellReuseIdentifier: "incorrect_answer")
        table.allowsSelection = false
        table.backgroundColor = UIColor.clear
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return incorrectNumbers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "incorrect_answer", for: indexPath) as! IncorrectAnswerCell
        cell.questionNumber.text = "Question \(incorrectNumbers[indexPath.row].index):"
        cell.question.text = incorrectNumbers[indexPath.row].problem
        cell.real_answer = incorrectNumbers[indexPath.row].answer
        cell.userAnswer.text = incorrectNumbers[indexPath.row].userAnswer
        cell.answer.text = "[Hidden]"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 103
    }
    
    @IBAction func dismissView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}
