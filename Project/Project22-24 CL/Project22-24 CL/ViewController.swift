//
//  ViewController.swift
//  Project22-24 CL
//
//  Created by R R on 12/02/21.
//

extension UIView{
    func bounceOut(duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            self.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        }
    }
}

extension Int{
    func times(action : () -> Void ){
        if self > 0 {
            for _ in 0 ..< self {
                action()
            }
        }else{
            print("Try Again")
            
        }
    }
}

extension Array where Element: Comparable{
    
    mutating func remove(item: Element) {
        if let index = self.firstIndex(of: item) {
            self.remove(at: index)
        }
    }
}

import UIKit

class ViewController: UIViewController {

    @IBOutlet var greenView: UIView!
    
    var intTest = 5
    
    var myarray = [1,2,3,4,5,3,6]
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        intTest.times(){
            print("HOLA")
        }
        
        myarray.remove(item: 12)
        
        greenView.bounceOut(duration: 3)
        
    }


    
}

