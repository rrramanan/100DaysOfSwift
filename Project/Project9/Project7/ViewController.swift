//
//  ViewController.swift
//  Project7
//
//  Created by R R on 25/12/20.
//	

import UIKit

class ViewController: UITableViewController {

    var petitions = [Petition]()
    var filterArray = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Info", style: .plain, target: self, action: #selector(infofunc))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filter))
        
       // loadItem()
  
        performSelector(inBackground: #selector(loadItem), with: nil)
    }
    
   @objc func loadItem(){
        var urlString : String
  
            if  navigationController?.tabBarItem.tag == 0 {
                urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
            }else{
                urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
            }
         
        
//        DispatchQueue.global(qos: .userInitiated).async {
//            [weak self] in
            if let url = URL(string: urlString){
                if let data = try? Data(contentsOf: url){
                    parse(json: data)
                    return
                }
            }
           // showError()
    // }
       
    performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        
    }
    
    @objc func filter(){
        let ac = UIAlertController(title: "Fliter", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let action = UIAlertAction(title: "Done", style: .default ){
            [weak self, weak ac] _ in
            guard let textOutput = ac?.textFields?[0].text else {return}
            self?.submit(textOutput)
        }
        let action1 = UIAlertAction(title: "Clear Filter", style: .destructive, handler: (clearFilter))
        ac.addAction(action)
        ac.addAction(action1)
        present(ac, animated: true)
    }
    
    func submit(_ text: String){
        filterArray.removeAll()
        
        for data in petitions{
            if data.title.contains(text){
                filterArray.append(data)
            }
        }
        
        print(filterArray.count)
        tableView.reloadData()
        
    }
    
    func clearFilter(action:UIAlertAction){
        filterArray = petitions
        tableView.reloadData()
    }

    @objc func infofunc(){
        let ac = UIAlertController(title: "Credits", message: "We The People API of the Whitehouse", preferredStyle: .alert )
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func parse(json: Data){
       let decoder = JSONDecoder()
        
       if let jsonPetitions = try? decoder.decode(Petitions.self, from: json){
            petitions = jsonPetitions.results
            filterArray = petitions
        
//            DispatchQueue.main.async { [weak self] in
//                self?.tableView.reloadData()
//            }
        
        tableView.performSelector(onMainThread: #selector(tableView.reloadData), with: nil, waitUntilDone: false)
            
       }else{
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
       }
        
    }

   @objc  func showError() {
//        DispatchQueue.main.async {
//                [weak self] in
    
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    
//        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return filterArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = filterArray[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = filterArray[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

