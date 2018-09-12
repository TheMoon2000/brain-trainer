//
//  ViewController.swift
//  Brain Trainer
//
//  Created by Jia Rui Shan on 13/06/2017.
//  Copyright © 2017 Jia Rui Shan. All rights reserved.
//

import UIKit

let bannerTint = UIColor(red: 94.0 / 255, green: 59.0 / 255, blue: 164.0 / 255, alpha: 1)

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var trainerTable: UITableView!
    @IBOutlet weak var bannerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainVC = self
        
        bannerView.backgroundColor = bannerTint
        
        // Register the trainer table view cell
        let trainerNib = UINib(nibName: "TrainerCell", bundle: Bundle.main)
        trainerTable.register(trainerNib, forCellReuseIdentifier: "Trainer Cell")
        trainerTable.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == trainerTable {
            return 100
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Trainer Cell") as! TrainerCell
        if tableView == trainerTable && indexPath.row < 3 {
            cell.textLabel?.text = "Test \(indexPath.row)"
            return cell
        } else {
            cell.textLabel?.text = "Achievements"
            return cell
        }
        
//        return TrainerCell()
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if tableView == trainerTable {
            let cell = tableView.cellForRow(at: indexPath) as! TrainerCell
            cell.background.backgroundColor = UIColor(white: 0.9, alpha: 1)
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if tableView == trainerTable {
            let cell = tableView.cellForRow(at: indexPath) as! TrainerCell
            cell.background.backgroundColor = UIColor.white
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == trainerTable {
            switch indexPath.row {
            case 0:
                self.performSegue(withIdentifier: "Reaction Trainer", sender: self)
            case 1:
                self.performSegue(withIdentifier: "Memory Trainer", sender: self)
            case 2:
                self.performSegue(withIdentifier: "Mental Arithmetics", sender: self)
            case 3:
                print("Achievements")
            default:
                break
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Memory Trainer" {
            let vc = segue.destination as! MemoryViewController
            vc.mainVC = self
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
