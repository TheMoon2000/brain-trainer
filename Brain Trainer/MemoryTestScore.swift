//
//  MemoryTestScore.swift
//  Brain Trainer
//
//  Created by Jia Rui Shan on 2018/9/9.
//  Copyright © 2018 Jia Rui Shan. All rights reserved.
//

import UIKit

class MemoryTestScore: UIViewController {
    
    @IBOutlet weak var bannerView: UIView!
    var answerView: MemoryAnswerView?
    
    //Result
    @IBOutlet weak var resultTitle: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var backToMenu: UIButton!
    @IBOutlet weak var difficultyIndex: UILabel!
    @IBOutlet weak var averageTime: UILabel!
    
    var mainVC: ViewController?
    var memoryStartView: MemoryViewController?
    var digitArray = [String]()
    var userAnswer = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        MemoryViewController.tintButton(button: backToMenu)
        bannerView.backgroundColor = bannerTint
    }

    @IBAction func backToMenu(_ sender: UIButton) {
        answerView?.view.isHidden = true
        memoryStartView?.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func dismissView(_ sender: UIButton) {
        memoryStartView?.mainVC?.dismiss(animated: true, completion: {
//            print("memory view dismissed")
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
