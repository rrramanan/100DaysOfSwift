//
//  ViewController.swift
//  Project18
//
//  Created by R R on 25/01/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        print(1,2,3,4,5, separator:"-")
        print("some message", terminator:"")
        
      //  assert(1 == 1, "failed")
    //    assert(1==2 , "failed")
        
        for i in 1...100{
            print("the output \(i)")
        }
        
        
    }


}

