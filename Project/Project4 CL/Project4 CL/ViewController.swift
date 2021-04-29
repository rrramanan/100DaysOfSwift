//
//  ViewController.swift
//  Project4 CL
//
//  Created by R R on 18/12/20.
//

import UIKit

class ViewController: UITableViewController {

    var websiteList = ["apple.com","duckduckgo.com","hackingwithswift.com"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websiteList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "list", for: indexPath)
        cell.textLabel?.text = websiteList[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "webboard") as? WebViewController {
            vc.stringReceived = websiteList[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

