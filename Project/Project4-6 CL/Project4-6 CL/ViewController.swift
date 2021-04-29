//
//  ViewController.swift
//  Project4-6 CL
//
//  Created by R R on 23/12/20.
//

import UIKit

class ViewController: UITableViewController {
    var shoppingArray = [String]()
   // var newarray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Shopping List"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addlist))
        let bbi1 = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(clearTable))
        let bbi2 =  UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(activitycontrol))
        navigationItem.setLeftBarButtonItems([bbi1,bbi2], animated: true)
    }
   
    @objc func clearTable(){
        shoppingArray.removeAll()
        tableView.reloadData()
    }
    
    @objc func activitycontrol(){
        let list = shoppingArray.joined(separator: "\n")
        print(list)
        //newarray = list.components(separatedBy: "\n")
        //print(newarray)
        
        let avc = UIActivityViewController(activityItems: [list], applicationActivities: [])
        present(avc, animated: true)
        
    }
    
    @objc func addlist(){
        
        let avc = UIAlertController(title: "Add New Item", message: "Enter your shopping list", preferredStyle: .alert)
        avc.addTextField()
        
        let action = UIAlertAction(title: "OK", style: .default){
            [weak self, weak avc] _ in
            guard let textoutput = avc?.textFields?[0].text else{return}
            self?.submitlist(textoutput)
            
        }
        avc.addAction(action)
        present(avc, animated: true)
        
    }
    
   
    func submitlist(_ textoutput: String){
        print(textoutput)
        
        //insert in top
        shoppingArray.insert(textoutput, at: 0)
        
        //insert in bottom
       // shoppingArray.append(textoutput)
        print(shoppingArray)
        

        //bottom
        //let indexpath = IndexPath(row: shoppingArray.count - 1, section: 0)
        //tableView.insertRows(at: [indexpath], with: .automatic)
        
        //top
       let indexpath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexpath], with: .automatic)
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shop", for: indexPath)
        cell.textLabel?.text = shoppingArray[indexPath.row]
        return cell
    }

}

