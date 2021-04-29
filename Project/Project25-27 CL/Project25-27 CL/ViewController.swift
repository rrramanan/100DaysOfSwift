//
//  ViewController.swift
//  Project25-27 CL
//
//  Created by R R on 19/02/21.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var imageView: UIImageView!
    var topString: String?
    var bottomString: String?
    var showCaptionOne = true
    var showCaptionTwo = true
    var loadImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Project25-27"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
    }

    @objc func shareTapped(){
          guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {return}
    
          let vc = UIActivityViewController(activityItems: ["Project25-27 CL",image], applicationActivities: [])
              vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
              present(vc, animated: true, completion: nil)
      }
    
    @IBAction func addPhoto(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.isEditing = true
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {return}
        imageView.image = image
        loadImage = image
        dismiss(animated: true)
    }
    
    @IBAction func addCaption(_ sender: Any) {
        
        let alertView = UIAlertController(title: "Option", message: "Add/Show/Hide Caption", preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Add Caption1", style: .default, handler: { [weak self] _ in
            
            if self?.imageView.image != nil {
                if self?.showCaptionOne == true{
                    self?.captionOne()
                }
            }
            
        }))
        alertView.addAction(UIAlertAction(title: "Add Caption2", style: .default, handler: { [weak self] _ in
            
            if self?.imageView.image != nil {
                if self?.showCaptionTwo == true{
                self?.captionTwo()
                }
            }
            
        }))
        alertView.addAction(UIAlertAction(title: "Show/Hide Caption1", style: .default, handler: { [weak self] _ in
           
            guard self?.topString != nil else {return}
            
            if self?.showCaptionOne == false{
                self?.showCaptionOne = true
                self?.render()
            }else{
                self?.showCaptionOne = false
                self?.render()
            }
            
        }))
        alertView.addAction(UIAlertAction(title: "Show/Hide Caption2", style: .default, handler: { [weak self] _ in
           
            guard self?.bottomString != nil else {return}
            
            if self?.showCaptionTwo == false{
                self?.showCaptionTwo = true
                self?.render()
            }else{
                self?.showCaptionTwo = false
                self?.render()
            }
            
        }))
        alertView.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        present(alertView, animated: true)
        
    }
    
    
    func captionOne(){
        let ac = UIAlertController(title: "Caption One", message: "This caption will placed at top of the photo", preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self] action in
            guard let text = ac.textFields?[0].text else {return}
            if text.isEmpty{ return }
            self?.topString = text
            self?.render()
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .default))
        present(ac, animated: true)
        
    }
   
    
    func captionTwo(){
        let ac = UIAlertController(title: "Caption Two", message: "This caption will placed at bottom of the photo", preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self] _ in
            guard let text = ac.textFields?[0].text else {return}
            if text.isEmpty{ return }
            self?.bottomString = text
            self?.render()
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .default))
        present(ac, animated: true)
        
    }
    
    
    func render(){
        
        imageView.image = loadImage
        
        guard let imgSize = imageView.image?.size else { return }
            
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: imgSize.width, height: imgSize.height))
        
        let image = renderer.image { _ in
            
            if let imag = imageView.image{
                imag.draw(at: CGPoint(x: 0, y: 0))
            }
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attribute : [NSAttributedString.Key : Any] = [
                .font: UIFont.systemFont(ofSize: 190),
                .paragraphStyle: paragraphStyle,
                .strokeColor: UIColor.orange,
                .strokeWidth: 7.0,
                .backgroundColor: UIColor.black
            ]
            
            if showCaptionOne{
                if let topString = topString {
                    let attributeStringOne = NSAttributedString(string: topString, attributes: attribute)
                    attributeStringOne.draw(with: CGRect(x: 30, y: 50, width: imgSize.width - 100, height: 500), options:.usesLineFragmentOrigin, context: nil)
                }
            }else{
                if var topString = topString {
                    topString = ""
                    let attributeStringOne = NSAttributedString(string: topString, attributes: attribute)
                    attributeStringOne.draw(with: CGRect(x: 50, y: 50, width: imgSize.width - 100, height: 500), options:.usesLineFragmentOrigin, context: nil)
                }
            }
            
            
            if showCaptionTwo{
                if let bottomString = bottomString{
                    let attributeStringTwo = NSAttributedString(string: bottomString, attributes: attribute)
                    attributeStringTwo.draw(with: CGRect(x: 20, y: imgSize.height - 450, width: imgSize.width - 100, height: 500), options: .usesLineFragmentOrigin, context: nil)
                }
            }else{
                if var bottomString = bottomString{
                    bottomString = ""
                    let attributeStringTwo = NSAttributedString(string: bottomString, attributes: attribute)
                    attributeStringTwo.draw(with: CGRect(x: 20, y: imgSize.height - 450, width: imgSize.width - 100, height: 500), options: .usesLineFragmentOrigin, context: nil)
                }
            }
            
        }
        
        imageView.image = image
    
    }
    
    

}

