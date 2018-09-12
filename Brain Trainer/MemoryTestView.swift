//
//  MemoryTestView.swift
//  Brain Trainer
//
//  Created by Jia Rui Shan on 2018/9/9.
//  Copyright © 2018 Jia Rui Shan. All rights reserved.
//

import UIKit

func customButton(buttons: [UIButton], borderColor: CGColor) {
    for b in buttons {
        b.layer.borderWidth = 1
        b.layer.borderColor = borderColor
    }
}

enum DigitType: Int {
    case digits = 0
    case letters = 1
    case both = 2
}

class MemoryTestView: UIViewController {
    
    // Inherited variable bindings
    var startVC: MemoryViewController?
    var digitType: DigitType = .digits
    var numberOfItems = 0
    var delay: Float = 0
    
    @IBOutlet weak var bannerView: UIView!
    
    //Test
    @IBOutlet weak var digit: UILabel!
    @IBOutlet weak var timeRemaining: UIProgressView!
    @IBOutlet weak var timeRemainingPrompt: UILabel!
    @IBOutlet weak var digitIndex: UILabel!
    @IBOutlet weak var testProgress: UIProgressView!
    
    static let alphabets = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q",
                     "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    static let both = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q",
                "r", "s", "t", "u", "v", "w", "x", "y", "z", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
    
    var digitArray: [String] = []
    var time: Double = 0.0
    var timeToStop = false

    
    override func viewDidLoad() {
        super.viewDidLoad()

        bannerView.backgroundColor = bannerTint
        
        startTest()
    }

    @IBAction func dismissView(_ sender: UIButton) {
        timeToStop = true
        startVC?.mainVC?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func exitText(_ sender: UIButton) {
        timeToStop = true
        startVC?.dismiss(animated: true, completion: nil)
    }
    
    func startTest() {
        
        //Initialize the Test
        timeRemainingPrompt.text = "Get Prepared..."
        digitIndex.text = ""
        testProgress.isHidden = true
        digit.text = ""
        timeRemaining.isHidden = true
        timeRemaining.progress = 0
        testProgress.progress = 0
        
        digitArray = []
        
        
        Thread.detachNewThreadSelector(#selector(MemoryTestView.test), toTarget: self, with: nil)
    }
    
    func setStringForDigit(_ string: String) {
        digit.text = string
    }
    
    func progressInit() {
        timeRemaining.isHidden = false
        digitIndex.text = "Item 1 of \(numberOfItems)"
        timeRemaining.setProgress(0.0, animated: true)
        testProgress.isHidden = false
        testProgress.setProgress(0.0, animated: true)
    }
    
    func setProgress() {
        timeRemaining.setProgress(Float(time) / delay, animated: false)
        let roundedTime = delay - round(Float(time) * 10) / 10
        if roundedTime == 1.0 {
            timeRemainingPrompt.text = "1.0 second left"
        } else {
            timeRemainingPrompt.text = "\(roundedTime) seconds left"
        }
    }
    
    func setDigitProgress() {
        print(digitArray.count)
        testProgress.setProgress(Float(digitArray.count) / Float(numberOfItems), animated: true)
        digitIndex.text = "Item \(digitArray.count) of \(numberOfItems)"
    }
    
    func test() {
        for i in 0..<3 {
            self.performSelector(onMainThread: #selector(MemoryTestView.setStringForDigit(_:)), with: String(3 - i), waitUntilDone: false)
            Thread.sleep(forTimeInterval: 0.99)
        }
        
        self.performSelector(onMainThread: #selector(MemoryTestView.progressInit), with: nil, waitUntilDone: false)
        
        for _ in 0..<numberOfItems {
            if timeToStop {Thread.exit()}
            var d = ""
            
            switch digitType {
            case .digits:
                d = String(arc4random_uniform(9))
            case .letters:
                d = MemoryTestView.alphabets[Int(arc4random_uniform(26))]
            case .both:
                d = MemoryTestView.both[Int(arc4random_uniform(36))]
            }
            
            digitArray.append(d)
            
            self.performSelector(onMainThread: #selector(MemoryTestView.setStringForDigit(_:)), with: d, waitUntilDone: false)
            self.performSelector(onMainThread: #selector(MemoryTestView.setDigitProgress), with: nil, waitUntilDone: false)
            //            timeRemaining.setProgress(0.0, animated: true)
            let beginTime = Date.timeIntervalSinceReferenceDate
            
            time = 0.0
            
            
            while time < Double(delay) {
                time = Date.timeIntervalSinceReferenceDate - beginTime
                self.performSelector(onMainThread: #selector(MemoryTestView.setProgress), with: nil, waitUntilDone: false)
                Thread.sleep(forTimeInterval: 0.004)
            }
        }
        self.performSegue(withIdentifier: "to_answer_view", sender: self)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! MemoryAnswerView
        vc.digitArray = digitArray
        vc.startVC = startVC
        vc.testViewVC = self
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
