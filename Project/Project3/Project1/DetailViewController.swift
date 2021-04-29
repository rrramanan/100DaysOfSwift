//
//  DetailViewController.swift
//  Project1
//
//  Created by R R on 15/12/20.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    var totalImage: Int?
    var currentImage: Int?
    var imageName: String?
    
    //challenge
    var sharingImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Picture \(currentImage!) of \(totalImage!)"
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        
        // Do any additional setup after loading the view.
        if let imageToLoad = selectedImage{
            imageName = imageToLoad
            imageView.image = UIImage(named: imageToLoad)
        }
        
        shareImage()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
   @objc func shareTapped(){
    
//    guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
//        print("No image found")
//        return
//    }
    
    //challenge... updated with text
    guard let image = sharingImage?.jpegData(compressionQuality: 0.8) else {
        print("No image found")
        return
    }
    
    let vc = UIActivityViewController(activityItems: [imageName!,image], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true, completion: nil)
    }
    
    //challenge from project27
    func shareImage(){
       
        if let imageToLoad = selectedImage{
            
            let img = UIImage(named: imageToLoad)
            
            guard let size = img?.size else {return}
       
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: size.width, height: size.height))

            let newimage = renderer.image { ctx in
                
                let newImg = UIImage(named: imageToLoad)
                newImg?.draw(at: CGPoint(x: 0, y: 0))
                
                let attr: [NSAttributedString.Key :Any] = [
                    .font: UIFont.systemFont(ofSize: 40),
                    .foregroundColor: UIColor.red
                ]

                let str = "From Storm Viewer"

                let attibutedString = NSMutableAttributedString(string: str, attributes: attr)
                attibutedString.draw(with: CGRect(x: 10, y: 10, width: 400, height: 200), options: .usesLineFragmentOrigin, context: nil)
                
            }
                
            sharingImage = newimage
        }
        
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
