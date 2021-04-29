//
//  ViewController.swift
//  Project7-9 CL
//
//  Created by R R on 31/12/20.
//

import UIKit

class ViewController: UIViewController {
    var wordArray = [String]()
    var usedArray = [String]()
    var cool = [String]()
    var score = 0
    var wrongAnswer = 0
    var titleWord: String?
    @IBOutlet var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Play", style: .plain, target: self, action: #selector(play))
    
        if let wordUrl = Bundle.main.url(forResource: "start", withExtension: "txt"){
            if let getWords = try? String(contentsOf: wordUrl){
                wordArray = getWords.components(separatedBy: "\n")
            }
        }
        if wordArray.isEmpty{
            wordArray = ["PlayPokemon"]
        }
    
       wordPlay()
    
    }
    

    func wordPlay(){
        titleWord = wordArray.randomElement()
        print("Word =  \(titleWord!)")
        
        guard let titleString = titleWord else {return}
           
        for _ in titleString{
            cool.append("?")
        }
        
        title = "Word: \(cool.joined(separator: ""))   Score: \(score)   Life:\(7 - wrongAnswer)"
    }
    
    
    @objc func play(){
        let ac = UIAlertController(title: "Guess", message: "Enter a letter", preferredStyle: .alert)
        ac.addTextField(){ t in
            t.placeholder = "Enter"
        }
        ac.addAction(UIAlertAction(title: "OK", style: .default){
            [weak self, weak ac] _ in
            guard let inputLetter = ac?.textFields?[0].text else {return}
            
            if inputLetter.count == 1{
                self?.submit(inputLetter)
            }else{
                //print("NOT ALLOWED")
                self?.statusLabel.text = "   Status:   Try 1 Character"
                
            }
        })
        present(ac, animated: true)
    }
     
    
    func submit(_ input:String) {
      
        var tempString = ""
        guard let titleString = titleWord else {return}
        
        for (index,letter) in titleString.enumerated(){
            let conv = String(letter)
            if input == conv{
                if !usedArray.contains(input){
                    cool[index] = input
                    tempString = input
                }
            }
        }
       
        if tempString.isEmpty{
            if !usedArray.contains(input){
                wrongAnswer += 1
                statusLabel.text = "   Status:   Wrong"
            }else{
                statusLabel.text = "   Status:   Repeat"
            }
        }else{
            usedArray.append(tempString)
            statusLabel.text = "   Status:   Correct"
        }
    
//       print("WA: \(wrongAnswer)")
//       print("used \(usedArray)")
//       print("loop \(cool.joined(separator: ""))")
//       print(cool)
        
        title = "Word: \(cool.joined(separator: ""))   Score: \(score)   Life:\(7 - wrongAnswer)"
        
        if cool.joined(separator: "") == titleString{
            print("WIN")
            score += 1
            wrongAnswer = 0
            usedArray.removeAll()
            cool.removeAll()
            statusLabel.text = "   Status:   Victory 🍕🍕"
            wordPlay()
        }else{
            if wrongAnswer == 7{
                print("Level UP")
                score -= 1
                wrongAnswer = 0
                usedArray.removeAll()
                cool.removeAll()
                statusLabel.text = "   Status:   Lost 🧘‍♀️🧘"
                wordPlay()
            }
        }
        
    }
    
  
    
}

