//
//  ArithmeticTestViewController.swift
//  Brain Trainer
//
//  Created by Jia Rui Shan on 2018/9/1.
//  Copyright © 2018 Jia Rui Shan. All rights reserved.
//

import UIKit

// Structure of expected information
struct ArithmeticTestInfo {
    
    var q_count: Int
    var highest_term: Int
    var q_type: QuestionType // 0 = addition, 1 = multiplication, 2 = both
    let parentVC: ArithmeticStartViewController?
    
    init(q_count: Int, highest_term: Int, q_type: QuestionType, parent: ArithmeticStartViewController) {
        self.q_count = q_count
        self.highest_term = highest_term
        self.q_type = q_type
        self.parentVC = parent
    }
    
    init() {
        q_count = 0
        highest_term = 0
        q_type = .addition
        parentVC = nil
    }
}

// Information passed from ArithmeticStart.swift
var testInfo = ArithmeticTestInfo()

class ArithmeticTestViewController: UIViewController {
    
    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var pageTitle: UILabel!
    @IBOutlet weak var problem: UILabel!
    @IBOutlet weak var answer: UILabel!
    @IBOutlet weak var progress_bar: UIProgressView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var b1: UIButton!
    @IBOutlet weak var b2: UIButton!
    @IBOutlet weak var b3: UIButton!
    @IBOutlet weak var b4: UIButton!
    @IBOutlet weak var b5: UIButton!
    @IBOutlet weak var b6: UIButton!
    @IBOutlet weak var b7: UIButton!
    @IBOutlet weak var b8: UIButton!
    @IBOutlet weak var b9: UIButton!
    @IBOutlet weak var b0: UIButton!
    @IBOutlet weak var minus: UIButton!
    @IBOutlet weak var delete: UIButton!
    
    var currentQuestionNumber = 1
    var numberOfCorrectAnswers = 0
    var currentProblem = (problem: "", answer: "")
    var startTime = Date()
    var endTime = Date()
    var incorrectCases = [(problem: String, index: Int, answer: String, userAnswer: String)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        problem.text = ""
        answer.text = "0"
        
        let tint = UIColor(red: 166.0/255, green: 130.0/255, blue: 1, alpha: 1)
        
        [b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, minus].forEach({
            $0!.setTitleColor(tint, for: .highlighted)
        })
        
        bannerView.backgroundColor = bannerTint
        
        if UIDevice.modelName.hasSuffix("iPhone X") {
            if let canvasTopGuide = self.view.constraints.filter({$0.identifier == "topguide"}).first {
                canvasTopGuide.constant = -44
            }
        }
        
        startTime = Date()
        
        pageTitle.text = "Arithmetic Exercise - Q1"
        
        nextQuestion()
    }
    
    func restartTest() {
        currentQuestionNumber = 1
        numberOfCorrectAnswers = 0
        progress_bar.progress = 0
        nextButton.setTitle("Question 1/\(testInfo.q_count)", for: .normal)
    }
    
    
    func nextQuestion() {
        if currentQuestionNumber > testInfo.q_count {
            // Finished test
            nextButton.isEnabled = false
            endTime = Date()
            arithmeticResult = ArithmeticTestResult(totalQuestions: testInfo.q_count, highestTerm: testInfo.highest_term, correctAnswers: numberOfCorrectAnswers, duration: endTime.timeIntervalSince(startTime), questionType: testInfo.q_type, testVC: self, incorrectCases: incorrectCases)
            self.performSegue(withIdentifier: "arithmetic_result", sender: self)
        } else {
            currentProblem = generateProblem(highest_term: testInfo.highest_term, problem_type: testInfo.q_type)
            problem.text = currentProblem.problem + " = ?"
            answer.text = "0"
            if testInfo.q_count > currentQuestionNumber {
                nextButton.setTitle("Question \(currentQuestionNumber + 1)/\(testInfo.q_count) →", for: .normal)
            } else {
                nextButton.setTitle("Finish Test", for: .normal)
            }
        }
    }
    
    
    // 0 - 9 digits
    @IBAction func press_digit(_ sender: UIButton) {
        sender.layer.borderWidth = 0
        sender.backgroundColor = nil
        if answer.text == "0" {
            answer.text = sender.currentTitle == "0" ? "0" : sender.currentTitle
        } else if answer.text == "–" {
            answer.text = sender.currentTitle == "0" ? "–" : "–" + sender.currentTitle!
        } else {
            answer.text = answer.text! + sender.currentTitle!
        }
    }

    @IBAction func press_minus(_ sender: UIButton) {
        sender.layer.borderWidth = 0
        sender.backgroundColor = nil
        assert(answer.text != nil, "Answer field is nil!")
        let n = answer.text!.replacingOccurrences(of: "–", with: "-")
        if n == "-" {answer.text = "0"; return}
        if n == "0" {answer.text = "–"} else {
            answer.text = Int(n)! >= 0 ? "–" + n : String(abs(Int32(n) ?? 0))
        }
    }
    
    @IBAction func press_button(_ sender: UIButton) {
        sender.layer.borderColor = UIColor(white: 0.8, alpha: 1).cgColor
        sender.layer.borderWidth = 1.9
        sender.backgroundColor = UIColor(white: 0.97, alpha: 0.9)
    }
    
    @IBAction func clearAnswer(_ sender: UIButton) {
        answer.text = "0"
    }
    
    @IBAction func deleteDigit(_ sender: UIButton) {
        if answer.text!.lengthOfBytes(using: .utf8) == 1 || answer.text == "–" {
            answer.text = "0"
        } else if answer.text!.hasPrefix("–") {
            answer.text = String(Int(answer.text!.replacingOccurrences(of: "–", with: "-"))! / 10)
        } else {
            answer.text = String(Int(answer.text!)! / 10)
        }
    }
    
    @IBAction func proceedNext(_ sender: UIButton) {
        if answer.text!.replacingOccurrences(of: "–", with: "-") == currentProblem.answer {
            numberOfCorrectAnswers += 1
        } else {
            incorrectCases.append((problem.text!, currentQuestionNumber, currentProblem.answer.replacingOccurrences(of: "-", with: "–"), answer.text!))
        }
        progress_bar.progress = Float(currentQuestionNumber) / Float(testInfo.q_count)
        currentQuestionNumber += 1
        pageTitle.text = "Arithmetic Exercise - Q\(currentQuestionNumber)"
        nextQuestion()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func generateProblem(highest_term h: Int, problem_type: QuestionType) ->(problem: String, answer: String) {
        switch problem_type {
        case .addition:
            return generateAdditionProblem(h: h)
        case .multiplication:
            return generateMultiplicationProblem(h: h)
        case .both:
            return arc4random_uniform(2) == 0 ? generateAdditionProblem(h: h) : generateMultiplicationProblem(h: h)
        }
    }
    
    func generateAdditionProblem(h: Int) -> (problem: String, answer: String) {
        let numberOfTerms = Int(arc4random_uniform(2)) + 2
        var terms = [Int]()
        var answer = 0
        for _ in 0..<numberOfTerms {
            terms.append(-h + Int(arc4random_uniform(2 * UInt32(h) + 1))) // A number from -h to h
            if terms.last == 0 {terms[terms.count-1] = h - 1}
            answer += terms.last! // Last term guaranteed to exist
        }
        let p = terms.map({$0 >= 0 ? String($0) : "– " + String(-$0)}).joined(separator: " + ")
        return (p.replacingOccurrences(of: " + – ", with: " – "), String(answer))
    }
    
    func generateMultiplicationProblem(h: Int) -> (problem: String, answer: String) {
        
        if arc4random_uniform(2) == 0 {
            var terms = [Int]()
            var answer = 1
            for _ in 0..<2 {
                terms.append(10 + Int(arc4random_uniform(UInt32(h - 9)))) // A number from -h to h
                answer *= terms.last! // Last term guaranteed to exist
            }
            let p = terms.map({String($0)}).joined(separator: " × ")
            return (p, String(answer))
        } else {
            let divisor = 2 + Int(arc4random_uniform(UInt32(h - 1)))
            let answer = 5 + Int(arc4random_uniform(UInt32(h - 4)))
            let dividend = divisor * answer
            let p = "\(dividend) ÷ \(divisor)"
            return (p, String(answer))
        }
    }
    
    @IBAction func dismissView(_ sender: UIButton) {
        mainVC.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
