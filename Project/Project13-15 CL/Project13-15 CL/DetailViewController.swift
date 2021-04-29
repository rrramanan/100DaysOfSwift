//
//  DetailViewController.swift
//  Project13-15 CL
//
//  Created by R R on 19/01/21.
//

import UIKit

class DetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    var detailItem: Country?
    
    var detailedArray = [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        print("array \(String(describing: detailItem))")
       
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        title = detailItem?.name
        
        tableView.delegate = self
        tableView.dataSource = self
        
        guard let name = detailItem?.name  else {return}
        guard let capital = detailItem?.capital  else {return}
        guard let currency = detailItem?.currency  else {return}
        guard let population = detailItem?.population  else {return}
        guard let etymology = detailItem?.etymology  else {return}
        guard let ID = detailItem?.countryId  else {return}
        
        detailedArray.append("Name: \(name)")
        detailedArray.append("Capital: \(capital)")
        detailedArray.append("Currency: \(currency)")
        detailedArray.append("Population: \(String(population))")
        detailedArray.append("Etymology: \(etymology)")
        detailedArray.append("Country ID: \(ID)")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailedArray.count
    }
    
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: "cellDetail", for: indexPath) as? DetailCell else{
            fatalError("cell not created")
        }
        cell.detailLabel.text = detailedArray[indexPath.row] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @objc func shareTapped(){
        guard let name = detailItem?.name  else {return}
        guard let capital = detailItem?.capital  else {return}
        guard let currency = detailItem?.currency  else {return}
        guard let population = detailItem?.population  else {return}
        guard let etymology = detailItem?.etymology  else {return}
        guard let ID = detailItem?.countryId  else {return}
        
        let avc = UIActivityViewController.init(activityItems: [name,capital,currency,population,etymology,ID], applicationActivities: [])
        avc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(avc, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
