//
//  ViewController.swift
//  Project2
//
//  Created by R R on 16/12/20.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var totalTen = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "🏆", style: .plain, target: self, action:#selector(barbuttonTapped))
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestions()
        
       
    }


    func askQuestions(action: UIAlertAction! = nil){
       //challenge..
        if totalTen == 10 {
            title = "Flag: \(countries[correctAnswer].uppercased())    Score: \(score)"
            totalTen = 0
            gameOver()
            score = 0
        }else{
            
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)
            
            button1.setImage(UIImage(named: countries[0]), for: .normal)
            button2.setImage(UIImage(named: countries[1]), for: .normal)
            button3.setImage(UIImage(named: countries[2]), for: .normal)

            //title = countries[correctAnswer].uppercased()
            //challenge ..
            title = "Flag: \(countries[correctAnswer].uppercased())    Score: \(score)"
        }
        
    }
    
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        totalTen += 1
        print(totalTen)
        
       
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
            askQuestions()
            
        }else{
            title = "Wrong"
            score -= 1
            
            //challenge..
            let ac = UIAlertController(title: "", message: "\(title)! That's the flag of \(countries[sender.tag].uppercased())", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestions))
            present(ac, animated: true, completion: nil)
        }
        
      
//        let ac = UIAlertController(title: title, message: "Your Score is \(score)", preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestions))
//        present(ac, animated: true, completion: nil)
        
        
    }
    
    //challenge..
    func gameOver()  {
            let ac = UIAlertController(title: "Game Over", message: "Your Final Score is \(score)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: askQuestions))
            present(ac, animated: true, completion: nil)
    }
    
  @objc func barbuttonTapped() {
        let alert = UIAlertController(title: "Score", message: "Your current score is \(score)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}

