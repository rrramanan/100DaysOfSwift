//
//  ViewController.swift
//  Project19-21 CL
//
//  Created by R R on 05/02/21.
//

import UIKit

class ViewController: UITableViewController {

   static var loadNotes = [Notes]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Notes #Project19-21 CL"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        decode()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ViewController.loadNotes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = ViewController.loadNotes[indexPath.row].title
        cell.detailTextLabel?.text = ViewController.loadNotes[indexPath.row].content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let sb = storyboard?.instantiateViewController(identifier: "detailvc") as? DetailViewController {
            sb.getNotesBody = ViewController.loadNotes[indexPath.row].content
            sb.rowID = indexPath.row
            navigationController?.pushViewController(sb, animated: true)
        }
    }
    
    
    @IBAction func newNotes(_ sender: Any) {
        if let sb = storyboard?.instantiateViewController(identifier: "detailvc") as? DetailViewController {
        navigationController?.pushViewController(sb, animated: true)
        }
    }
    
    
    func decode(){
        let defaults = UserDefaults.standard
        if let savedPeople = defaults.object(forKey: "notesdata") as? Data{
            let jsonDecoder = JSONDecoder()
            do{
                ViewController.loadNotes = try jsonDecoder.decode([Notes].self, from: savedPeople)
            }catch{
                print("Failed to Load")
            }
        }else{
            print("nothing !")
        }
    }
    
    
}

