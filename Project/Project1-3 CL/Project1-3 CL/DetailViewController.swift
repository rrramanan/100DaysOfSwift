//
//  DetailViewController.swift
//  Project1-3 CL
//
//  Created by R R on 16/12/20.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var imageSelected: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if let imageToLoad = imageSelected{
        title = imageToLoad
        imageView.image = UIImage(named: imageToLoad)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action:#selector(buttonCalled))
    }
    
    @objc func buttonCalled(){
        
        guard let imagenamed = imageSelected else {
            print("no name here !!")
            return
        }
        
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8)  else {
            print("nothing")
            return
        }
        
        let avc = UIActivityViewController(activityItems: [imagenamed,image], applicationActivities: [])
        avc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(avc, animated: true, completion: nil)
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
