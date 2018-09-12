//
//  ArithmeticResultViewController.swift
//  Brain Trainer
//
//  Created by Jia Rui Shan on 2018/9/2.
//  Copyright © 2018 Jia Rui Shan. All rights reserved.
//

import UIKit

struct ArithmeticTestResult {
    let duration: TimeInterval
    let totalQuestions: Int
    let correctAnswers: Int
    let highestTerm: Int
    let questionType: QuestionType
    let testVC: ArithmeticTestViewController
    var incorrectCases: [(problem: String, index: Int, answer: String, userAnswer: String)]
    
    var percentage: Int {
        return Int(round(Double(correctAnswers) / Double(totalQuestions) * 100))
    }
    
    var avgspeed: Double {
        return round(duration / Double(totalQuestions) * 10) / 10
    }
    
    init(totalQuestions: Int, highestTerm: Int, correctAnswers: Int, duration: TimeInterval, questionType: QuestionType, testVC: ArithmeticTestViewController, incorrectCases: [(problem: String, index: Int, answer: String, userAnswer: String)]) {
        self.totalQuestions = totalQuestions
        self.highestTerm = highestTerm
        self.correctAnswers = correctAnswers
        self.duration = duration
        self.questionType = questionType
        self.testVC = testVC
        self.incorrectCases = incorrectCases
    }
}

var arithmeticResult: ArithmeticTestResult?


class ArithmeticResultViewController: UIViewController {
    
    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var pageTitle: UILabel!
    @IBOutlet weak var titleMessage: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var difficulty: UILabel!
    @IBOutlet weak var checkWrongAnswers: UIButton!
    
    @IBOutlet weak var tryAgain: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        bannerView.backgroundColor = bannerTint
        
        MemoryViewController.tintButton(button: tryAgain)
        
        titleMessage.text = messageForPercentage(percentage: arithmeticResult!.percentage)
        subtitle.text = "Avg. speed: \(arithmeticResult!.avgspeed)s / answer"
        score.text = "\(arithmeticResult!.correctAnswers)/\(arithmeticResult!.totalQuestions)"
        
        checkWrongAnswers.isHidden = arithmeticResult!.correctAnswers == arithmeticResult!.totalQuestions
    }
    
    func messageForPercentage(percentage: Int) -> String {
        if percentage == 100 {
            return "Perfect! 100% Correct!"
        } else if percentage >= 95 {
            return "\(percentage)%. You've made it!"
        } else if percentage >= 90 {
            return "Excellent - \(percentage)%!"
        } else if percentage >= 80 {
            return "Satisfactory - \(percentage)%."
        } else {
            return "\(percentage)%. Seriously?"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tryAgain(_ sender: UIButton) {
        testInfo.parentVC?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func checkAnswers(_ sender: UIButton) {
        self.performSegue(withIdentifier: "incorrect_answers", sender: self)
    }
    
    @IBAction func dismissView(_ sender: UIButton) {
//        self.dismiss(animated: false, completion: {
//            arithmeticResult!.testVC.dismiss(animated: false, completion: {
//                testInfo.parentVC?.dismiss(animated: false, completion: nil)})
//        })
//        arithmeticResult?.testVC.dismiss(animated: false, completion: nil)
//        testInfo.parentVC?.dismiss(animated: false, completion: nil)
         mainVC.dismiss(animated: true, completion: nil)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//         Get the new view controller using segue.destinationViewController.
//         Pass the selected object to the new view controller.
        let vc = segue.destination as! IncorrectAnswerViewController
        vc.incorrectNumbers = arithmeticResult!.incorrectCases
    }
    

}
