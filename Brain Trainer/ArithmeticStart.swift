//
//  ArithmeticViewController.swift
//  Brain Trainer
//
//  Created by Jia Rui Shan on 2018/8/31.
//  Copyright © 2018 Jerry Shan. All rights reserved.
//

import UIKit

class ArithmeticStartViewController: UIViewController {
    
    @IBOutlet weak var startView: UIView!
    @IBOutlet weak var beginButton: UIButton!
    @IBOutlet weak var numberOfQuestions: UILabel!
    @IBOutlet weak var numberOfQuestions_bar: UISlider!
    @IBOutlet weak var highestTerm: UILabel!
    @IBOutlet weak var highestTerm_bar: UISlider!
    @IBOutlet weak var questionType: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Customize the begin test button
        beginButton.layer.borderWidth = 1
        beginButton.layer.cornerRadius = 21
        beginButton.layer.borderColor = beginButton.tintColor.cgColor
        
        let q = UserDefaults.standard.integer(forKey: "# Questions")
        numberOfQuestions.text = String(q == 0 ? 8 : q)
        numberOfQuestions_bar.value = Float(q == 0 ? 8 : q)
        
        let h = UserDefaults.standard.integer(forKey: "Highest Term")
        highestTerm.text = String(h == 0 ? 50 : h)
        highestTerm_bar.value = Float(h == 0 ? 50 : h)
        
        let t = UserDefaults.standard.integer(forKey: "Arithmetics Question Type")
        questionType.selectedSegmentIndex = t
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: {
            print("arithmetic view dismissed")
        })
    }
    
    @IBAction func changeNumberOfQuestions(_ sender: UISlider) {
        numberOfQuestions.text = "\(Int(sender.value))"
        UserDefaults.standard.set(Int(sender.value), forKey: "# Questions")
    }
    
    @IBAction func changeHighestTerm(_ sender: UISlider) {
        highestTerm.text = "\(Int(sender.value))"
        UserDefaults.standard.set(Int(sender.value), forKey: "Highest Term")
    }
    
    @IBAction func changeQuestionType(_ sender: UISegmentedControl) {
        UserDefaults.standard.set(sender.selectedSegmentIndex, forKey: "Arithmetics Question Type")
    }
    
    @IBAction func beginTest(_ sender: UIButton) {
        testInfo = ArithmeticTestInfo(
            q_count: Int(numberOfQuestions_bar.value),
            highest_term: Int(highestTerm_bar.value),
            q_type: questionType.selectedSegmentIndex,
            parent: self)
        self.performSegue(withIdentifier: "Begin Arithmetics Test", sender: self)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
//            self.dismiss(animated: false, completion: nil)
        }
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
