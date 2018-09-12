//
//  MemoryAnswerView.swift
//  Brain Trainer
//
//  Created by Jia Rui Shan on 2018/9/9.
//  Copyright © 2018 Jia Rui Shan. All rights reserved.
//

import UIKit

class MemoryAnswerView: UIViewController {
    
    //Inherited from source view controller
    var startVC: MemoryViewController?
    var testViewVC: MemoryTestView?
    var correctAnswer = [String]()
    var digitType: DigitType = .digits
    
    @IBOutlet weak var bannerView: UIView!
    
    //Answer
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var currentAnswerDigit: UILabel!
    @IBOutlet weak var answerProgress: UIProgressView!
    
    var startAnswerTime: Double = 0.0
    var digitArray: [String] = []
    var userAnswer: [String] = []
    var answerDigit: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bannerView.backgroundColor = bannerTint
        
        let outlineColor = UIColor(white: 0.95, alpha: 0.9).cgColor
        customButton(buttons: [button1, button2, button3, button4], borderColor: outlineColor)
        
        DispatchQueue.main.async {
            self.answer()
        }
    }

    @IBAction func dismissView(_ sender: UIButton) {
        startVC?.mainVC?.dismiss(animated: true, completion: nil)
    }
    
    func generateMultipleChoices() {
        currentAnswerDigit.text = "Item \(answerDigit+1) of \(digitArray.count)"
        answerProgress.setProgress(Float(answerDigit) / Float(digitArray.count), animated: false)
        var numbers = [String]()
        switch digitType {
        case.digits:
            numbers = Array(0...9).map {String($0)}
        case .letters:
            numbers = MemoryTestView.alphabets
        case .both:
            numbers = MemoryTestView.both
        }
        var buttons = [button1, button2, button3, button4]
        let randombutton = arc4random_uniform(4)
        let chosenbutton = buttons.remove(at: Int(randombutton))
        numbers.remove(at: numbers.index(of: digitArray[answerDigit])!)
        chosenbutton?.setTitle("\(digitArray[answerDigit])", for: .normal)
        chosenbutton?.setTitle("\(digitArray[answerDigit])", for: .highlighted)
        for i in 0...2 {
            let r = arc4random_uniform(UInt32(numbers.count))
            let d = numbers.remove(at: Int(r))
            buttons[i]?.setTitle("\(d)", for: .normal)
            buttons[i]?.setTitle("\(d)", for: .highlighted)
        }
    }
    
    func answer() {
        
        //Initialize
        answerProgress.setProgress(0, animated: true)
        currentAnswerDigit.text = "Item 1 of \(digitArray.count)"
        answerDigit = 0
        generateMultipleChoices()
        startAnswerTime = Date.timeIntervalSinceReferenceDate
        
    }
    
    
    @IBAction func answerButtonPressed(_ sender: UIButton) {
        answerDigit += 1
        userAnswer.append(sender.titleLabel!.text!)
        if answerDigit == digitArray.count {
            compareAnswer()
        } else {
            generateMultipleChoices()
        }
    }
    
    
    func compareAnswer() {
        self.performSegue(withIdentifier: "memory_results", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! MemoryTestScore
        vc.memoryStartView = startVC
        vc.userAnswer = userAnswer
        vc.answerView = self
        
        let totalTime = Date.timeIntervalSinceReferenceDate - startAnswerTime
        DispatchQueue.main.async {
            vc.averageTime.text = "Avg. Speed: \(round(10 * totalTime / Double(self.digitArray.count))/10)s / answer"
            
            var correctAnswers = 0
            for i in 0..<self.digitArray.count {
                if self.digitArray[i] == self.digitArray[i] {
                    correctAnswers += 1
                }
            }
            
            let percentage = correctAnswers * 100 / self.digitArray.count
            vc.score.text = "\(correctAnswers)/\(self.digitArray.count)"
            if percentage == 100 {
                vc.resultTitle.text = "Perfect! 100% Correct!"
            } else if percentage >= 95 {
                vc.resultTitle.text = "\(percentage)%. You've made it."
            } else if percentage >= 90 {
                vc.resultTitle.text = "Excellent - \(percentage)%!"
            } else if percentage >= 80 {
                vc.resultTitle.text = "Satisfactory - \(percentage)%."
            } else {
                vc.resultTitle.text = "\(percentage)%. You did not pass."
            }
            
            let dscore = (5.2 - self.testViewVC!.delay) * Float(correctAnswers * correctAnswers) / Float(self.digitArray.count) * 10
            vc.difficultyIndex.text = "Difficulty Index: \(round(dscore * 10) / 10)"
        }
    }
    
    @IBAction func exitTest(_ sender: UIButton) {
        testViewVC?.view.isHidden = true
        startVC?.dismiss(animated: false, completion: nil)
    }

}
