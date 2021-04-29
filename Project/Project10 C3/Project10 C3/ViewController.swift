//
//  ViewController.swift
//  Project10 C3
//
//  Created by R R on 02/01/21.
//

import UIKit

class ViewController: UICollectionViewController {
    var pictures = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Strom Viewer Collection"
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
       
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
        }
        pictures.sort()
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? imageCell else{
            fatalError("The Error")
        }
        cell.name.text = pictures[indexPath.item]
        cell.image.image = UIImage(named: pictures[indexPath.item])
        return cell
    }
    
}

