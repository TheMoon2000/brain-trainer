//
//  ViewController.swift
//  Brain Trainer
//
//  Created by Jia Rui Shan on 13/06/2017.
//  Copyright © 2017 Jia Rui Shan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var trainerTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register the trainer table view cell
        let trainerNib = UINib(nibName: "TrainerCell", bundle: Bundle.main)
        trainerTable.register(trainerNib, forCellReuseIdentifier: "Trainer Cell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
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
        if tableView == trainerTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Trainer Cell") as! TrainerCell
            cell.textLabel?.text = "Test \(indexPath.row)"
            return cell
        }
        
        return TrainerCell()
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
            default:
                break
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

