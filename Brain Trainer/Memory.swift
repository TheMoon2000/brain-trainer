//
//  MemoryViewController.swift
//  Reaction Timer
//
//  Created by Jia Rui Shan on 10/12/16.
//  Copyright © 2016 Jerry Shan. All rights reserved.
//

import UIKit


//var shouldExit = false

class MemoryViewController: UIViewController {
    
    var mainVC: ViewController?
    
    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var numberOfDigits: UILabel!
    @IBOutlet weak var beginbutton: UIButton!
    @IBOutlet weak var numberOfSeconds: UILabel!
    @IBOutlet weak var digitSlider: UISlider!
    @IBOutlet weak var delaySlider: UISlider!
    @IBOutlet weak var digitType: UISegmentedControl!
    
    var digitArray: [String] = []
    
    static func tintButton(button: UIButton) {
        button.layer.borderWidth = 1
        button.layer.cornerRadius = button.frame.height / 2
        button.layer.borderColor = button.tintColor.cgColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        MemoryViewController.tintButton(button: beginbutton)
        
        bannerView.backgroundColor = bannerTint
        
        let previousdigit = UserDefaults.standard.integer(forKey: "Digits")
        if previousdigit > 0 {
            digitSlider.value = Float(previousdigit)
            numberOfDigits.text = String(previousdigit)
        }
        let previousDelay = UserDefaults.standard.float(forKey: "Delay")
        if previousDelay > 0.0 {
            numberOfSeconds.text = "\(previousDelay)s"
        }
    }
    
    @IBAction func changeDigits(_ sender: UISlider) {
        numberOfDigits.text = "\(Int(sender.value))"
        UserDefaults.standard.set(Int(sender.value), forKey: "Digits")
    }
    
    @IBAction func changeDelay(_ sender: UISlider) {
        let digitDelay = round(sender.value * 10) / 10.0
        UserDefaults.standard.set(digitDelay, forKey: "Delay")
        numberOfSeconds.text = "\(digitDelay)s"
    }
    
    @IBAction func beginTest(_ sender: UIButton) {
        self.performSegue(withIdentifier: "begin_test", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! MemoryTestView
        vc.numberOfItems = Int(self.digitSlider.value)
        vc.digitType = DigitType(rawValue: digitType.selectedSegmentIndex)!
        vc.delay = round(self.delaySlider.value * 10) / 10
        vc.startVC = self
    }
    
    @IBAction func dismissView(_ sender: UIButton) {
        mainVC?.dismiss(animated: true, completion: {
            print("memory view dismissed")
        })
    }
    
}
