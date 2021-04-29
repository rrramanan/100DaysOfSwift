//
//  ViewController.swift
//  Project5
//
//  Created by R R on 19/12/20.
//

import UIKit

class ViewController: UITableViewController {
    var allWords = [String]()
    var usedWords = [String]()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        
        
        //challenge
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGamRefresh))
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt"){
            if let startWords = try? String(contentsOf: startWordsURL){
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        
        let defaults = UserDefaults.standard
        if let word = defaults.object(forKey: "word") as? String {
                title = word
            if let usedWord = defaults.object(forKey: "list") as? [String]{
                usedWords = usedWord
            }else{
                print("no used words")
            }
        }else{
            print("no words")
            startGame()
        }
        
        //startGame()
    }

    
   @objc func startGamRefresh(){
        title = allWords.randomElement()
        //challenge new
        let defaults = UserDefaults.standard
        defaults.set(title, forKey: "word")
        defaults.removeObject(forKey: "list")
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    @objc func startGame(){
         title = allWords.randomElement()
         //challenge new
        let defaults = UserDefaults.standard
         defaults.set(title, forKey: "word")
         usedWords.removeAll(keepingCapacity: true)
         tableView.reloadData()
     }
    
    @objc func promptForAnswer(){
        let ac = UIAlertController(title: "Enter Answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default){
            [weak self,weak ac] _ in
            guard let answer = ac?.textFields?[0].text else{ return }
            self?.submit(answer)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()
      
        if isPossbile(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                        //challenge
                        usedWords.insert(lowerAnswer, at: 0)
                        
                    
                        let indexpath = IndexPath(row: 0, section: 0)
                        tableView.insertRows(at: [indexpath], with: .automatic)
                    
                        //challenge new
                        let defaults = UserDefaults.standard
                        defaults.removeObject(forKey: "list")
                        defaults.set(usedWords, forKey: "list")
                    
                }else{
                    showErrorMessage(errorname: "Word not recognised", errormessage:"You can't just make them up, you know!")
                }
            }else{
                showErrorMessage(errorname: "Word used already", errormessage: "Be more original!")
            }
        }else{
            showErrorMessage(errorname: "Word not possible", errormessage: "You can't spell that word from \(title!.lowercased())")
        }
        
      
    
    }
    
    //possible anagram <word> from start word
    func isPossbile(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else {return false}
        //challenge
        if tempWord == word{
            return false
        }else{
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            }else{
                return false
            }
        }
            
    }
        
        return true
    }
    
    //not repeated answers
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    //real word in english
    func isReal(word:String) -> Bool{
      //challenge
        if word.count < 3{
            return false
        }
        
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    //challenge
    func showErrorMessage(errorname: String,errormessage: String){
        let ac = UIAlertController(title: errorname, message: errormessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
}

