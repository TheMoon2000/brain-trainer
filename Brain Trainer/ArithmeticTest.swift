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
    var q_type: Int // 0 = addition, 1 = multiplication, 2 = both
    let parentVC: ArithmeticStartViewController?
    
    init(q_count: Int, highest_term: Int, q_type: Int, parent: ArithmeticStartViewController) {
        self.q_count = q_count
        self.highest_term = highest_term
        self.q_type = q_type
        self.parentVC = parent
    }
    
    init() {
        q_count = 0
        highest_term = 0
        q_type = 0
        parentVC = nil
    }
}

// Information passed from ArithmeticStart.swift
var testInfo = ArithmeticTestInfo()

class ArithmeticTestViewController: UIViewController {
    
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

    override func viewDidLoad() {
        super.viewDidLoad()

        problem.text = ""
        answer.text = "0"
        
//        customButton(buttons: [b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, b0, minus, delete], borderColor: outlineColor)
        
        if UIDevice.modelName.hasSuffix("iPhone X") {
            if let canvasTopGuide = self.view.constraints.filter({$0.identifier == "topguide"}).first {
                canvasTopGuide.constant = -44
            }
        }
        
        nextQuestion()
    }
    
    func restartTest() {
        currentQuestionNumber = 1
        numberOfCorrectAnswers = 0
        progress_bar.progress = 0
        nextButton.setTitle("Question 1/\(testInfo.q_count)", for: .normal)
    }
    
    
    func nextQuestion() {
        if currentQuestionNumber == testInfo.q_count {
            // Finished test, perform segue
            
        } else {
            currentProblem = generateProblem(highest_term: testInfo.highest_term, problem_type: testInfo.q_type)
            problem.text = currentProblem.problem
            answer.text = "0"

            nextButton.setTitle("Question \(currentQuestionNumber)/\(testInfo.q_count) →", for: .normal)
        }
    }
    
    
    // 0 - 9 digits
    @IBAction func press_digit(_ sender: UIButton) {
        if answer.text == "0" {
            answer.text = sender.currentTitle == "0" ? "0" : sender.currentTitle
        } else if answer.text == "–" {
            answer.text = sender.currentTitle == "0" ? "–" : "–" + sender.currentTitle!
        } else {
            answer.text = answer.text! + sender.currentTitle!
        }
    }

    @IBAction func press_minus(_ sender: UIButton) {
        assert(answer.text != nil, "Answer field is nil!")
        let n = answer.text!.replacingOccurrences(of: "–", with: "-")
        if n == "0" {answer.text = "–"} else {
            answer.text = Int(n)! >= 0 ? "–" + n : String(abs(Int32(n) ?? 0))
        }
    }
    
    @IBAction func clearAnswer(_ sender: UIButton) {
        answer.text = "0"
    }
    
    @IBAction func deleteDigit(_ sender: UIButton) {
        if answer.text!.lengthOfBytes(using: .utf8) == 1 {
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
        }
        currentQuestionNumber += 1
        progress_bar.progress = Float(currentQuestionNumber) / Float(testInfo.q_count)
        nextQuestion()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func generateProblem(highest_term h: Int, problem_type: Int) ->(problem: String, answer: String) {
        switch problem_type {
        case 0:
            return generateAdditionProblem(h: h)
        case 1:
            return generateMultiplicationProblem(h: h)
        case 2:
            return arc4random_uniform(2) == 0 ? generateAdditionProblem(h: h) : generateMultiplicationProblem(h: h)
        default:
            return ("","")
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
        var terms = [Int]()
        var answer = 0
        for _ in 0..<2 {
            terms.append(10 + Int(arc4random_uniform(UInt32(h - 9)))) // A number from -h to h
            answer *= terms.last! // Last term guaranteed to exist
        }
        let p = terms.map({String($0)}).joined(separator: " × ")
        return (p, String(answer))
    }
    
    @IBAction func dismissView(_ sender: UIButton) {
        self.dismiss(animated: false, completion: {
            testInfo.parentVC?.dismiss(animated: true, completion: nil)
        })
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
