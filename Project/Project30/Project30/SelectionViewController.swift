//
//  SelectionViewController.swift
//  Project30
//
//  Created by TwoStraws on 20/08/2016.
//  Copyright (c) 2016 TwoStraws. All rights reserved.
//

import UIKit

class SelectionViewController: UITableViewController {
	var items = [String]() // this is the array that will store the filenames to load
	//var viewControllers = [UIViewController]() // create a cache of the detail view controllers for faster loading
	var dirty = false
    
    //challenge
    var imageArray = [UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()

		title = "Reactionist"

		tableView.rowHeight = 90
		tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

		// load all the JPEGs into our array
		let fm = FileManager.default

        //challenge
        if let path = Bundle.main.resourcePath {
            if let tempItems = try? fm.contentsOfDirectory(atPath: path) {
                for item in tempItems {
                    if item.range(of: "Large") != nil {
                        items.append(item)
                        
                        //challenge
                        let imagePath = getDocumentsDirectory().appendingPathComponent(item)
                        let itemPath = Bundle.main.path(forResource: item, ofType: nil)!
                       
                        if fm.fileExists(atPath: imagePath.path){
                            let img = loadImage(fileName: item)
                            imageArray.append(img)
                        }else{
                            let image = UIImage(contentsOfFile: itemPath)!
                            if let jpegData = image.jpegData(compressionQuality: 0.8){
                                try? jpegData.write(to: imagePath)
                            }
                            let img = loadImage(fileName: item)
                            imageArray.append(img)
                        }
                        
                    }
                }
            }
        }
        
       
    }
    
    //challenge
    func getDocumentsDirectory() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		if dirty {
			// we've been marked as needing a counter reload, so reload the whole table
			tableView.reloadData()
		}
	}

    // MARK: - Table view data source

	override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return items.count * 10
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let currentImage = items[indexPath.row % items.count]
    
		cell.imageView?.image = imageArray[indexPath.row % items.count]   // loadImage(fileName: currentImage)
        
		// give the images a nice shadow to make them look a bit more dramatic
		cell.imageView?.layer.shadowColor = UIColor.green.cgColor
		cell.imageView?.layer.shadowOpacity = 1
		cell.imageView?.layer.shadowRadius = 10
		cell.imageView?.layer.shadowOffset = CGSize.zero
        let rendererRect = CGRect(origin: .zero, size: CGSize(width: 90, height: 90))
        cell.imageView?.layer.shadowPath = UIBezierPath(ovalIn: rendererRect).cgPath
        
		// each image stores how often it's been tapped
		let defaults = UserDefaults.standard
		cell.textLabel?.text = "\(defaults.integer(forKey: currentImage))"

		return cell
    }

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let vc = ImageViewController()
		vc.image = items[indexPath.row % items.count]
		vc.owner = self

		// mark us as not needing a counter reload when we return
		dirty = false

		// add to our view controller cache and show
		//viewControllers.append(vc)
		//navigationController!.pushViewController(vc, animated: true)
        
        //challenge
        if let nvc = navigationController{
            nvc.pushViewController(vc, animated: true)
        }
        
	}
    
    //challenge
    func loadImage(fileName: String) -> UIImage{
        let path = getDocumentsDirectory().appendingPathComponent(fileName)
        let original = UIImage(contentsOfFile: path.path)!
        
        let rendererRect = CGRect(origin: .zero, size: CGSize(width: 90, height: 90))
        let renderer = UIGraphicsImageRenderer(size: rendererRect.size)
    
        let rounded = renderer.image { ctx in
            ctx.cgContext.addEllipse(in:rendererRect)
            ctx.cgContext.clip()
            original.draw(in: rendererRect)
        }
        return rounded
    }
    
    
    /*
    func oldFunc_table_cellfor(){
     
         //var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "Cell")

         //if cell == nil {
           //  cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        // }
     
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        //let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")

        // find the image for this cell, and load its thumbnail
        let currentImage = items[indexPath.row % items.count]
        let imageRootName = currentImage.replacingOccurrences(of: "Large", with: "Thumb")
        let path = Bundle.main.path(forResource: imageRootName, ofType: nil)!
        let original = UIImage(contentsOfFile: path)!

        let rendererRect = CGRect(origin: .zero, size: CGSize(width: 90, height: 90))
        let renderer = UIGraphicsImageRenderer(size: rendererRect.size)
        
        //let renderer = UIGraphicsImageRenderer(size: original.size)

        let rounded = renderer.image { ctx in
            //ctx.cgContext.setShadow(offset: .zero, blur: 200, color: UIColor.black.cgColor)
            //ctx.cgContext.fillEllipse(in: CGRect(origin: .zero, size: original.size))
            //ctx.cgContext.setShadow(offset: .zero, blur: 0, color: nil)
            
            ctx.cgContext.addEllipse(in:rendererRect)
            //ctx.cgContext.addEllipse(in: CGRect(origin: CGPoint.zero, size: original.size))
            ctx.cgContext.clip()

            original.draw(in: rendererRect)
            //original.draw(at: CGPoint.zero)
        }

        cell.imageView?.image = rounded
        
        // give the images a nice shadow to make them look a bit more dramatic
        cell.imageView?.layer.shadowColor = UIColor.green.cgColor
        cell.imageView?.layer.shadowOpacity = 1
        cell.imageView?.layer.shadowRadius = 10
        cell.imageView?.layer.shadowOffset = CGSize.zero
        cell.imageView?.layer.shadowPath = UIBezierPath(ovalIn: rendererRect).cgPath
        
        // each image stores how often it's been tapped
    }
    */
    
}
