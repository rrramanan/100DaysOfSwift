//
//  ViewController.swift
//  Project10-12 CL
//
//  Created by R R on 07/01/21.
//

import UIKit


class ViewController: UITableViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    var caputre = [Capture]()
    var holdImage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Project 10-12 CL"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(captureimage))
 
        if let dataRecieved = UserDefaults.standard.object(forKey: "loadData") as? Data{
            if let data = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(dataRecieved) as? [Capture]{
                print("data is \(data.count)")
                caputre = data
            }
        }else{
            print("data is not stored")
        }
        
    }

    @objc func captureimage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else {return}

        let imageName = UUID().uuidString
        holdImage = imageName
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegdata = image.jpegData(compressionQuality: 0.7){
           try?  jpegdata.write(to: imagePath)
        }
        
        
        dismiss(animated: true)
        captionAlert()
    }
    
    func getDocumentsDirectory() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func captionAlert(){
        let ac = UIAlertController(title: "Add Caption", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Ok", style: .default){
            [weak self,weak ac] _ in
            
            guard let captionString = ac?.textFields?[0].text else{return}
            let captureData = Capture(caption: captionString, image:(self?.holdImage)!)
            self?.caputre.append(captureData)
            self?.save()
            self?.tableView.reloadData()
        })
        present(ac, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return caputre.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PhotoCell else{
            fatalError("cell not created")
        }
        cell.captionLabel?.text = caputre[indexPath.row].caption
        cell.userImage?.image = UIImage(named: getDocumentsDirectory().appendingPathComponent(caputre[indexPath.row].image).path)
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let sb = storyboard?.instantiateViewController(identifier: "detailvc") as? DetailVIewController {
            sb.imageLoad = UIImage(named: getDocumentsDirectory().appendingPathComponent(caputre[indexPath.row].image).path)
            sb.getCaption = caputre[indexPath.row].caption
            navigationController?.pushViewController(sb, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func save(){
        if let datatosave = try? NSKeyedArchiver.archivedData(withRootObject: caputre, requiringSecureCoding: false){
            print("datatosave \(datatosave)")
            let defaults = UserDefaults.standard
            defaults.set(datatosave, forKey: "loadData")
            print("save coutn = \(caputre.count)")
            
        }else{
            print("not saved")
        }
        
    }
    
}

