//
//  ViewController.swift
//  Project13
//
//  Created by R R on 09/01/21.
//

import CoreImage
import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var intensity: UISlider!
    var currentImage: UIImage!
    var context: CIContext!
    var currentFilter: CIFilter!
    @IBOutlet var changeFilterButton: UIButton!
    @IBOutlet var radius: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "InstaFilter"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        
        context = CIContext()
        currentFilter = CIFilter(name: "CISepiaTone")
        
        intensity.setValue(0, animated: false)
        radius.setValue(0, animated: false)
        
        //challenge
        imageView.alpha = 0
    }
    
    @objc func importPicture(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.isEditing = true
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let myimage = info[.originalImage] as? UIImage else {return}
//        dismiss(animated: true) {
//            self.imageView.alpha = 0
//            self.currentImage = myimage
//
//            let beginImage = CIImage(image: self.currentImage)
//            self.currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
//            self.applyProcessing()
//        }
        
            dismiss(animated: true)
            imageView.alpha = 0
            currentImage = myimage

            let beginImage = CIImage(image: self.currentImage)
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            applyProcessing()
        
        
    }

    @IBAction func changeFilter(_ sender: UIButton) {
        let ac = UIAlertController(title: "Change Filter", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "cancel", style: .cancel))
        
        if let popover = ac.popoverPresentationController{
            popover.sourceView = sender
            popover.sourceRect = sender.bounds
        }
                     
        present(ac, animated: true)
        
    }
    
    func setFilter(action: UIAlertAction){
        
        guard currentImage != nil else {return}
        
        guard let actionTitle = action.title else {return}
        
        //challenge
        changeFilterButton.setTitle(actionTitle, for: .normal)
        
        currentFilter = CIFilter(name: actionTitle)
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        applyProcessing()
    }
    
    @IBAction func save(_ sender: Any) {
        //challenge
        guard let image = imageView.image else {  noImageError() ; return }
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)

    }
    
    @IBAction func intensityChanged(_ sender: Any) {
        applyProcessing()
    }

   // var inputKeys = [String]()
    func applyProcessing(){
        let  inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey){
            print("intensity key")
            currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey)
        }
        
//        if inputKeys.contains(kCIInputRadiusKey){
//            print("radius key")
//            currentFilter.setValue(intensity.value * 200, forKey: kCIInputRadiusKey)
//        }
        
        if inputKeys.contains(kCIInputScaleKey){
            print("scale key")
            currentFilter.setValue(intensity.value * 10, forKey: kCIInputScaleKey)
        }
        
        if inputKeys.contains(kCIInputCenterKey){
            print("center key")
            currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2 ), forKey: kCIInputCenterKey)
        }
 
        
        guard let image = currentFilter.outputImage else {return}

        //currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey)

        if let cgimg = context.createCGImage(image, from: image.extent){
            let processedImage = UIImage(cgImage: cgimg)
            imageView.image = processedImage
            
            //challenge
            
            UIView.animate(withDuration: 0.5, delay: 0.1, options: []) {
                self.imageView.alpha = 1
            } completion: { finished in
               //
            }
            
        }
        
        

        
    }
    
   @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        changeFilterButton.setTitle("Change Filter", for: .normal)
        if let error = error {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }

    func noImageError(){
        let ac = UIAlertController(title: "Save Error", message: "No Image Found", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }

    
    @IBAction func radiusChanged(_ sender: Any) {
        changeRadius()
    }
    
    func changeRadius(){
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputRadiusKey){
            print("yes redius")
            currentFilter.setValue(radius.value * 200 , forKey: kCIInputRadiusKey)
        }else{
            print("no radius")
           // return
        }
        
        guard let image = currentFilter.outputImage else {return}
        
        if let cgimg = context.createCGImage(image, from: image.extent){
            let processedImage = UIImage(cgImage: cgimg)
            imageView.image = processedImage
        }
    }
    
    
}

/*
 
 bump - radius, scale, center
 blur - radius
 pixel - scale, center
 sepia - instensity
 twirl - radius, center
 unsharp - intensity, radius
 vignette - intensity, radius
 
 
 
 */
