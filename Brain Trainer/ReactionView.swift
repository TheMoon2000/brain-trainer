//
//  ReactionViewController.swift
//  Brain Trainer
//
//  Created by Jia Rui Shan on 13/06/2017.
//  Copyright © 2017 Jia Rui Shan. All rights reserved.
//

import UIKit

class ReactionViewController: UIViewController {
    
    @IBOutlet weak var colorbutton: UIButton!
    @IBOutlet weak var prepareButton: UIButton!
    @IBOutlet weak var highscore: UILabel!
    @IBOutlet weak var limit: UISwitch!
    @IBOutlet weak var limitValue: UISlider!
    
    var startTime: TimeInterval = 0.0
    var endTime: TimeInterval = 0.0
    @IBOutlet weak var message: UILabel!
    
    var referenceDate = Date()
    
    let red = UIColor(red: 1, green: 0.45, blue: 0.45, alpha: 1)
    let green = UIColor(red: 0.4, green: 1, blue: 0.45, alpha: 1)
    
    let d = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        colorbutton.backgroundColor = red
        colorbutton.layer.cornerRadius = 6
        colorbutton.isEnabled = false
        
        if d.float(forKey: "High Score") != 0 {
            highscore.text = "High Score: \(d.float(forKey: "High Score"))s"
        }
        if d.bool(forKey: "Limit") {
            limit.isOn = true
        } else {
            limit.isOn = false
            limitValue.isEnabled = false
        }
        if d.float(forKey: "Limit Value") != 0 {
            limitValue.value = (d.float(forKey: "Limit Value") - 0.05) / 0.45
        }
    }

    @IBAction func ready(_ sender: UIButton) {
        colorbutton.backgroundColor = red
        endTime = 0.0
        prepareButton.isEnabled = false
        colorbutton.isEnabled = true
        Thread.detachNewThreadSelector(#selector(self.start), toTarget: self, with: nil)
        colorbutton.setTitle("Get Prepared...", for: UIControlState())
    }
    
    func start() {
        let number = Double(arc4random_uniform(500)) / 100.0 + 1
        Thread.sleep(forTimeInterval: number)
        startTime = Date().timeIntervalSince(referenceDate)
        
        
        if colorbutton.title(for: UIControlState()) != "Press when Color Changes" {
            DispatchQueue.main.async {
                self.colorbutton.backgroundColor = self.green
                self.colorbutton.setTitle("Click Me!", for: UIControlState())
                //colorbutton.setTitle("Click Me!", forState: .Highlighted)
            }
        }
        
        if self.limit.isOn {
            let time = Int(roundf(limitValue.value * 450))
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(time + 48)) {
                if self.colorbutton.backgroundColor == self.green {
                    self.colorbutton.backgroundColor = self.red
                    self.colorbutton.setTitle("Press when Color Changes", for: UIControlState())
                    self.message.text = "You were too slow."
                    self.prepareButton.isEnabled = true
                }
            }
        }
        
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        colorbutton.isEnabled = false
        endTime = Date().timeIntervalSince(referenceDate)
        let time = Float(round((endTime-startTime) * 1000)/1000)
        if sender.backgroundColor == green && (!limit.isOn || time <= limitValue.value * 0.45 + 0.05) {
            message.text = "Reaction time: \(time)"
            if d.float(forKey: "High Score") > time || d.float(forKey: "High Score") == 0 {
                highscore.text = "Highscore: \(time)"
                d.set(time, forKey: "High Score")
            }
            prepareButton.isEnabled = true
            colorbutton.backgroundColor = red
            colorbutton.setTitle("Press when Color Changes", for: UIControlState())
        } else {
            colorbutton.setTitle("Press when Color Changes", for: UIControlState())
            let alert = UIAlertController(title: "You Pressed too Early!", message: "Please only press when the button color turns green", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            startTime = 0.0
            colorbutton.backgroundColor = red
            if limit.isOn && time >= limitValue.value * 0.45 + 0.05 {
                self.message.text = "You were too slow."
            }
        }
        prepareButton.isEnabled = true
    }
    
    @IBAction func dismissView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: {
            print("reaction view dismissed")
        })
    }
    
    @IBAction func switchLimit(_ sender: UISwitch) {
        limitValue.isEnabled = sender.isOn
        d.set(sender.isOn, forKey: "Limit")
        d.set(limitValue.value, forKey: "Limit Value")
    }
    
    var changeLimitTime = 0.0
    
    @IBAction func changeLimit(_ sender: UISlider) {
        let time = roundf(sender.value * 45) / 100 + 0.05
        d.set(time, forKey: "Limit Value")
        highscore.text = "Setting Limit: \(time)"
        changeLimitTime = -referenceDate.timeIntervalSinceNow
        print(sender.value)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if !sender.isHighlighted && -self.referenceDate.timeIntervalSinceNow - self.changeLimitTime > 0.99 {
                if self.d.float(forKey: "High Score") != 0 {
                    self.highscore.text = "High Score: \(self.d.float(forKey: "High Score"))s"
                }
            }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(segue.identifier ?? "unidentified segue")
    }

}
