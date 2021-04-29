//
//  DetailVIewController.swift
//  Project10-12 CL
//
//  Created by R R on 07/01/21.
//

import UIKit

class DetailVIewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    var imageLoad: UIImage?
    var getCaption: String?
    override func viewDidLoad() {
        super.viewDidLoad()

       // Do any additional setup after loading the view.
       
        
        guard let caption = getCaption  else {
            title = "Caption NA"
            return
        }
        
        title = caption
        
        if let im = imageLoad{
            imageView.image = im
        }else{
            print("nope")
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
