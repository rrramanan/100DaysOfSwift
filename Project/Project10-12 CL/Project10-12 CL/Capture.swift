//
//  Capture.swift
//  Project10-12 CL
//
//  Created by R R on 07/01/21.
//

import UIKit

class Capture: NSObject,NSCoding {
   
    var caption: String
    var image: String
    
    init(caption:String, image:String) {
        self.caption = caption
        self.image = image
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(caption,forKey: "caption")
        coder.encode(image,forKey: "image")
        
    }
    
    required init?(coder: NSCoder) {
        caption = coder.decodeObject(forKey: "caption") as? String ?? ""
        image = coder.decodeObject(forKey: "image") as? String ?? ""
      
    }
    
}
