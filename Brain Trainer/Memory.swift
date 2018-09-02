//
//  MemoryViewController.swift
//  Reaction Timer
//
//  Created by Jia Rui Shan on 10/12/16.
//  Copyright © 2016 Jerry Shan. All rights reserved.
//

import UIKit

let outlineColor = UIColor(white: 0.95, alpha: 0.9).cgColor

func customButton(buttons: [UIButton], borderColor: CGColor) {
    for b in buttons {
        b.layer.borderWidth = 1
        b.layer.borderColor = borderColor
    }
}

class MemoryViewController: UIViewController {
    
    @IBOutlet weak var startView: UIView!
    @IBOutlet weak var numberOfDigits: UILabel!
    @IBOutlet weak var beginbutton: UIButton!
    @IBOutlet weak var numberOfSeconds: UILabel!
    @IBOutlet weak var digitSlider: UISlider!
    @IBOutlet weak var delaySlider: UISlider!
    @IBOutlet weak var digitType: UISegmentedControl!
    
    //Test
    @IBOutlet weak var testView: UIView!
    @IBOutlet weak var digit: UILabel!
    @IBOutlet weak var timeRemaining: UIProgressView!
    @IBOutlet weak var timeRemainingPrompt: UILabel!
    @IBOutlet weak var digitIndex: UILabel!
    @IBOutlet weak var textProgress: UIProgressView!
    
    //Answer
    @IBOutlet weak var answerView: UIView!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var currentAnswerDigit: UILabel!
    @IBOutlet weak var answerProgress: UIProgressView!
    
    //Result
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var resultTitle: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var backToMenu: UIButton!
    @IBOutlet weak var difficultyIndex: UILabel!
    @IBOutlet weak var averageTime: UILabel!
    
    let alphabets = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q",
    "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    let both = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q",
        "r", "s", "t", "u", "v", "w", "x", "y", "z", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
    
    var digitArray: [String] = []
    var answerArray: [String] = []
    
    var time: Double = 0.0
    var digitNumber: Int = 0
    var digitDelay: Float = 0.0
    var answerDigit: Int = 0
    var startAnswerTime: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        beginbutton.layer.borderWidth = 1
        beginbutton.layer.cornerRadius = 21
        beginbutton.layer.borderColor = beginbutton.tintColor.cgColor
        
        let outlineColor = UIColor(white: 0.95, alpha: 0.9).cgColor
        customButton(buttons: [button1, button2, button3, button4], borderColor: outlineColor)
        
        backToMenu.layer.borderWidth = 1
        backToMenu.layer.cornerRadius = 21
        backToMenu.layer.borderColor = beginbutton.tintColor.cgColor
        let previousdigit = UserDefaults.standard.integer(forKey: "Digits")
        if previousdigit > 0 {
            digitNumber = previousdigit
            digitSlider.value = Float(previousdigit)
            numberOfDigits.text = String(previousdigit)
        }
        let previousDelay = UserDefaults.standard.float(forKey: "Delay")
        if previousDelay > 0.0 {
            digitDelay = previousDelay
            delaySlider.value = digitDelay
            numberOfSeconds.text = "\(digitDelay)s"
        }
    }
    
    @IBAction func changeDigits(_ sender: UISlider) {
        numberOfDigits.text = "\(Int(sender.value))"
        UserDefaults.standard.set(Int(sender.value), forKey: "Digits")
    }
    
    @IBAction func changeDelay(_ sender: UISlider) {
        digitDelay = round(sender.value * 10) / 10.0
        UserDefaults.standard.set(digitDelay, forKey: "Delay")
        numberOfSeconds.text = "\(digitDelay)s"
    }
    
    @IBAction func startTest(_ sender: UIButton) {
        
        //Initialize the Test
        startView.isHidden = true
        testView.isHidden = false
        timeRemainingPrompt.text = "Get Prepared..."
        digitIndex.text = ""
        textProgress.isHidden = true
        digit.text = ""
        timeRemaining.isHidden = true
        timeRemaining.progress = 0
        textProgress.progress = 0
        
        digitDelay = round(delaySlider.value * 10) / 10.0
        digitArray = []
        answerArray = []
    
        Thread.detachNewThreadSelector(#selector(MemoryViewController.test), toTarget: self, with: nil)
        
    }
    
    func setStringForDigit(_ string: String) {
        digit.text = string
    }
    
    func progressInit() {
        timeRemaining.isHidden = false
        digitIndex.text = "Item 1 of \(Int(digitSlider.value))"
        timeRemaining.setProgress(0.0, animated: true)
        textProgress.isHidden = false
        textProgress.setProgress(0.0, animated: true)
    }
    
    func setProgress() {
        
        timeRemaining.setProgress(Float(time) / delaySlider.value, animated: false)
        let roundedTime = digitDelay - round(Float(time) * 10) / 10
        if roundedTime == 1.0 {
            timeRemainingPrompt.text = "1.0 second left"
        } else {
            timeRemainingPrompt.text = "\(roundedTime) seconds left"
        }
    }
    
    func setDigitProgress() {
        print(digitNumber)
        textProgress.setProgress(Float(digitNumber) / Float(Int(digitSlider.value)), animated: true)
        digitIndex.text = "Item \(digitNumber) of \(Int(digitSlider.value))"
        if !startView.isHidden {
            backtoMenu(UIButton())
        }
    }
    
    func test() {
        for i in 0..<3 {
            self.performSelector(onMainThread: #selector(MemoryViewController.setStringForDigit(_:)), with: String(3 - i), waitUntilDone: false)
            Thread.sleep(forTimeInterval: 0.99)
            if !startView.isHidden {
                backtoMenu(UIButton())
                return
            }
        }
    
        self.performSelector(onMainThread: #selector(MemoryViewController.progressInit), with: nil, waitUntilDone: false)
        
        for i in 0..<Int(digitSlider.value) {
            var d = ""
            if digitType.selectedSegmentIndex == 0 {
                d = String(arc4random_uniform(9))
            } else if digitType.selectedSegmentIndex == 1 {
                d = alphabets[Int(arc4random_uniform(26))]
            } else {
                d = both[Int(arc4random_uniform(36))]
            }
            self.performSelector(onMainThread: #selector(MemoryViewController.setStringForDigit(_:)), with: "\(d)", waitUntilDone: false)
            digitNumber = i + 1
            self.performSelector(onMainThread: #selector(MemoryViewController.setDigitProgress), with: nil, waitUntilDone: false)
//            timeRemaining.setProgress(0.0, animated: true)
            digitArray.append(d)
            let beginTime = Date.timeIntervalSinceReferenceDate
            
            time = 0.0
            let delaytime = Double(delaySlider.value)
            
            while time < delaytime {
                time = Date.timeIntervalSinceReferenceDate - beginTime
                self.performSelector(onMainThread: #selector(MemoryViewController.setProgress), with: nil, waitUntilDone: false)
                Thread.sleep(forTimeInterval: 0.004)
            }
        }
        if !startView.isHidden {
            backtoMenu(UIButton())
        }
        testView.isHidden = true
        if startView.isHidden {
            self.performSelector(onMainThread: #selector(MemoryViewController.answer), with: nil, waitUntilDone: false)
        }
    }
    
    @IBAction func answerButtonPressed(_ sender: UIButton) {
        answerDigit += 1
        answerArray.append(sender.titleLabel!.text!)
        if answerDigit == digitNumber {
            compareAnswer()
            return
        }
        generateMultipleChoices()
    }
    
    func generateMultipleChoices() {
        currentAnswerDigit.text = "Item \(answerDigit+1) of \(digitNumber)"
        answerProgress.setProgress(Float(answerDigit) / Float(digitNumber), animated: false)
        var numbers = [String]()
        if digitType.selectedSegmentIndex == 0 {
            numbers = ["0","1","2","3","4","5","6","7","8","9"]
        } else if digitType.selectedSegmentIndex == 1 {
            numbers = alphabets
        } else {
            numbers = both
        }
        var buttons = [button1, button2, button3, button4]
        let randombutton = arc4random_uniform(4)
        let chosenbutton = buttons.remove(at: Int(randombutton))
        numbers.remove(at: numbers.index(of: digitArray[answerDigit])!)
        chosenbutton?.setTitle("\(digitArray[answerDigit])", for: UIControlState())
        chosenbutton?.setTitle("\(digitArray[answerDigit])", for: .highlighted)
        for i in 0...2 {
            let r = arc4random_uniform(UInt32(numbers.count))
            let d = numbers.remove(at: Int(r))
            buttons[i]?.setTitle("\(d)", for: UIControlState())
            buttons[i]?.setTitle("\(d)", for: .highlighted)
        }
    }
    
    func answer() {
        
        //Initialize
        answerProgress.setProgress(0, animated: false)
        answerView.isHidden = false
        currentAnswerDigit.text = "Item 1 of \(digitNumber)"
        answerDigit = 0
        generateMultipleChoices()
        startAnswerTime = Date.timeIntervalSinceReferenceDate
        
    }
    
    func compareAnswer() {
        
        answerView.isHidden = true
        resultView.isHidden = false
        
        let totalTime = Date.timeIntervalSinceReferenceDate - startAnswerTime
        
        var correctAnswers = 0
        for i in 0..<digitArray.count {
            if digitArray[i] == answerArray[i] {
                correctAnswers += 1
            }
        }
        
        averageTime.text = "Avg. Speed: \(round(10 * totalTime / Double(digitNumber))/10)s / answer"
        
        let percentage = correctAnswers * 100 / digitArray.count
         score.text = "\(correctAnswers)/\(digitNumber)"
        if percentage == 100 {
            resultTitle.text = "Perfect! 100% Correct!"
        } else if percentage >= 95 {
            resultTitle.text = "\(percentage)%. You've made it."
        } else if percentage >= 90 {
            resultTitle.text = "Excellent - \(percentage)%!"
        } else if percentage >= 80 {
            resultTitle.text = "Satisfactory - \(percentage)%."
        } else {
            resultTitle.text = "\(percentage)%. You did not pass."
        }
       let dscore = (5.1 - digitDelay) * Float(correctAnswers * correctAnswers) / Float(digitNumber) * 10
        difficultyIndex.text = "Difficulty Index: \(round(dscore * 10) / 10)"
    }
    
    @IBAction func backtoMenu(_ sender: UIButton) {
        testView.isHidden = true
        answerView.isHidden = true
        resultView.isHidden = true
        startView.isHidden = false
    }
    
    @IBAction func dismissView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: {
            print("memory view dismissed")
        })
    }
    
}
