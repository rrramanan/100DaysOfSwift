//
//  ViewController.swift
//  Project10
//
//  Created by R R on 02/01/21.
//
import LocalAuthentication
import UIKit

class ViewController: UICollectionViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    var people = [Person]()
    
    //challenge
    var addBarButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //****** updated for project 28 challenge *******
        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
//
//        let defaults = UserDefaults.standard
//
//        if let savedPeople = defaults.object(forKey: "people") as? Data{
//            let jsonDecoder = JSONDecoder()
//
//            do{
//             people = try jsonDecoder.decode([Person].self, from: savedPeople)
//            }catch{
//                print("Failed to Load")
//            }
//
//        }
        
        
        //challenge
        title = "Unlock to view"
        addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "🔒", style: .plain, target: self, action: #selector(auth))
        
    }

    
    //challenge
    @objc func auth(){
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Identify yourself!") { [weak self] success, authError in
                
            DispatchQueue.main.async {
                if success{
                    self?.title = "Home"
                    self?.navigationItem.leftBarButtonItem = self?.addBarButton
                    self?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "🔓", style: .plain, target: self, action: #selector(self?.lock))
                    
                    let defaults = UserDefaults.standard

                    if let savedPeople = defaults.object(forKey: "people") as? Data{
                        let jsonDecoder = JSONDecoder()

                        do{
                            self?.people = try jsonDecoder.decode([Person].self, from: savedPeople)
                        }catch{
                            print("Failed to Load")
                        }

                    }
                    
                    self?.collectionView.reloadData()
                
                }else{
                    let ac = UIAlertController(title: "Authentication Failed", message: "You could not be verified: please try again", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self?.present(ac, animated: true)
                }
             }
          }
        }else{
            let ac = UIAlertController(title: "Biometery unavailable", message: "Your device is not configured for biometric authentication", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
        
        
    }
    
    //challenge
    @objc func lock(){
        title = "Unlock to view"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "🔒", style: .plain, target: self, action: #selector(auth))
        navigationItem.leftBarButtonItem = nil
        people.removeAll(keepingCapacity: true)
        collectionView.reloadData()
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("Unable to dequeue PersonCell.")
        }
       
        let person = people[indexPath.item]
        
        cell.name.text = person.name
        
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        return cell
    }
    
    @objc func addNewPerson(){
       //challenge...
       if  UIImagePickerController.isSourceTypeAvailable(.camera){
            print("Yes camera found")
       }else{
            print("camera not found")
       }
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        //picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else{ return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8){
            try? jpegData.write(to: imagePath)
        }
        
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        save()
        collectionView.reloadData()
     
        dismiss(animated: true)
    }
    
    func getDocumentsDirectory() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //challenge....
        let acs = UIAlertController(title: "Options", message: "Rename or Edit your pictures", preferredStyle: .actionSheet)
        acs.addAction(UIAlertAction(title: "Rename", style: .default){
            [weak self] _ in
            self?.rename(indexPath)
        })
        acs.addAction(UIAlertAction(title: "Delete", style: .default){
            [weak self] _ in
            self?.delete(indexPath)
        })
        acs.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(acs, animated: true)
        
    }

    func rename(_ getIndex:IndexPath){
            let person = people[getIndex.item]

            let ac = UIAlertController(title: "Rename", message: nil, preferredStyle: .alert)
            ac.addTextField()
            ac.addAction(UIAlertAction(title: "OK", style: .default){
                [weak self,weak ac] _ in
                guard let newName = ac?.textFields?[0].text else{ return }
                person.name = newName
                self?.save()
                self?.collectionView.reloadData()
            })
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(ac, animated: true)
    }
    
    func delete(_ getIndex:IndexPath){
        people.remove(at: getIndex.item)
        collectionView.reloadData()
    }
    
    func save(){
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(people){
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "people")
        }else{
            print("Failed !!")
        }
    }

}

