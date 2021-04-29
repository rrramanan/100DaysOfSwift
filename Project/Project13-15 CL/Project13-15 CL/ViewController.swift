//
//  ViewController.swift
//  Project13-15 CL
//
//  Created by R R on 19/01/21.
//

import UIKit

class ViewController: UITableViewController {

    var countriesArray = [Country]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Project13-15 CL"
        if let getCountryUrl = Bundle.main.url(forResource: "country", withExtension: "json"){
            if let getthedata = try? Data(contentsOf: getCountryUrl){
                parse(getData: getthedata)
            }
        }
    }
    
    
    func parse(getData:Data){
        let decoder = JSONDecoder()
        
        if let decodedjson = try? decoder.decode(Countries.self, from: getData){
            countriesArray = decodedjson.countries
            //print(countriesArray[1].capital)
            tableView.reloadData()
        }else{print("NA")}
        
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countriesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = countriesArray[indexPath.row].name
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let sb = storyboard?.instantiateViewController(identifier: "detail") as? DetailViewController{
            sb.detailItem = countriesArray[indexPath.row]
            navigationController?.pushViewController(sb, animated: true)
        }
    }
    
    
}

