//
//  ViewController.swift
//  Project1
//
//  Created by R R on 14/12/20.
//

import UIKit

class ViewController: UITableViewController {

    var pictures = [String]()
    var countArray = [Int]()
    let defaults = UserDefaults.standard
    var entryFlag = false
    var currentIndex: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
        title = "Strom Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(buttonTapped))
       
        if let loadCounts = defaults.object(forKey: "imagecount") as? [Int] {
            entryFlag = true
            countArray = loadCounts
            print("load from ::: \(countArray)")
        }else{
            print("not found")
        }
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let fm = FileManager.default
            let path = Bundle.main.resourcePath!
            let items = try! fm.contentsOfDirectory(atPath: path)
            
            for item in items {
                if item.hasPrefix("nssl") {
                    self?.pictures.append(item)
                    if  !(self!.entryFlag) {
                        self?.countArray.append(0)
                    }
                }
            }
            self?.pictures.sort()
        }
       
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
        //print(pictures)
        //print(pictures.sorted())
       
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        cell.detailTextLabel?.text = "View Count: \(String(countArray[indexPath.row]))"
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController{
            vc.selectedImage = pictures[indexPath.row]
            vc.totalImage = pictures.count
            vc.currentImage = indexPath.row + 1
            
            //challenge
            currentIndex = indexPath
            countArray[indexPath.row] = countArray[indexPath.row] + 1
            //print(countArray)
            defaults.setValue(countArray, forKey: "imagecount")
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    @objc func buttonTapped(){
        let url = URL(string:"https://www.hackingwithswift.com/100/16")
        let vc = UIActivityViewController(activityItems: ["Hey! This is my app. Install and view the stroms",url!], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //tableView.reloadData()
        if let ind = currentIndex {
          tableView.reloadRows(at: [ind], with: .none)
        }
    }
   
}


